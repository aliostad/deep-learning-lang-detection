module Synth.Sequent
open Util
open Lang
open Refns
open FocusCtx
open Skeleton

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// A SEQUENT.
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
type private sequent_rep = {
    tgoal     : typ
    rgoal     : refns
    fresh     : world
    left      : list<skeleton>
    unfocused : list<id_info>
    fctx      : focusctx
    dec       : id option
}
type public sequent private(rep:sequent_rep) =
    member private this.Rep = rep

    // Create a sequent containing a goal type and refinement.
    static member public Create(tgoal:typ, rgoal1:refn) : sequent  =
        sequent({
                    tgoal     = tgoal
                    rgoal     = Map.empty.Add(0, rgoal1)
                    left      = []
                    unfocused = []
                    fresh     = 1
                    fctx      = focusctx.Create([])
                    dec       = None
                 })

    // Create a sequent containing a goal type and no refinement.
    static member public Create(tgoal:typ) : sequent  =
        sequent({
                    tgoal     = tgoal
                    rgoal     = Map.empty
                    left      = []
                    unfocused = []
                    fresh     = 1
                    fctx      = focusctx.Create([])
                    dec       = None
                 })

    // Public properties.
    member public  this.GoalType  with get() = this.Rep.tgoal
    member public  this.GoalRefns with get() = this.Rep.rgoal
    member public  this.DecIn     with get() = this.Rep.dec
    member public  this.Left      with get() = this.Rep.left
    member public  this.Unfocused with get() = this.Rep.unfocused

    // Turn unfocused into a type typechecking context.
    member private this.Gam_ = lazy(this.Unfocused.map(fun x -> (x.name, x.t)).ToMap())
    member public  this.Gam  = this.Gam_.Force()
    
    // Turning unfocused into a refinement typechecking context for a particular world.
    member private this.RefnGam_ =
       this.GoalRefns.map(fun w _ ->
           lazy(this.Unfocused.map(fun x -> (x.name, (x.rs.[w], x.t))).ToMap()))
    member public this.RefnGam w = this.RefnGam_.[w].Force()

    // Private properties.
    member private this.Fctx      with get() = this.Rep.fctx

    // Modify the sequent.
    member public this.SetGoalType (t:typ)    = sequent({this.Rep with tgoal = t })
    member public this.SetGoalRefns(rs:refns) = sequent({this.Rep with rgoal = rs})
    member public this.SetDecIn(x:id option)  = sequent({this.Rep with dec = x })
    member public this.RemoveLeft(name:id) =
        sequent({this.Rep with left = this.Left.unfilter(fun s -> s.Name.Equals(name))})
    member public this.Peel
      with get() =  (this.Left.Head, sequent({this.Rep with left = this.Left.Tail}))
    member public this.Unpeel(sk:skeleton) = sequent({this.Rep with left = sk :: this.Left})
    member public this.NoRefns() =
        sequent({this.Rep with rgoal = Map.empty;
                               unfocused = this.Rep.unfocused.map(fun r -> {r with rs = Map.empty})
                               left = this.Rep.left.map(fun sk -> sk.NoRefns())})

    // Manage worlds.
    member public this.DuplicateWorld(w:world) : world * sequent =
        let w'      = this.Rep.fresh
        let left'   = List.map (fun (s:skeleton) -> s.DuplicateWorld(w, w')) this.Rep.left
        let rgoal'  = this.Rep.rgoal.DuplicateWorld(w, w')
        let fctx'   = this.Fctx.DuplicateWorld(w, w')
        let unfocused' = this.Unfocused.map(fun x -> {x with rs = x.rs.DuplicateWorld(w, w')})

        let this'   = sequent({this.Rep with left = left'; rgoal = rgoal';  unfocused = unfocused';
                                             fctx = fctx'; fresh = w' + 1})
        (w', this')

    member public this.DeleteWorld(w:world) : sequent =
        let left'  = List.map (fun (s:skeleton) -> s.DeleteWorld(w)) this.Rep.left
        let rgoal' = this.Rep.rgoal.DeleteWorld(w)
        let fctx'  = this.Fctx.DeleteWorld(w)
        let unfocused' = this.Unfocused.map(fun x -> { x with rs = x.rs.DeleteWorld(w)})

        sequent({this.Rep with left = left'; rgoal = rgoal'; fctx = fctx'; unfocused = unfocused'})
    member public this.DeleteWorlds(ws:world list) : sequent = 
        List.fold (fun seq w -> seq.DeleteWorld(w)) this ws

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // EQUALITY
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    member private this.HashCode = ref None
    override this.GetHashCode() =
        if this.HashCode.Value.IsSome then this.HashCode.Value.Value
        else
            let result = 17
            let result = 31 * result + hash this.Rep.left
            let result = 31 * result + hash this.Rep.rgoal
            let result = 31 * result + hash this.Rep.tgoal
            let result = 31 * result + hash this.Rep.dec
            this.HashCode := Some result
            result

    override this.Equals(thatobj) =
        match thatobj with
        | :? sequent as that -> this.Rep.left  = that.Rep.left &&
                                this.Rep.rgoal = that.Rep.rgoal &&
                                this.Rep.tgoal = that.Rep.tgoal &&
                                this.Rep.dec   = that.Rep.dec
        | _ -> false

    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // LEFT FOCUSING
    //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    // Besides constructors, every refinement is left-invertible, so every single left
    // rule except those for constructors gets applied at focusing time.
    // (Implication technically isn't left-invertible, but we leave holes where arguments
    //  which means we can do everything but argument-selection at focusing time.)

    // The core focusing engine.
    member public this.AddLeft(ls : id_info list, ?also:skeleton ref) : sequent =
        let seq = ref (sequent({this.Rep with fctx = focusctx.Create(ls);
                                              unfocused = this.Rep.unfocused @ ls}))

        let duplicate_world(w:world) : world =
            let (w', seq') = (!seq).DuplicateWorld(w)
            seq := seq'
            if also.IsSome then also.Value := also.Value.Value.DuplicateWorld(w, w')
            w'

        let delete_world(w:world) : unit =
            seq := (!seq).DeleteWorld(w)
            if also.IsSome then also.Value := also.Value.Value.DeleteWorld(w)

        // Focus until no more terms remain in the focusing context.
        while not((!seq).Fctx.Empty) do
            // Perform type-drected focusing.
            seq := match (!seq).Fctx.Head.GoalType.Node with
                    | TUnit   -> 
                        (!seq).Fctx.Head.SynthUnitL(delete_world)
                        sequent({(!seq).Rep with fctx = (!seq).Fctx.Tail})

                    | TBase _->
                        let skel = (!seq).Fctx.Head.SynthBaseL(duplicate_world, delete_world)
                        sequent({(!seq).Rep with fctx = (!seq).Fctx.Tail;
                                                 left = skel :: (!seq).Rep.left})

                    | TPoly _ ->
                        let skel = (!seq).Fctx.Head.SynthPolyL(duplicate_world, delete_world)
                        sequent({(!seq).Rep with fctx = (!seq).Fctx.Tail;
                                                 left = skel :: (!seq).Rep.left})

                    | TTup  _ ->
                        let skels = (!seq).Fctx.Head.SynthProductL(duplicate_world, delete_world)
                        sequent({(!seq).Rep with fctx = (!seq).Rep.fctx.Tail.PushMany(skels)})

                    | TArr  _ ->
                        let skel = (!seq).Fctx.Head.SynthImplL(duplicate_world, delete_world)
                        sequent({(!seq).Rep with fctx = (!seq).Rep.fctx.Tail.Push(skel)})

        // Return the updated sequent.
        !seq