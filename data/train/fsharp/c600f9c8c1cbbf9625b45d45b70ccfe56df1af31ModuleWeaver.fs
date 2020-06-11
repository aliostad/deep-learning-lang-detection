// Damjan Namjesnik, August 2013.

namespace Unsealed.Fody

open Mono.Cecil
open Mono.Cecil.Cil
open Mono.Cecil.Rocks

type ModuleWeaver() = 
                             
    let unsealType (t:TypeDefinition) (moduleDefinition:ModuleDefinition) =
        t.IsSealed <- false 
                            

    let processOneType (t:TypeDefinition) (moduleDefinition:ModuleDefinition) =         
        match t.IsSealed with 
        | false -> ()
        | true -> unsealType t moduleDefinition

    let rec processTypes (tl:seq<TypeDefinition>) (moduleDefinition:ModuleDefinition) = 
      tl |> Seq.iter (fun t -> processOneType t moduleDefinition
                               if t.HasNestedTypes then 
                                processTypes t.NestedTypes moduleDefinition
                      ) 

    member val ModuleDefinition:ModuleDefinition = null with get, set

    member val AssemblyResolver:IAssemblyResolver = null with get,set

    member x.Execute() = 
        processTypes x.ModuleDefinition.Types x.ModuleDefinition
        ()