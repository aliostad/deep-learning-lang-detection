module BricksCore

(** BRICKS, F# COMPUTATION EXPRESSIONS AND COMBINATORS FOR LAZY INCREMENTAL COMPUTATION, SEE README.MD **)

open System
open System.Diagnostics
open System.Collections.Immutable
open System.Collections.Generic
open System.Linq

open Collections
open Trampoline

(** BRICK, ENVIRONMENT **)

#nowarn "0346" // for Beacon.GetHashCode()

[<CustomEquality>][<CustomComparison>]
type Beacon = { mutable valid: bool; mutable tag: obj }
    with
        interface IComparable with
            member this.CompareTo other =
                this.GetHashCode().CompareTo (other.GetHashCode())

        override this.Equals(other) =
            Object.ReferenceEquals(this, other)

        member this.invalidate() = this.valid <- false

        static member create = { valid = false; tag = null }

type Tick = int64

type Versioned = interface
        abstract member value : (Tick * obj)
        abstract member tail : Versioned seq
    end


[<AutoOpen>]
module VersionedExtensions = 

    type Versioned with
        member this.last =
            let t = this.tail
            if Seq.isEmpty t then
                this
            else 
                Seq.last t

type Node = 
    | Mutable
    | Computed of BeaconNode list
    | Managed of BeaconNode * (unit -> unit)

and BeaconNode = Beacon * Node

type Brick =
    abstract member versioned : Versioned with get
    abstract member node : BeaconNode
    abstract member evaluateT: unit -> ITramp<obj>

let private propagateInvalidation beaconNode = 

    let tag = obj()

    let nest beacon notify = 
        fun () ->
            if (beacon.valid) then
                beacon.valid <- false
                notify()

    let rec propagate todo =
        match todo with
        | [] -> ()
        | (_, [])::rest -> propagate rest
        | (notify, (beacon, node) :: rest) :: rest2 ->
            let rest = ((notify, rest)::rest2)
            if beacon.tag = tag then
                propagate rest 
            else
                beacon.tag <- tag
                if not beacon.valid then 
                    notify()
                match node with
                | Mutable -> propagate rest
                | Managed (dep, _) ->
                    let n = nest beacon notify
                    propagate ((n, [dep])::rest)
                | Computed deps ->
                    let n = nest beacon notify
                    propagate ((n, deps)::rest)          

    propagate [id, [beaconNode]]

type Versioned<'v> = { value: (Tick * 'v); mutable next: Versioned<'v> option } with

    member private this.boxedValue = fst this.value, snd this.value |> box

    interface Versioned with
        member this.value = this.boxedValue
        member this.tail = this.tail |> Seq.map (fun v -> v :> Versioned)

    member this.push (time: Tick, value: 'v) =
        assert(this.next.IsNone)
        let n = Versioned<'v>.single (time, value)
        this.next <- Some n
        n

    member this.head = this

    member this.tail =
        this.next |> Seq.unfold (Option.map (fun n -> n, n.next))
    

    member this.pushSeq values = 
        values |> Seq.fold (fun (c : Versioned<_>) v -> c.push v) this

    static member single (tick: Tick, value: 'v) = { value = (tick, value); next = None }

    static member extend (versioned: Versioned<'v> option) (values: (Tick*'v) list) = 
        match versioned with
        | None -> Versioned.ofList values
        | Some x -> x.pushSeq values |> Some

    static member ofList (values : (Tick * 'v) list) : Versioned<'v> option =
        match values with
        | [] -> None
        | first :: rest -> 
            let head = Versioned.single first
            head.pushSeq rest
            |> Some

type 'v brick = 
    inherit Brick
    abstract member versioned : Versioned<'v> 
    abstract member evaluateT: unit -> ITramp<'v>
    abstract member value: 'v option

[<AutoOpen>]
module BrickExtensions =

    type 'v brick with
        member this.evaluate() =
            propagateInvalidation this.node
            this.evaluateT().Run()

        member this.valid = 
            let (b, _) = this.node
            b.valid

type Mutable<'v> = 
    inherit brick<'v>
    abstract member write: Tick -> 'v -> unit
    abstract member reset: Tick -> unit

(* Global Tick counter *)

let mutable private CurrentTick = 0L

let internal newTick() = 
    let newT = CurrentTick + 1L
    CurrentTick <- newT
    newT

(** Mutable Value **)

type MutableBrick<'v>(tick: Tick, initial: 'v) =

    let mutable _versioned = Versioned<'v>.single(tick, initial)

    let beacon = Beacon.create
    let node = beacon, Mutable

    let eval = 
        tramp {
            beacon.valid <- true
            return _versioned.value
        }

    interface Mutable<'v> with

        member this.versioned : Versioned = _versioned :> _
        member this.versioned : Versioned<'v> = _versioned

        member this.value = _versioned.value |> snd |> Some

        member this.evaluateT() : ITramp<obj> = eval |> Trampoline.map (fun v -> snd v |> box)

        member this.evaluateT() : ITramp<'v> = eval |> Trampoline.map snd

        member this.write tick v =
            _versioned <- _versioned.push (tick, v)
            beacon.invalidate()

        member this.reset tick =
            _versioned <- _versioned.push (tick, initial)
            beacon.invalidate() 

        member this.node = node


(** Managed Brick supports a creation, update, and destruction cycle **)

type Managed<'v, 'm> = { create: 'v -> 'm; update: 'm -> 'v -> 'm; destroy: 'm -> unit }

type ManagedBrick<'v, 'm>(source: 'v brick, managed: Managed<'v, 'm>) =

    let beacon = Beacon.create
    let mutable _node = None

    let mutable _source : 'v Versioned option = None
    let mutable _managed : 'm Versioned option = None

    // note: the current lifetime management algorithm requires that the destructor does not
    // over the lifetime of the brick and beacon!

    let destructor() =
        managed.destroy (_managed.Value.value |> snd)

    let eval = 
        tramp {
            let! _ = source.evaluateT()
            
            let m = 
                match _source with
                | None ->
                    let (tick, s) = source.versioned.value
                    let m = managed.create s
                    _managed <- Some <| Versioned.single (tick, m)
                    m
                | Some sourceV ->
                    let tail = sourceV.tail
                    let folder (_, m) v =
                        let (t, v) = v.value
                        let m = managed.update m v
                        (t, m)
                    let newMs = Seq.scan folder _managed.Value.value tail |> Seq.skip 1
                    _managed <- Some <| _managed.Value.pushSeq newMs
                    _managed.Value.value |> snd

            _source <- Some source.versioned
            _node <- Some <| (beacon, Managed (source.node, destructor))
            beacon.valid <- true

            return m
        }


    interface 'm brick with
        member this.versioned : Versioned = _managed.Value :> Versioned
        member this.versioned : Versioned<'m> = _managed.Value

        member this.value = _managed |> Option.map(fun v -> snd v.value) 

        member this.evaluateT() : ITramp<obj> = eval |> Trampoline.map box
        member this.evaluateT() : ITramp<'m> = eval

        member this.node = _node.Value


(** SIGNAL **)

type SignalBrick<'v>(dependencies: Brick list, processor: obj array -> 'v list) =

    let numParams = List.length dependencies
    let beacon = Beacon.create
    let mutable _node = beacon, Computed []
    let mutable _versioned : Versioned<'v> option = None

    let mutable _arguments : obj array = [||]
    let mutable _latest : Versioned array option = None

    let proc (values : (int * (Tick * obj)) list) =

        let isSet = Array.create numParams false
        let clear() = Array.fill isSet 0 numParams false
        
        let tickOf (_, (t, _)) = t
        
        let rec p tick mustProcess soFar todo = 

            let proc() = 
                processor _arguments
                |> List.map (fun r -> (tick, r))

            match todo with
            | [] -> 
                if mustProcess then
                    let res = proc()
                    res :: soFar 
                else
                    soFar
                |> List.rev |> List.flatten
            | (i, (t, v) as next) :: rest ->
                let canUse = t = tick && not isSet.[i]
                if canUse then 
                    _arguments.[i] <- v
                    isSet.[i] <- true
                    p tick true soFar rest
                else
                    assert (mustProcess)
                    let res = proc()
                    clear()
                    let nextTick = tickOf next
                    p nextTick false (res::soFar) todo
                    
        match values with
        | [] -> []
        | (first::_) -> p (tickOf first) false [] values
    
    let eval = 
        tramp {
            // even if we don't use the values directly, we need to run evaluateT to update the versioned chains
            let! _ = dependencies |> Seq.map (fun d -> d.evaluateT()) |> trampSeq
            let versioned = dependencies |> Seq.map (fun d -> d.versioned)

            // we are processing tuples of tick, value index, value

            let toProcess = 
                match _latest with
                | None -> 
                    // initialize the value array to the latest values
                    _arguments <-
                        versioned 
                        |> Seq.map (fun v -> v.value |> snd)
                        |> Seq.toArray

                    versioned 
                    |> Seq.mapi (fun i v -> i, v.value)

                | Some latest -> 
                    latest 
                    |> Seq.mapi (fun i v -> i, v.tail)
                    |> Seq.collect 
                        (fun (i, vs) -> 
                            vs 
                            |> Seq.map (fun v -> i, v.value))

            _latest <-
                versioned
                |> Seq.map (fun v -> v.last)
                |> Seq.toArray
                |> Some

            let orderedByTick = 
                toProcess |>
                Seq.sortBy (fun v -> v |> snd |> fst)

            let res = proc (orderedByTick |> Seq.toList)

            // note that nodes might change!
            let depNodes = dependencies |> List.map (fun d -> d.node)
            _node <- beacon, Computed depNodes

            _versioned <- Versioned.extend _versioned res

            beacon.valid <- true
            return _versioned.Value.value
        }

    interface 'v brick with

        member this.versioned : Versioned = _versioned.Value :> Versioned
        member this.versioned : Versioned<'v> = _versioned.Value

        member this.value = _versioned |> Option.map(fun v -> snd v.value) 

        member this.evaluateT() : ITramp<obj> = eval |> Trampoline.map (snd >> box)
        member this.evaluateT() : ITramp<'v> = eval |> Trampoline.map snd

        member this.node = _node


(** COMPUTED **)

type internal Trace = Brick list

type internal ComputationResult<'v> = ITramp<Trace * 'v>

type internal Computation<'v> = 'v brick -> ComputationResult<'v>

and ComputedBrick<'v>(computation : Computation<'v>) as self =
    
    let beacon = Beacon.create
    let mutable _node = beacon, Computed []
    let mutable _versioned : 'v Versioned option = None

    let eval = 
        tramp {
            if beacon.valid then
                return _versioned.Value.value
            else
            let! t, v = computation self

            let resultTick =
                if t = [] then CurrentTick else
                t 
                |> Seq.map (fun dep -> dep.versioned.value |> fst) 
                |> Seq.max

            let depNodes = 
                t 
                |> Seq.map (fun dep -> dep.node) 
                |> Seq.toList

            _node <- beacon, Computed depNodes

            let newValue = resultTick, v

            _versioned <-        
                match _versioned with
                | None -> Versioned<'v>.single newValue
                | Some prev -> prev.push newValue
                |> Some

            beacon.valid <- true
            return _versioned.Value.value
        }

    interface 'v brick with

        member this.versioned : Versioned = _versioned.Value :> Versioned
        member this.versioned : Versioned<'v> = _versioned.Value
        member this.value = _versioned |> Option.map(fun v -> snd v.value) 

        member this.evaluateT() : ITramp<obj> = eval |> Trampoline.map (snd >> box)
        member this.evaluateT() : ITramp<'v> = eval |> Trampoline.map snd

        member this.node = _node

type 't bricks = seq<'t brick>

let internal makeBrick<'v> f = ComputedBrick<'v>(f) :> 'v brick

// i want these in a module named Brick

type SelfValueMarker = SelfValueMarker

let valueOfSelf = SelfValueMarker

type BrickBuilder() =
    member this.Bind (dependency: 'dep brick, cont: 'dep -> Computation<'next>) : Computation<'next> =
        fun b ->
            tramp {
                let! depValue = dependency.evaluateT()
                let! contDep, r = cont depValue b
                return dependency:>Brick :: contDep, r
            }

    member this.Bind (dependencies: 'dep brick seq, cont: 'dep seq -> Computation<'next>) : Computation<'next> =
        fun b ->
            tramp {
                let! depValues = dependencies |> Seq.map (fun d -> d.evaluateT()) |> trampSeq
                let! contDep, r = cont depValues b
                let thisDeps = dependencies |> Seq.cast |> Seq.toList
                return thisDeps @ contDep, r
            }

    member this.Bind (SelfValueMarker, cont: 'v option -> Computation<'v>) : Computation<'v> =
        fun b ->
            let v = b.value
            cont v b

    member this.Return value = fun _ -> tramp { return [], value }
    
    member this.ReturnFrom (brick: 'value brick) = 
        fun _ ->
            tramp {
                let! value = brick.evaluateT();
                return [brick:>Brick], value
            }

    member this.Run comp = makeBrick comp

    member this.Delay (f: unit -> Computation<'v>) : Computation<'v> = 
        fun b ->
            f () b

let brick = new BrickBuilder()

let mutating (b : 'v brick) = 
    match b with
    | :? Mutable<'v> as mb -> mb
    | _ -> failwith "brick must be mutable"

(* Transaction

    A transaction can evaluate brick values and set new brick values.

    Inside a transaction, evaluating brick values always resolve to the
    previous state of the brick, never to the values that are changed by 
    the transaction.
*)

type Transaction = unit -> unit

type private Write = Tick -> unit
type private TransactionState = Write list
type private TransactionM = TransactionState -> ITramp<TransactionState>

type TransactionBuilder() =
    member this.Bind (brick: 'value brick, cont: 'value -> TransactionM) : TransactionM = 
        fun state ->
            tramp {
                let! value = brick.evaluateT()
                let! r = cont value state
                return r
            }

    member this.Zero () = fun f -> tramp { return f }
    member this.Yield _ = fun f -> tramp { return f }

    member this.Run (t : TransactionM): Transaction = 
        fun () -> 
            let t = tramp {
                let! state = t []
                let tick = newTick()
                return state |> List.rev |> List.iter (fun w -> w tick)
            }
            t.Run()

    member this.For(seq : TransactionM, cont: unit -> TransactionM) : TransactionM =
        fun t ->
            tramp {
                let! t = seq t
                let! r = cont() t
                return r
            }

    [<CustomOperation("write")>]
    member this.Write(nested : TransactionM, brick: 'v brick, value: 'v) =
        let m = mutating brick
        fun t ->
            tramp {
                let! state = nested t
                return (fun time -> m.write time value) :: state
            }
            
    [<CustomOperation("reset")>]
    member this.Reset(nested: TransactionM, brick : 'v brick) =
        let m = mutating brick
        fun t ->
            tramp {
                let! state = nested t
                return (fun time -> m.reset time) :: state
            }

let var v = MutableBrick<'v>(CurrentTick, v) :> 'v brick

(* Signal: discrete values *)

module Signal =

    let inline lift (f : 's -> 'r) (s: 's brick) = 
        let p (a: obj array) = [f (unbox a.[0])]
        SignalBrick<_>([s], p) :> _ brick

    let inline map f s = lift f s

    let inline lift2 (f : 's1 -> 's2 -> 'r) (s1 : 's1 brick) (s2: 's2 brick) =
        let p (a: obj array) = [f (unbox a.[0]) (unbox a.[1])]
        SignalBrick<_>([s1;s2], p) :> 'r brick

    let inline lift3 (f : 's1 -> 's2 -> 's3 -> 'r) (s1 : 's1 brick) (s2: 's2 brick) (s3: 's3 brick) =
        let p (a: obj array) = [f (unbox a.[0]) (unbox a.[1]) (unbox a.[2])]
        SignalBrick<_>([s1;s2;s3], p) :> 'r brick

    (* fold past, Elm inspired *)

    let foldp (f: 's -> 'v -> 's) (initial: 's) (source: 'v brick) =
        let state = ref initial
        let folder value =
            let s = f (!state) value
            state := s
            !state

        lift folder source

    let flatten (source: 'v list brick) =
        let processor (a: obj array) : 'v list = unbox a.[0]
        SignalBrick<_>([source], processor) :> 'v brick

(* Values: continuous values *)
   
module Value = 

    let lift (f: 's -> 't) (s: 's brick) =
        brick {
            let! s = s
            return f s
        }

    let map f s = lift f s

    let lift2 (f: 's1 -> 's2 -> 't) (s1: 's1 brick) (s2: 's2 brick) =
        brick {
            let! s1 = s1
            let! s2 = s2
            return f s1 s2
        }
    
    let foldp (f: 's -> 'v -> 's) (initial: 's) (source: 'v brick) = 
        let state = ref initial
        brick {
            let! v = source
            let s = !state
            let s' = f s v
            state := s'
            return s'
        }

    let manage (create : 'v -> 'm) (update: 'm -> 'v -> 'm) (destroy: 'm -> unit ) (source : 'v brick) =
        ManagedBrick(source, { create = create; update = update; destroy = destroy }) :> 'm brick

let transaction = new TransactionBuilder()

let valueOf (brick : 'v brick) = if brick.valid then brick.value else None

    
[<assembly:AutoOpen("BricksCore")>] ()
