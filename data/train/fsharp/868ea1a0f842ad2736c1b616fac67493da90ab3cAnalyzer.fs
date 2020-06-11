module Analyzer
open System.Xml
open lx_bpel
open Probability

let tuple2 a b = (a,b)
let tuple3 a b c= (a,b,c)
let third (a,b,c) = c

[<Struct>]
type Link =
    val mutable name:string
    val mutable transitionCondition:string
    val mutable source:string
    val mutable target:string
    (* update t in mylink
    void function Update_List (mylink, t)
    {
        int index = mylink.FindIndex(fun y -> y.name = t.name)
        let mutable x = mylink.[index]

        if x.transitionCondition == null then
            x.transitionCondition = t.transitionCondition

        if x.source == null then
            x.source = t.source

        if x.target == null then
            x.target = t.target

        mylink.[index] = x    
    }    
    *)

let Update_List (mylink:Link System.Collections.Generic.List) (t:Link) = 
    let index = mylink.FindIndex(fun y -> y.name = t.name)
    let mutable x = mylink.[index]

    if x.transitionCondition = null then
        x.transitionCondition <- t.transitionCondition

    if x.source = null then
        x.source <- t.source

    if x.target = null then
        x.target <- t.target

    mylink.[index] <- x

    (* 
    Token = not, and, or, (, ), condition 
    
    *)
type Tokens =
    | TkNot
    | TkAnd
    | TkOr
    | TkOpenPar
    | TkClosedPar
    | TkVariable of string

