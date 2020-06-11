// This project type requires the F# PowerPack at http://fsharppowerpack.codeplex.com/releases
// Learn more about F# at http://fsharp.net
// Original project template by Jomo Fisher based on work of Brian McNamara, Don Syme and Matt Valerio
// This posting is provided "AS IS" with no warranties, and confers no rights.

open System
open Microsoft.FSharp.Text.Lexing

open Ast
open Lexer
open Parser

printfn "Query Parser"

let rec readAndProcess() =
    printf ":"
    match Console.ReadLine() with
    | "quit" -> ()
    | expr ->
        try
            printfn "Lexing [%s]" expr
            let lexbuff = LexBuffer<char>.FromString(expr)

            printfn "Parsing..."
            let equation = Parser.start Lexer.tokenize lexbuff
            printfn "%A\n" equation

        with ex ->
            printfn "Unhandled Exception: %s" ex.Message

        readAndProcess()

readAndProcess()

// http://fsprojects.github.io/FsLexYacc/fslex.html
// http://blog.logicboost.com/2010/09/10/lexing-and-parsing-with-f-part-i/
// https://fsharppowerpack.codeplex.com/wikipage?title=FsLex%20Documentation
// http://en.wikibooks.org/wiki/F_Sharp_Programming/Lexing_and_Parsing