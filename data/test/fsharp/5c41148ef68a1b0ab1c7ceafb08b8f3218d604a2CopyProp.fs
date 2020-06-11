module CopyProp
open Flatten
open ASTBuilder
open FSharpx.State
open FSharpx
open Aether
open ComputationGraph
open MixedLang
open FSOption


type CopyTraversal<'a>= {var: 'a; initialAssign : NodeId; coverage : NodeId list; value : 'a}
let getProp g n allTravs trav =
  let result v a c= {initialAssign = n; var = v; value = a; coverage = c} |> Some
  function 
  | AssignI (v, VarAtom v') 
    -> let k = allTravs 
            |> List.filter (fun i -> (i.liveVar = v') 
                                  && (i.witnessed |> List.exists ( snd >> ((=) n) )))
            |> List.collect (fun i -> i.witnessed)
       let coverage = k |> intersect trav.witnessed |> List.map snd
       result v v' coverage
  | _ -> None

let getCopyTraversals (g : Graph<_,_>) allTravs trav =  maybe {
  let! n = tryExactlyOne trav.usedAssignments
  return! g.nodes.[n].instruction |> getProp g n allTravs trav 
}

///This returns NodeId -> instruct<'a>'s that are not valid graphs,
///because const assignments are pruned. 
let private propogate g constTrav = 
  let propConst key node =
    if (constTrav.coverage |> List.contains key)
    then 

        let replace i = if constTrav.var = i
                        then constTrav.value
                        else i
        let replaceAt = function 
          | VarAtom x -> x |> replace |> VarAtom
          | x -> x
        let newInstr =
          match node.instruction with
          | AddI (a,b) -> AddI (a, replaceAt b)
          | CmpI (a,b) -> CmpI (replace a, replaceAt b)
          | SubI (a,b) -> SubI (a, replaceAt b)
          | IMulI (a,b) -> IMulI (a, replaceAt b)
          | AssignI (a,b) -> AssignI (a, replaceAt b)
          | JmpI (l) -> JmpI (l)
          | JzI (l) -> JzI (l)
          | CallI (v,l,args) -> CallI (v, l, List.map replace args)
          | LabelI (l) -> LabelI (l)
          | JnzI l -> JnzI l
          | ReturnI (v) -> ReturnI (replace v)
          | SeteI v -> SeteI v
        {node with instruction = newInstr}
     
    else node
  g |> Map.map propConst

let propogateAllConstants il = 
  let g = il |> toGraph
  let allTravs = g |> getTraversals |> Seq.toList
  let travs = allTravs
           |> Seq.choose (getCopyTraversals g allTravs)
  
  let newG = travs |> Seq.fold propogate g.nodes |> mapValues |> List.map (fun i -> i.instruction)
  let x = newG.Length
  newG

let rec propogateUntilDone' lastTime il = 
  if lastTime = il
  then il 
  else propogateUntilDone' il (propogateAllConstants il)

let propogateUntilDone il = propogateUntilDone' [] il
let propogateCopies m = {m with funcs = m.funcs |> List.map (snd_set propogateUntilDone)}
