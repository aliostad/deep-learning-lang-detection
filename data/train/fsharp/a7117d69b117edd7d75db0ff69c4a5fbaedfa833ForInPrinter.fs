namespace FSCL.Compiler.Processors

open FSCL.Compiler
open System.Collections.Generic
open System.Reflection
open Microsoft.FSharp.Quotations

type ForInPrinter() =   
    interface BodyPrettyPrinterProcessor with
        member this.Handle(expr, engine:PrettyPrinterStep) =
            match expr with
            | Patterns.Let (inputSequence, value, body) ->
                match value with 
                | Patterns.Call(ob, mi, a) ->
                    if mi.Name = "op_RangeStep" then
                        // The args is the beginning, the step and the end of the iteration
                        let starte, stepe, ende = a.[0], a.[1], a.[2]
                        match body with
                        | Patterns.Let(enumerator, value, body) ->
                            match body with
                            | Patterns.TryFinally (trye, fine) ->
                                match trye with
                                    | Patterns.WhileLoop(cond, body) ->
                                        match body with
                                        | Patterns.Let(v, value, body) ->
                                            match value with
                                            | Patterns.PropertyGet(e, pi, a) ->
                                                // Ok, that's an input sequence!
                                                Some("for(" + engine.Process(v.Type) + " " + v.Name + " = " + engine.Process(starte) + "; " + v.Name + " <= " + engine.Process(ende) + "; " + v.Name + "+=" + engine.Process(stepe) + ") {\n" + engine.Process(body) + "\n}\n")                                                
                                            | _ -> None
                                        | _ -> None
                                    | _ -> None
                                | _ -> None
                            | _ -> None
                        | _ -> None                                           
                    else
                        None
                | _ -> None  
            | _ -> None

        