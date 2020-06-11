module DevRT.Tests.RefactorIntegrationTests

open System
open System.Configuration
open NUnit.Framework
open Swensen.Unquote
open DevRT.IOWrapper
open DevRT.Refactor
open DevRT.RefactorLine

let getRules() =
    ConfigurationManager.AppSettings.["rules"]
    |> getRules readAllLines

let logSet (set: Set<_>) =
    set |> Set.iter (printfn "%A")

let testRefactor before expected =
    let processLine _ = processLineFsFile (getRules())
    let processedFile =
        processFile
            processLine readAllLines processLines before
    let after =
        match processedFile with
        | Some lines -> lines | _ -> failwith "test fails"
    let expected = expected |> readAllLines
    let getDifference change =
        let setDiff, lineCountDiff = change |> difference
        setDiff |> logSet
        (setDiff, lineCountDiff)
    match (expected, after) |> getChanged getDifference with
    | None -> ()
    | _ -> before |> sprintf "test fails %s" |> failwith

[<TestCase("before", "after")>]
[<TestCase("before0", "after0")>]
[<TestCase("before1", "after1")>]
let ``refactor: fs file`` before after =
    testRefactor ( before + ".txt" ) ( after + ".txt" )
