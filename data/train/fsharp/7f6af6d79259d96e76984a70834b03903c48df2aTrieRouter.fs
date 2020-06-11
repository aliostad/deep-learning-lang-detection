module Giraffe.HttpRouter

open System.Threading.Tasks
open Microsoft.AspNetCore.Http
open Microsoft.AspNetCore.Hosting
open Microsoft.Extensions.Primitives
open FSharp.Core.Printf
open System.Collections.Generic
open Microsoft.FSharp.Reflection
//open Giraffe.AsyncTask
open Giraffe.Tasks
open Giraffe.HttpHandlers
open Giraffe.RouterParsers

// implimenation of (router) Trie Node
// assumptions: memory and compile time not relevant, all about execution speed, initially testing with Dictionary edges

let routerKey = "router_pos"

type RouteState(path:string) =
    member val path = path with get
    member val pos = 0 with get , set

////////////////////////////////////////////////////
// Node Trie using node mapping functions
////////////////////////////////////////////////////

type Node(routeFn) = 
    
    let mutable midFns = []
    let mutable endFns = []
    
    let addMidFn (mfn:MidCont) = midFns <- mfn :: midFns |> List.sortBy (fun f -> f.Precedence)
    let addEndFn (efn:EndCont) = endFns <- efn :: endFns |> List.sortBy (fun f -> f.Precedence) 
    let addRouteFn fn =
        match fn with
        | Empty -> ()
        | Mid mfn -> addMidFn mfn
        | End efn -> addEndFn efn
    do addRouteFn routeFn
    let mutable hasEdges = false //quick field to check if node has edges
    let edges = Dictionary<char,Node>()
    member __.MidFns
        with get() = midFns 
        and set v = midFns <- v
    member __.AddMidFn = addMidFn
    member __.EndFns 
        with get()  = endFns 
        and set v = endFns <- v 
    member __.AddEndFn = addEndFn
    
    member x.Add v routeFn =
        match edges.TryGetValue v with
        | true, node -> 
            match routeFn with
            | Empty -> ()
            | Mid mfn -> node.AddMidFn mfn
            | End efn -> node.AddEndFn efn
            node
        | false, _ -> 
            let node = Node(routeFn)
            edges.Add(v,node)
            if not hasEdges then hasEdges <- true //quick field to check if node has edges
            node            
    member x.EdgeCount 
        with get () = edges.Count
    member x.GetEdgeKeys = edges.Keys
    member x.TryGetValue v = edges.TryGetValue v

// Route Continuation Functions    
and MidCont =
| SubRouteMap of HttpHandler
| ApplyMatch of (char * (char []) * (Node)) // (parser , nextChar , contNode) list
| ApplyMatchAndComplete of ( char * int * (obj -> HttpHandler)) // (lastParser, No# Parsers, Cont Fn)
    member x.Precedence
        with get () =
            match x with
            | SubRouteMap _ -> 1
            | ApplyMatch (c,_,_) -> (int c)
            | ApplyMatchAndComplete (c,_,_) -> 256 + (int c) 
and EndCont = 
| HandlerMap of HttpHandler
| MatchComplete of ( (int) * (obj -> HttpHandler) ) // ( No# Parsers, Cont Fn) 
    member x.Precedence
        with get () =
            match x with
            | HandlerMap _ -> 1
            | MatchComplete _ -> 2 
and ContType =
| Empty
| Mid of MidCont
| End of EndCont   


////////////////////////////////////////////////////
// Helper Functions
////////////////////////////////////////////////////

