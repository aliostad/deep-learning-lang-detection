// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.
open System
open NaiveFizzBuzz
open RecursiveFizzBuzz
open FoldReduceFizzBuzz

let ProcessCommand x =
    match x with
    | "exit" -> Environment.Exit(0)
    | "iterate naive" -> printfn "%s" (IterativeFizzBuzz 1 100)
    | "fold" -> printfn "%s" (FoldFizzBuzz 1 100)
    | "reduce" -> printfn "%s" (ReduceFizzBuzz 1 100)
    | "recurse" -> printfn "%s" (RecursiveFizzBuzz 1 100)
    | "tail recurse" -> printfn "%s" (TailRecursiveFizzBuzz 1 100 "")
    | "clear" -> Console.Clear()
    | _ -> printfn "Invalid Command"

[<EntryPoint>]
let main argv = 
    while true do
        printfn "\nCommands:\nexit\niterate naive\nfold\nreduce\nrecurse\ntail recurse\n"
        printf ">"
        Console.ReadLine() |> ProcessCommand
    0 // return an integer exit code
