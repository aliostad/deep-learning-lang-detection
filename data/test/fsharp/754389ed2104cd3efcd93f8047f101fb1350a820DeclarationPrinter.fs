namespace FSCL.Compiler.Processors

open FSCL.Compiler
open System.Collections.Generic
open System.Reflection
open Microsoft.FSharp.Quotations

type DeclarationPrinter() =   
    interface BodyPrettyPrinterProcessor with
        member this.Handle(expr, engine:PrettyPrinterStep) =
            match expr with
            | Patterns.Let(v, value, body) ->
                Some(engine.Process(v.Type) + " " + v.Name + " = " + engine.Process(value) + ";\n" + engine.Process(body))
            | _ ->
                None