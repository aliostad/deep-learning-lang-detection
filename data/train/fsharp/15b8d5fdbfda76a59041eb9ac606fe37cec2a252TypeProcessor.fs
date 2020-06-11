[<AutoOpen>]
module TypeProcessor

open System
open Mono.Cecil

type ExecutionContext = {
  Module : ModuleDefinition
  Logger : Logger
}

type TypeProcessingParameters = {
  Type:TypeDefinition
  Module:ModuleDefinition
  /// Get the properties to process
  Properties:PropertyDefinition list 
  NumberOfProperties:int}
  

let selectTypesForProcessing (types:TypeDefinition seq) = query {
  for typeDef in types do
  where (typeDef.IsPublic 
    && not(typeDef.IsInterface)
    && not(typeDef.IsAbstract) 
    && not(typeDef.IsGenericInstance)
    && not(typeDef.HasDeconstructor)
    && typeDef.Properties.Count > 1)
  select typeDef
}

let getProcessingParameters (moduleDefinition:ModuleDefinition) (typeDef:TypeDefinition) =
  let readableProps = typeDef |> getReadableProperties |> Seq.toList
  let propCount = readableProps |> List.length
  { Type =typeDef; Module = moduleDefinition; Properties=readableProps;NumberOfProperties=propCount}

let processType context (parameters:TypeProcessingParameters) = ()

let processTypes (context:ExecutionContext) (types:TypeDefinition seq) =
  let getParameters typeDef = getProcessingParameters context.Module typeDef
  let toProcess = 
    types 
    |> Seq.map getParameters
    |> Seq.filter (fun p -> p.NumberOfProperties > 1)

  toProcess  |> Seq.iter (processType context) 

let execute (context:ExecutionContext) = 
  let moduleDefinition = context.Module
  let types = moduleDefinition.Types |> selectTypesForProcessing
  processTypes context types

