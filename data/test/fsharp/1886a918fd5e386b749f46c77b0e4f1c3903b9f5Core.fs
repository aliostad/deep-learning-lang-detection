module FluTe.Core

open Fasterflect
open FSharpx.Collections
open FSharpx.Strings
open System.Text
type IProcessingStep = 
    abstract Name : string
    abstract Process : obj -> obj

module ProcessingSteps = 
    type PropChainStep (props : string seq) = 
        interface IProcessingStep with
            member this.Name = "PropChainStep"
            member this.Process target = 
                let mutable result = target
                for prop in props do
                    result <- result.GetPropertyValue(prop, Flags.InstancePublic ||| Flags.ExactBinding)
                result
    type LambdaStep (lambda : _ -> _) = 
        interface IProcessingStep with
            member this.Name = "LambdaStep"
            member this.Process target = lambda target    

let processAll (steps : IProcessingStep Deque) (inp : obj) =
    steps |> Seq.fold (fun lastOut nextStep -> nextStep.Process(lastOut)) inp

type Input = 
    {Ident : string; Steps : IProcessingStep Deque}
    static member Empty name = {Ident = name; Steps = Deque.empty}
    member this.Process v = processAll (this.Steps) v
type TeActiveObj = {Input : string; Steps : IProcessingStep Deque}

type TeToken = 
| TeLiteral of string
| TeActive of string * TeActiveObj
with
    member this.Ident = match this with | TeLiteral(ident) | TeActive(ident,_) -> ident
    member this.IsActive = match this with | TeLiteral _ -> false | _ -> true
    member this.HasInput = match this with | TeLiteral _ -> false | TeActive _ -> true
    member this.Process (bindings : Map<string,obj>) =
        
        match this with
        | TeLiteral(literal) -> literal :> obj
        | TeActive(ident, {Input = myInput; Steps = steps}) -> 
            let myInput = bindings.[ident]
            processAll steps myInput

type TePrototype = {Tokens : TeToken Deque; 
                TokenSteps : Map<string, IProcessingStep Deque>; 
                FinalSteps : IProcessingStep Deque;
                Inputs : Map<string,Input>}
    with
        static member internal Create (toks : TeToken list) =
            let mapSteps = toks |> List.map (fun x -> x.Ident, Deque.empty) |> Map.ofList
            let emptyInputs = 
                let chooseInput tok = 
                    match tok with
                    | TeLiteral _ -> None
                    | TeActive (_,{Input=inputName}) -> Input.Empty inputName |> Some
                toks |> List.choose chooseInput |> List.map (fun x -> x.Ident, x) |> Map.ofList
            {Tokens = toks |> Deque.ofList; TokenSteps = mapSteps; FinalSteps = Deque.empty; Inputs = emptyInputs}
        member this.AttachTkStep (name, step : IProcessingStep) = 
            let newList = Deque.conj step (this.TokenSteps.[name]) 
            let newMap = this.TokenSteps |> Map.updateWith (fun cur -> cur |> Deque.conj step |> Some) name
            { this with TokenSteps = newMap} 
        
        member this.AttachFnStep step = 
            {this with FinalSteps = this.FinalSteps |> Deque.conj step}                       

        member this.AttachInStep (name, step) = 
            let newInputs = this.Inputs |> Map.updateWith (fun inp -> {inp with Steps = inp.Steps |> Deque.conj step} |> Some) name
            {this with Inputs = newInputs}
        
        member this.Inst = TeInstance.FromProto(this)
and TeInstance = {Prototype : TePrototype;Inputs : Map<string,obj option>}
    with 
        member this.Bind (name, value : obj) = 
            let input = this.Prototype.Inputs.[name] 
            let processed = input.Process value
            let newInputs = this.Inputs |> Map.updateWith (fun v -> Some <|Some value) name
            { this with Inputs = newInputs}
        static member internal FromProto (prototype : TePrototype) = 
            {Prototype = prototype; Inputs = [for input in prototype.Inputs |> Map.values -> input.Ident, None] |> Map.ofList}
        member this.Eval = 
            let builder = StringBuilder()
            for token in this.Prototype.Tokens  do
                let myStr = 
                    match token with
                    | TeLiteral str -> str
                    | TeActive (ident, {Input = input; Steps = steps}) -> 
                        let overSteps = this.Prototype.TokenSteps.[ident]
                        let processed = 
                            match this.Inputs.[input] with
                            | None -> failwith "Required input not found."
                            | Some(v) -> v |> processAll steps |> processAll overSteps
                        processed |> string
                builder.Append myStr |> ignore
            builder |> processAll this.Prototype.FinalSteps |> string

