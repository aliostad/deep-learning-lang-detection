// This project type requires the F# PowerPack at http://fsharppowerpack.codeplex.com/releases
// Learn more about F# at http://fsharp.net
// Original project template by Jomo Fisher based on work of Brian McNamara, Don Syme and Matt Valerio
// This posting is provided "AS IS" with no warranties, and confers no rights.

open System
open System.Collections.Generic
open System.Data
open System.Windows.Forms

open Microsoft.FSharp.Text.Lexing

open ExpressionsAst
open Lexer
open Parser
open Environment
open Evaluator

let env = new Environment()
env.EnvSingle.Add("x y", 1.0)
                                               
printfn "Calculator"

let rec readAndProcess() =
    printf ":"
    match Console.ReadLine() with
    | "quit" -> ()
    | expr ->
        try
            printfn "Lexing [%s]" expr
            let lexbuff = LexBuffer<char>.FromString(expr)
            
            printfn "Parsing..."
            let expression = Parser.start Lexer.tokenize lexbuff
            
            printfn "Evaluating Equation..."
            let result = evalExpression expression env
            
            printfn "Result: %s" (result.ToString())
            
        with ex ->
            printfn "Unhandled Exception: %s" ex.Message

        readAndProcess()

readAndProcess()