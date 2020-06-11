(*
Copyright 2015 Quicken Loans

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*)
[<RequireQualifiedAccess>]
module internal MessageRouter.Meta

open MessageRouter.Common

open Microsoft.FSharp.Linq.RuntimeHelpers
open Microsoft.FSharp.Reflection
open Microsoft.FSharp.Quotations
open Microsoft.FSharp.Quotations.ExprShape
open Microsoft.FSharp.Quotations.Patterns

open System
open System.Collections.Concurrent
open System.Reflection
open System.Threading.Tasks
  
let (|Method|_|) (expr:Expr<'e>) =
  let rec walk = function
  | Call              (_,meth,_)  ->  Some meth
  | ShapeLambda       (_,e)       ->  walk e
  | ShapeCombination  (_,exprs)   ->  exprs
                                      |> List.map walk
                                      |> List.tryPick id
  | _                             ->  None
  walk expr

let (|Interface|_|) (target:Type) (suspect:Type) =
  if suspect.HasStrictInterface target then Some suspect else None

let (|Command|_|) suspect = (|Interface|_|) (typeof<ICommand>) suspect
let (|Event|_|)   suspect = (|Interface|_|) (typeof<IEvent>)   suspect

let fillOpenGeneric<'t> filling =
  if typeof<'t>.GenericTypeArguments.Length > 0
    then typedefof<'t>.MakeGenericType [| filling |]
    else raise (InvalidTypeDef typeof<'t>)

let getMethodForCommand messageType = 
  let target = fillOpenGeneric<IHandleCommand<_>> messageType
  match <@ fun (t:IHandleCommand<_>) args -> t.Handle args @> with
  | Method m  -> (target,target.GetMethod m.Name)
  | _         -> raise QuantumFluxError

let getMethodForEvent messageType = 
  let target = fillOpenGeneric<IHandleEvent<_>> messageType
  match <@ fun (t:IHandleEvent<_>) args -> t.Handle args @> with
  | Method m  -> (target,target.GetMethod m.Name)
  | _         -> raise QuantumFluxError

let methodToFunction (resolver:IResolver) (act:MethodInfo) handlerType  =
  if resolver.CanResolve handlerType
    then  let handler = <@ resolver.Get handlerType @>
          let action :Expr<'msg action> = 
            <@ fun msg quit -> act.Invoke (%handler,[| msg; quit |]) |> unbox<Task> @>
          action
          |> LeafExpressionConverter.EvaluateQuotation
          |> unbox<'msg action> 
          |> Some
    else  None

let buildCommandHandler resolver handlerTypes messageType =
  let iface,handle  = getMethodForCommand messageType
  let buildAction   = methodToFunction resolver handle
  let handlerTypes  = handlerTypes |> Seq.choose ((|Interface|_|) iface)
  //NOTE: the type returned from Seq.choose is 
  //      the type which will be pulled from the IResolver at execution!!!
  match List.ofSeq handlerTypes with
  | []  ->  CommandHandler  None
  | [h] ->  CommandHandler (buildAction h)
  | _   ->  Error (MultipleCommandHandlers messageType)

let buildEventHandlers resolver handlerTypes messageType =
  let iface,handle  = getMethodForEvent messageType
  let buildAction   = methodToFunction resolver handle
  handlerTypes
  |> Seq.choose ((|Interface|_|) iface)
  //NOTE: the type returned from Seq.choose is 
  //      the type which will be pulled from the IResolver at execution!!!
  |> Seq.choose buildAction 
  |> EventHandlers

let extractHandlers resolver handlerTypes messageType =
  match messageType with
  | Command _ -> buildCommandHandler resolver handlerTypes messageType
  | Event   _ -> buildEventHandlers resolver handlerTypes messageType
  | _         -> Error (InvalidMessage messageType)

let findHandlers(catalog:ConcurrentDictionary<_,_>) extractor msgType =
    let msgType = 
      //HACK: because F# Unions look different at run-time than they do at compile-time!
      if FSharpType.IsUnion msgType then msgType.BaseType else msgType
    try
      catalog.GetOrAdd (msgType,valueFactory=Func<_,_>(extractor))
    with
      | error -> Error error
