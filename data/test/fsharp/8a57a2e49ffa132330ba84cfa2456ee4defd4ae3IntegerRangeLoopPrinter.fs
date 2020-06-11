namespace FSCL.Compiler.Processors

open FSCL.Compiler
open System.Collections.Generic
open System.Reflection
open Microsoft.FSharp.Quotations

type IntegerRangeLoopPrinter() =   
    interface BodyPrettyPrinterProcessor with
        member this.Handle(expr, engine:PrettyPrinterStep) =
            match expr with
            | Patterns.ForIntegerRangeLoop(var, startexpr, endexp, body) ->
                Some("for(" + engine.Process(var.Type) + " " + var.Name + " = " + engine.Process(startexpr) + "; " + var.Name + " <= " + engine.Process(endexp) + ";" + var.Name + "++) {\n" + engine.Process(body) + "\n}\n")
            | _ ->
                None
           