// Bindy is a HACK to encapsulate type inferance application in node trie of multiple types, partially applied functions fail
type Bindy() =
    member x.EatMe<'U,'T> (sf:StringFormat<'U,'T>) (fn : 'T -> HttpHandler) (v2:obj) = v2 :?> 'T |> fn

let inline bindMe (sf:StringFormat<'U,'T>) (fn : 'T -> HttpHandler) = 
    let b = Bindy()
    b.EatMe<'U,'T> sf fn 

let inline (==>) (a:HttpHandler -> Node -> Node) (b:HttpHandler) = a b

// type HandlerResult<'T> =
// | None
// | Some of 'T
// | TaskResult of Task<HandlerResult<'T>>

// type RouteNodeFn() =
//     let mutable p = ""
//     let mutable bindFn = Unchecked.defaultof<obj -> 'T>
//     let mutable handle = Unchecked.defaultof<HttpHandler>
//     member __.AddPathRoute (path:string) = p <- path
//     member __.AddParseHandler<'U,'T> (sf:StringFormat<'U,'T>) =
//         bindFn <- fun (v2:obj) -> v2 :?> 'T
//     member __.AddHandler (handler:HttpHandler) = handle <- handler
//     static member (>=>) (n:RouteNodeFn) (h:HttpHandler) =
//         n.AddHandler h
//     static member (>=>) (n:RouteNodeFn) (ph:'T -> HttpHandler) =
//         n.AddParseHandler<_,'T>  (ph:'T -> HttpHandler)

//////////////////////
let private addRoutContToPath (path:string) (rc:ContType)  (root:Node) =     
    let last = path.Length - 1 
    let rec go i (node:Node) =
        if i = last then
            node.Add path.[i] rc
        else
            let nextNode = node.Add path.[i] Empty
            go (i + 1) nextNode
    go 0 root

let addCharArray (c:char) (ary:char []) =
    if ary |> Array.exists (fun v -> v = c) then
        ary
    else 
        let nAry = Array.zeroCreate<_>(ary.Length + 1)
        Array.blit ary 0 nAry 0 ary.Length
        nAry.[ary.Length] <- c
        nAry

// helper to get child node of same match format (slow for now, needs optimisation)
let getPostMatchNode fmt (nxt:char) (ils:MidCont list) = 
    let rec go (ls:MidCont list) (acc:MidCont list) (no:Node option) =
        match ls with
        | [] -> 
            match no with 
            | None -> 
                let n = Node(Empty)
                n ,(ApplyMatch(fmt,[|nxt|],n)) :: acc |> List.sortBy (fun fn -> fn.Precedence)
            | Some n -> n, acc |> List.sortBy (fun fn -> fn.Precedence)
        | hfn :: tfns ->
            match hfn with
            | ApplyMatch (f,ncl,n) ->
                if f = fmt then
                    let nncl = addCharArray nxt ncl
                    go tfns (ApplyMatch(f,nncl,n)::acc) (Some(n))
                else go tfns (hfn::acc) no
            | _ -> go tfns (hfn::acc) no
    go ils [] None

////////////////////////////////////////////////////
// Routing Node Map Functions used to build trie
////////////////////////////////////////////////////

// Simple route that iterates down nodes and if function found, execute as normal
let routeT (path:string) (fn:HttpHandler) (root:Node) = 
    addRoutContToPath path (fn |> HandlerMap |> End) root

let subRouteT (path:string) (fn:HttpHandler) (root:Node) =
    addRoutContToPath path (fn |> SubRouteMap |> Mid) root

// parsing route that iterates down nodes, parses, and then continues down further notes if needed
let routeTf (path : StringFormat<_,'T>) (fn:'T -> HttpHandler) (root:Node)=
    let last = path.Value.Length - 1
    let rec go i (pcount) (node:Node)  =
        if i = last then
            // have reached the end of the string match so add fn handler, and no continuation node            
            node.Add path.Value.[i] (MatchComplete( pcount , bindMe path fn ) |> End)
            //node.RouteFn <- (MatchComplete( pcount , bindMe path fn ))
        else
            if path.Value.[i] = '%' && i + 1 <= last then
                let fmtChar = path.Value.[i + 1]
                // overrided %% -> % case
                if fmtChar = '%' then
                    node.Add '%' Empty
                    |> go (i + 2) pcount
                // formater with valid key
                else if formatMap.ContainsKey fmtChar then

                    if i + 1 = last then // if finishes in a parse
                        if node.MidFns |> List.exists (function | ApplyMatchAndComplete(c,_,_) -> fmtChar = c | _ -> false )
                        then sprintf "duplicate paths detected '%s', Trie Build skipping..." path.Value |> failwith
                        else node.AddMidFn <| ApplyMatchAndComplete( fmtChar , pcount + 1 , bindMe path fn )
                        node
                    else
                        //otherwise add mid pattern parse apply
                        
                        let cnode,midFns = getPostMatchNode fmtChar path.Value.[i+2] node.MidFns                                                    
                        node.MidFns <- midFns //update adjusted functions
                        go (i + 2) (pcount + 1) cnode
                // badly formated format string that has unknown char after %
                else
                    failwith (sprintf "Routef parsing error, invalid format char identifier '%c' , should be: b | c | s | i | d | f" fmtChar)
                    node.Add path.Value.[i] Empty
                    |> go (i + 1) pcount
            else
                //normal string match path/chain
                node.Add path.Value.[i] Empty
                |> go (i + 1) pcount
    go 0 0 root 

// choose root will apply its root node to all route mapping functions to generate Trie at compile time, function produced will take routeState (path) and execute appropriate function

// process path fn that returns httpHandler
let private processPath (rs:RouteState) (root:Node) : HttpHandler =
    fun next (ctx:HttpContext) -> 
    
    let path = rs.path
    let ipos = rs.pos
    let last = path.Length - 1
    
    let rec checkMatchSubPath pos (node:Node) = // this funciton is only used by parser paths
        //this function doesn't test array bounds as all callers do so before
        match node.TryGetValue path.[pos] with
        | true, n -> 
            if pos = last then //if this pattern match shares node chain as substring of another
                if n.EndFns.IsEmpty
                then pos, None
                else pos, Some n
            else checkMatchSubPath (pos + 1) n
        | false,_ -> //failed node match on pos represents start of a match
            if pos = last then
                if node.EndFns.IsEmpty
                then pos, None
                else pos, Some node
            else
                if node.MidFns.IsEmpty
                then pos, None
                else pos, Some node
    
    /// (next match chars,pos,match completion node) -> (parse end,pos skip completed node,skip completed node) option
    let rec getNodeCompletion (cs:char []) pos (node:Node) =
        match path.IndexOfAny(cs,pos) with
        | -1 -> None
        | x1 -> //x1 represents position of match close char but rest of chain must be confirmed 
            match checkMatchSubPath x1 node with
            | x2,Some cn -> Some(x1 - 1,x2,cn)                 // from where char found to end of node chain complete
            | x2,None   ->  getNodeCompletion cs (x1 + 1) node // char foundpart of match, not completion string

    let createResult (args:obj list) (argCount:int) (fn:obj -> HttpHandler) =
        let input =  
            match argCount with
            | 0 -> Unchecked.defaultof<obj> //HACK: need routeF to throw error on zero args
            | 1 -> args.Head // HACK: look into performant way to safely extract
            | _ ->
                let values = Array.zeroCreate<obj>(argCount)
                let valuesTypes = Array.zeroCreate<System.Type>(argCount)
                let rec revmap ls i = // List.rev |> List.toArray not used to minimise list traversal
                    if i < 0 then ()
                    else
                        match ls with
                        | [] -> ()
                        | h :: t -> 
                            values.[i] <- h
                            valuesTypes.[i] <- h.GetType()
                            revmap t (i - 1)
                revmap args (argCount - 1)
                
                let tupleType = FSharpType.MakeTupleType valuesTypes
                FSharpValue.MakeTuple(values, tupleType)
        fn input next ctx

    let saveRouteState pos = 
        rs.pos <- pos
        ctx.Items.[routerKey] <- rs 

    let rec processEnd (fns:EndCont list) pos args =
        match fns with
        | [] -> Task.FromResult None
        | h :: t ->
            match h with                    
            | HandlerMap fn -> fn next ctx // run function with all parameters
            | MatchComplete (i,fn) -> createResult args i fn 

    let rec processMid (fns:MidCont list) pos args =
        
        let applyMatchAndComplete pos acc ( f,i,fn ) tail =
            match formatMap.[f].Invoke(path, pos, last) with
            | struct(true,o) -> createResult (o :: acc) i fn
            | struct(false,_) -> processMid tail pos acc // ??????????????????
        
        let rec applyMatch (f:char,ca:char[],n) pos acc tail =
            match getNodeCompletion ca pos n with
            | Some (fpos,npos,cnode) ->
                match formatMap.[f].Invoke(path, pos, fpos) with
                | struct(true,o) -> 
                    if npos = last then //if have reached end of path through nodes, run HandlerFn
                        processEnd cnode.EndFns npos (o::acc)
                    else
                        processMid cnode.MidFns npos (o::acc)
                | struct(false,_)  -> processMid tail pos acc // keep trying    
            | None -> processMid tail pos acc // subsequent match could not complete so fail
        
        match fns with
        | [] -> Task.FromResult None
        | h :: t ->
            match h with
            | ApplyMatch x -> applyMatch x pos args t
            | ApplyMatchAndComplete x -> applyMatchAndComplete pos args x t
            | SubRouteMap (fn) ->
                saveRouteState pos
                fn next ctx

    let rec crawl pos (node:Node) =
        match node.TryGetValue path.[pos] with
        | true, n ->
            if pos = last then //if have reached end of path through nodes, run HandlerFn
                processEnd n.EndFns pos []
            else                //need to continue down chain till get to end of path
                crawl (pos + 1) n
        | false , _ ->
            // no further nodes, either a static url didnt match or there is a pattern match required            
            processMid node.MidFns pos []

    crawl ipos root

let routeTrie (fns:(Node->Node) list) : HttpHandler =
    let root = Node(Empty)
    // precompile the route functions into node trie
    let rec go ls =
        match ls with
        | [] -> ()
        | h :: t ->
            h root |> ignore
            go t
    go fns

    fun next ctx ->
        //get path progress (if any so far)
        let routeState =
            match ctx.Items.TryGetValue routerKey with
            | true, (v:obj) -> v :?> RouteState  
            | false,_-> RouteState(ctx.Request.Path.Value)
        processPath routeState root next ctx