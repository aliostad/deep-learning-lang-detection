module Naggum.Assembler.Processor

open System
open System.IO
open System.Reflection

open Naggum.Assembler.Representation
open Naggum.Backend
open Naggum.Backend.Matchers

let private (|SimpleOpCode|_|) = function
    | Symbol "add" -> Some (Simple Add)
    | Symbol "div" -> Some (Simple Div)
    | Symbol "mul" -> Some (Simple Mul)
    | Symbol "ret" -> Some (Simple Ret)
    | Symbol "sub" -> Some (Simple Sub)
    | _ -> None

let private processMetadataItem = function
    | Symbol ".entrypoint" -> EntryPoint
    | other -> failwithf "Unrecognized metadata item definition: %A" other

let private resolveAssembly _ =
    Assembly.GetAssembly(typeof<Int32>) // TODO: Assembly resolver

let private resolveType name =
    let result = Type.GetType name // TODO: Resolve types from the assembler context
    if isNull result then
        failwithf "Type %s could not be found" name

    result

let private resolveTypes =
    List.map (function
              | Symbol name -> resolveType name
              | other -> failwithf "Unrecognized type: %A" other)

let private processMethodSignature = function
    | [Symbol assembly
       Symbol typeName
       Symbol methodName
       List argumentTypes
       Symbol returnType] ->
        { Assembly = Some (resolveAssembly assembly) // TODO: Resolve types from current assembly
          ContainingType = Some (resolveType typeName) // TODO: Resolve methods without a type (e.g. assembly methods)
          Name = methodName
          ArgumentTypes = resolveTypes argumentTypes
          ReturnType = resolveType returnType }
    | other -> failwithf "Unrecognized method signature: %A" other

let private processInstruction = function
    | List [Symbol "ldstr"; String s] -> Ldstr s
    | List [Symbol "ldc.i4"; Integer i] -> LdcI4 i
    | List [Symbol "call"; List calleeSignature] ->
        let signature = processMethodSignature calleeSignature
        Call signature
    | List [SimpleOpCode r] -> r
    | other -> failwithf "Unrecognized instruction: %A" other

let private addMetadata metadata method' =
    List.fold (fun ``method`` metadataExpr ->
                   let metadataItem = processMetadataItem metadataExpr
                   { ``method`` with Metadata = Set.add metadataItem ``method``.Metadata })
              method'
              metadata

let private addBody body method' =
    List.fold (fun ``method`` bodyClause ->
                   let instruction = processInstruction bodyClause
                   { ``method`` with Body = List.append ``method``.Body [instruction] })
              method'
              body

let private processAssemblyUnit = function
    | List (Symbol ".method"
            :: Symbol name
            :: List argumentTypes
            :: Symbol returnType
            :: List metadata
            :: body) ->
        let definition =
            { Metadata = Set.empty
              Visibility = Public // TODO: Determine method visibility
              Name = name
              ArgumentTypes = resolveTypes argumentTypes
              ReturnType = resolveType returnType
              Body = List.empty }
        definition
        |> addMetadata metadata
        |> addBody body
        |> Method
    | other -> failwithf "Unrecognized assembly unit definition: %A" other

let private prepareTopLevel = function
    | List (Symbol ".assembly" :: Symbol name :: units) ->
        { Name = name
          Units = List.map processAssemblyUnit units }
    | other -> failwithf "Unknown top-level construct: %A" other

/// Prepares the source file for assembling. Returns the intermediate
/// representation of the source code.
let prepare (fileName : string) (stream : Stream) : Assembly seq =
    let forms = Reader.parse fileName stream
    forms |> Seq.map prepareTopLevel