type Analyzer (probabilityAnnotations:Probability.ProbabilityAnnotation) =

    (*
    what is x.ParseCondition???    
    
    ParseCondition(string s)
    {
 
    }    

    *)
    member x.ParseCondition (expression:string) =
        let rec tokenize (s:char list) =
            match s with
            | 'n'::'o'::'t'::tail -> TkNot::(tokenizeSeparator tail)
            | 'a'::'n'::'d'::tail -> TkAnd::(tokenizeSeparator tail)
            | 'o'::'r'::tail -> TkOr::(tokenizeSeparator tail)
            | '$'::tail -> variableToken "" tail
            | _ -> tokenizeSeparator s
        and tokenizeSeparator (s:char list) =
            match s with
            | ' '::tail -> tokenize tail
            | '('::tail -> TkOpenPar::tokenize tail
            | ')'::tail -> TkClosedPar::tokenize tail
            | [] -> []
            | _ -> failwith "parse error"
        and variableToken (varname) (s:char list) =
            match s with
            | l::tail when l <> ' ' && l <> '('  && l <> ')' -> variableToken (sprintf "%s%c" varname l) tail
            | _ -> TkVariable varname::tokenizeSeparator s

        let tokenizedExpr = tokenize (expression |> Seq.toList)
        //printf "%+A" tokenizedExpr
        let rec parser tkns =
            match tkns with
            | TkOpenPar::tail ->
                let e,t = parser tail
                match t with
                | TkClosedPar::t2 -> binayOperatorParser e t2
                | _ -> failwith "Unbalanced parenthesis"
            | TkVariable s::tail ->
                binayOperatorParser (lx_bpel.Variable s) tail
            | TkNot::tail ->
                let e,t = parser tail
                binayOperatorParser (lx_bpel.BoolExpr.Not e) t
            | _ -> failwith "left operand missing"
        and binayOperatorParser lhs tkns =
            match tkns with
            | TkAnd::tail ->
                let e,t = parser tail
                (lx_bpel.BoolExpr.And (lhs,e)),t
            | TkOr::tail ->
                let e,t = parser tail
                (lx_bpel.BoolExpr.Or (lhs,e)),t
            | [] -> lhs,[]
            | _ -> lhs,tkns 
        let parsedExpr,tail = parser tokenizedExpr
        match tail with
        | [] -> printf "\n%+A\n" parsedExpr
        | _ -> failwithf "trailing tokens %+A" tail
        parsedExpr



    (*
         TransverseNodesActivity (xmlnodelist nodes, linklist, parentName)
         {  
            for (node in nodes) do {
                switch (node.Name) {
                 "sources" | "targets" | "links":
                      x.TransverseNodesActivity (node.ChildNodes, linkList,parentName)
                      break;
                "joincondition":
                        x.ParseCondition (node.InnerText)  
                        break;
                "source" | "target":
                        let t = new Link()
                        t.name = node.Attributes.["linkName"].Value

                        if node.Name = "source" then
                            t.source <- parentName
                        else if node.Name = "target" then
                            t.target <- parentName

                        //it may or may not contain the Transition Condition
                        if node.ChildNodes.Count > 0 then 
                            t.transitionCondition = node.ChildNodes.[0].InnerText
                        else
                            t.transitionCondition = null

                        Update_List (linkList,t)
                        break;
                  "link":
                        let t = new Link()
                        t.name  = node.Attributes.["name"].Value
                        linkList.Add(t)
                        break;
                    default:
                        break;
                }
             }
         }
    *)
    member x.TransverseNodesActivity 
        (nodes:XmlNodeList)
        (linkList:System.Collections.Generic.List<Link>)
        parentName =
        let mutable activityList = System.Collections.Generic.List<lx_bpel.Activity>()
        let mutable cond = lx_bpel.Constant true
        for node in nodes do
            match node.Name.ToLower() with
            | "sources" |  "links" ->
                x.TransverseNodesActivity (node.ChildNodes) linkList parentName |>ignore
            | "targets" ->
                cond <- x.TransverseNodesActivity (node.ChildNodes) linkList parentName
            | "joincondition" ->
                cond <- x.ParseCondition (node.InnerText)   
            | "source" | "target" ->
                let mutable t = Link()
                t.name <- node.Attributes.["linkName"].Value

                if node.Name = "source" then
                    t.source <- parentName
                else if node.Name = "target" then
                    t.target <- parentName

                //it may or may not contain the Transition Condition
                if node.ChildNodes.Count > 0 then 
                    t.transitionCondition <- node.ChildNodes.[0].InnerText
                else
                    t.transitionCondition <- null

                Update_List linkList t
                
            | "link" ->
                let mutable t = Link()
                t.name  <- node.Attributes.["name"].Value
                linkList.Add t
            | _ -> ()
        cond
    (*
     (lx_bpel.Activity list, string, lx_bpel.Activity>  member x.TraverseNodes (nodes:XmlNodeList) {

        let temp = System.Collections.Generic.List< string , lx_bpel.Activity>()
        let handler : lx_bpel.Activity list = []
        let r = new System.Random ()

        let emptyList = System.Collections.Generic.List<Link>()
        for node in nodes do
        {
            let parentName = nodeName + (r.Next())
            switch(nodeName)
            {
             "faulthandlers":
                    let snd = x.TraverseNodes (node.ChildNodes, linkList)
                    let t1= Seq.map(snd)
                    let newHandler = Eval.makeSequence (t1)
                    handler = List.Cons (newHandler,handler) // newHandler::handler

             "sequence":
                
                    x.TransverseNodesActivity(node.ChildNodes, linkList, parentName)
                    let h,actlist = x.TraverseNodes(node.ChildNodes, linkList)
                    handler = List.append(h,handler) //  h @ handler
                    t1 = Seq.map(snd)
                    let seqActivity = Eval.makeSequence(t1)
                    temp.Add (parentName,seqActivity)

             "scope":
                    x.TransverseNodesActivity(node.ChildNodes, linkList, parentName)
                    let h,actlist = x.TraverseNodes(node.ChildNodes, linkList)
                    actlist??
                    let seqActivity =  Eval.makeSequence(Seq.map (snd))
                        if h==[]
                             h=lx_bpel.Throw
                        else if Size(h)==1 
                             h=Head of h
                        else
                             h= null 
                    let handlerActivity = Eval.makeSequence(h)
                    let scopeActivity = lx_bpel.Scope (seqActivity,handlerActivity)
                    temp.Add (parentName,scopeActivity)
             "if":
                x.TransverseNodesActivity(node.ChildNodes, linkList, parentName)
                let probability =  probabilityAnnotations.conditions.[node.ChildNodes.[0].InnerText]
                let h,val_return = x.TraverseNodes(node.ChildNodes.[1].ChildNodes, emptyList)
                handler = List.append(h, handler)
                
                if (val_return.Count == 0)
                    thenA = nothing
                else
                    thenA = snd(val_return.[0])

                let (h,elseL) = x.TraverseNodes(node.ChildNodes.[2].ChildNodes, emptyList)

                handler = List.append(h, handler)

                if (elseL.Count == 0) 
                    elseA = Nothing 
                else 
                    elseA = snd(elseL.[0])
                
                let variableName = r.Next()
                
                let t1 =  tuple2 (parentName, OpaqueAssign(variableName,probability))
                temp.Add (t1)
                
                let t2 =  tuple2 (parentName, IfThenElse(variableName,thenA,elseA))
                temp.Add (t2)
                

             "while":
                x.TransverseNodesActivity(node.ChildNodes, linkList, parentName)

                let pchild = 
                   (for x in node.ChildNodes x)
                      Seq.find (fun x -> x.Name.ToLower() = "condition") 
                
                let probability = probabilityAnnotations.conditions.[pchild.InnerText]
                let variableName = r.Next()
                let opaqueAssignActivity = OpaqueAssign (variableName,probability)
                let h, while_List = x.TraverseNodes(node.ChildNodes.[1].ChildNodes, emptyList)
                handler = List.append(h, handler)
                temp.Add (parentName,opaqueAssignActivity)
                if while_List.Count = 0 then
                    opaqueAssignActivity
                else
                    while_List.Add (parentName,opaqueAssignActivity)
                    Eval.makeSequence (Seq.map(snd(while_List))

                let t3 = tuple2(parentName, While(tuple2 (Variable,variableName)))
                temp.Add(t3)

             "invoke":
                x.TransverseNodesActivity(node.ChildNodes, linkList, parentName)
                let nameNode = node.Attributes.["name"]
                match Map.tryFind ((if nameNode <> null then nameNode.Value else "" )+"_pl_"+node.Attributes.["partnerLink"].Value) probabilityAnnotations.endpoints with
                | Some (list,samplingFunction) ->
                        temp.Add (tuple2(parentName, Invoke samplingFunction))
                | None -> temp.Add (parentName,lx_bpel.Nothing)


             "empty" | "assign" | "receive" | "reply" :
                x.TransverseNodesActivity(node.ChildNodes, linkList, parentName)
                temp.Add (parentName,Nothing)

             "link" -> ()
            
             "flow" -> 
                x.TransverseNodesActivity(node.ChildNodes, linkList, parentName)

                let activityList =
                    let h,activitylist = x.TraverseNodes(node.ChildNodes, linkList)
                    handler =  List.append(h, handler)
                    activitylist
                    let t4 =  Seq.map (fun (name,activity) -> name,lx_bpel.Constant true,activity )
                    Seq.toList(t4)
                let linkList =
                    
                    let t5 =  Seq.map (fun (l:Link) -> (l.name,lx_bpel.Variable l.transitionCondition,l.source,l.target)) (linkList)
                    Seq.toList(t5)

                let activityList = lx_bpel.Eval.activityToposort (activityList,linkList)

                
                 temp.Add (tuple2 (parentName, lx_bpel.Flow (activityList,linkList))
            
            Default:
                //printf "unrecognized activity: %s" activityName
                let h,activityList = x.TraverseNodes(node.ChildNodes,linkList )
                handler =  List.append(h, handler)
                temp.AddRange activityList
        handler,temp    
    
    *)

    member x.TraverseNodes (nodes:XmlNodeList) (linkList:System.Collections.Generic.List<Link>): (lx_bpel.Activity list)*System.Collections.Generic.List<string*lx_bpel.BoolExpr*lx_bpel.Activity> =
        let temp = System.Collections.Generic.List<string*lx_bpel.BoolExpr*lx_bpel.Activity>()
        let mutable handler : lx_bpel.Activity list = []
        let r = new System.Random ()

        let emptyList = System.Collections.Generic.List<Link>()
        for node in nodes do
            let nodeName = node.Name.ToLower() 
            let parentName = sprintf "%s%d" nodeName (r.Next())
            match nodeName with
            | "faulthandlers" ->
                let newHandler =
                    let _,actlist = x.TraverseNodes (node.ChildNodes) linkList
                    actlist
                    |> Seq.map third
                    |> Eval.makeSequence 
                handler <- List.Cons (newHandler,handler) // newHandler::handler
                // Some (Eval.makeSequence (Seq.map snd (snd(x.TraverseNodes (node.ChildNodes) linkList))))
            | "sequence" ->
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName
                let seqActivity =
                    let h,actlist = x.TraverseNodes(node.ChildNodes) linkList
                    handler <- List.append h handler //  h @ handler
                    actlist
                    |> Seq.map third
                    |> Eval.makeSequence
                temp.Add (parentName,cond, seqActivity)
            | "scope" ->
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName
                let h,actlist = x.TraverseNodes(node.ChildNodes) linkList
                let seqActivity =
                    actlist
                    |> Seq.map third
                    |> Eval.makeSequence
                let handlerActivity =
                    match h with
                    | [] -> lx_bpel.Throw
                    | a::[] -> a
                    | _ -> Eval.makeSequence h
                let scopeActivity = lx_bpel.Scope (seqActivity,handlerActivity)
                temp.Add (parentName,cond,scopeActivity)
            | "if" ->
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName
                let pchild = seq{ for x in node.ChildNodes -> x } |> Seq.find (fun x -> x.Name.ToLower() = "condition") 
                let tchild = seq{ for x in node.ChildNodes -> x } |> Seq.find (fun x -> x.Name.ToLower() = "then") 
                let echild = seq{ for x in node.ChildNodes -> x } |> Seq.tryFind (fun x -> x.Name.ToLower() = "else") 
                let c =
                    if probabilityAnnotations.conditions.ContainsKey(pchild.InnerText) then
                        let probability =  probabilityAnnotations.conditions.[pchild.InnerText]
                        let variableName = sprintf "Var%d" <| r.Next()
                        (variableName,probability)
                        |> OpaqueAssign
                        |> tuple3 parentName cond
                        |> temp.Add
                        Variable variableName
                    else
                    x.ParseCondition(pchild.InnerText)

                let h,thenL = x.TraverseNodes tchild.ChildNodes emptyList
                handler <- List.append h handler
                let thenA = if thenL.Count = 0 then Nothing else third thenL.[0]
                let h,elseL =
                    match echild with
                    | None -> List.empty,new System.Collections.Generic.List<string*lx_bpel.BoolExpr*lx_bpel.Activity>()
                    | Some echild -> x.TraverseNodes echild.ChildNodes emptyList
                handler <- List.append h handler
                let elseA = if elseL.Count = 0 then Nothing else third elseL.[0]
                (c,thenA,elseA)
                |> IfThenElse
                |> tuple3 parentName cond
                |> temp.Add

            | "while" ->
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName

                let pchild = seq{ for x in node.ChildNodes -> x } |> Seq.find (fun x -> x.Name.ToLower() = "condition") 
                if probabilityAnnotations.conditions.ContainsKey(pchild.InnerText) then
                    let probability =  probabilityAnnotations.conditions.[pchild.InnerText]
                    let variableName = sprintf "Var%d" <| r.Next()
                    let opaqueAssignActivity =
                        OpaqueAssign (variableName,probability)
                    let h, while_List = x.TraverseNodes node.ChildNodes.[1].ChildNodes emptyList
                    handler <- List.append h handler
                    temp.Add (parentName,lx_bpel.Constant true,opaqueAssignActivity)
                    if while_List.Count = 0 then
                        opaqueAssignActivity
                    else
                        while_List.Add (parentName,lx_bpel.Constant true, opaqueAssignActivity)
                        Eval.makeSequence (Seq.map third while_List)
                    |> tuple2 (Variable variableName)
                    |> While
                    |> tuple3 parentName cond
                    |> temp.Add
                else
                    let c = x.ParseCondition(pchild.InnerText)
                    let h, while_List = x.TraverseNodes node.ChildNodes.[1].ChildNodes emptyList
                    handler <- List.append h handler
                    if while_List.Count = 0 then
                        lx_bpel.Nothing
                    else
                        Eval.makeSequence (Seq.map third while_List)
                    |> tuple2 c
                    |> While
                    |> tuple3 parentName cond
                    |> temp.Add
            | "invoke" ->
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName
                let nameNode = node.Attributes.["name"]
                match Map.tryFind ((if nameNode <> null then nameNode.Value else "" )+"_pl_"+node.Attributes.["partnerLink"].Value) probabilityAnnotations.endpoints with
                | Some (list,samplingFunction) ->
                    Invoke samplingFunction
                    |> tuple3 parentName cond
                    |> temp.Add
                | None -> temp.Add (parentName,cond,lx_bpel.Nothing)
            | "copy" ->
                let cond= x.TransverseNodesActivity node.ChildNodes linkList parentName
                let expression = node.ChildNodes.[0].InnerText
                let varname = node.ChildNodes.[1].Attributes.["variable"].Value
                let probability =  probabilityAnnotations.conditions.[expression]
                OpaqueAssign (varname,probability) |> tuple3 parentName cond |> temp.Add
            | "empty" | "receive" | "reply" -> 
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName

                temp.Add (parentName,cond,Nothing)
            | "throw" -> 
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName

                temp.Add (parentName,cond,Throw)
            | "link" -> ()
            | "flow" -> 
                let cond = x.TransverseNodesActivity node.ChildNodes linkList parentName

                //activityName,joinCondition,innerActivity

                //XmlNode t3 = Sort_Activities.sort(node);
                //let linkList = System.Collections.Generic.List<Link>()
                let activityList =
                    let h,activitylist = x.TraverseNodes node.ChildNodes linkList 
                    handler <- List.append h handler
                    activitylist
                    |> Seq.map (fun (name,cond,activity) -> name,cond,activity )
                    |> Seq.toList
                let linkList =
                    linkList
                    |> Seq.map (fun (l:Link) -> (l.name,lx_bpel.Variable l.transitionCondition,l.source,l.target))
                    |> Seq.toList
                let activityList = lx_bpel.Eval.activityToposort (activityList) linkList

                lx_bpel.Flow (activityList,linkList)
                |> tuple3 parentName cond
                |> temp.Add
            | _ ->
                //printf "unrecognized activity: %s" activityName
                let h,activityList = x.TraverseNodes node.ChildNodes linkList 
                handler <- List.append h handler
                temp.AddRange activityList
        handler,temp