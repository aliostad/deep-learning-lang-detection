namespace FSCL.Compiler.Processors

open FSCL.Compiler
open Microsoft.FSharp.Quotations
open System.Collections.Generic
open System.Reflection

type ArrayAccessPrinter() =                 
    interface BodyPrettyPrinterProcessor with
        member this.Handle(expr, engine:PrettyPrinterStep) =
            match expr with
            | Patterns.Call(o, methodInfo, args) ->
                if methodInfo.DeclaringType.Name = "IntrinsicFunctions" then
                    let arrayName = engine.Process(args.[0])
                    if methodInfo.Name = "GetArray" then
                        Some(arrayName + "[" + engine.Process(args.[1]) + "]")
                    elif methodInfo.Name = "SetArray" then
                        Some(arrayName + "[" + engine.Process(args.[1]) + "] = " + engine.Process(args.[2]) + ";\n")
                    else
                        None
                else
                    None
            | _ ->
                None