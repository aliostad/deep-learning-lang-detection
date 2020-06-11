// Learn more about F# at http://fsharp.net
// See the 'F# Tutorial' project for more help.

open System
open System.IO

let convertDataRow (csvLine:string) = 
    let cells = csvLine.Split(',') |> Seq.toList
    match cells with
    | title::number::_ ->
        (title, int number)
    | _ -> failwith "Incorrect data format!"

let rec processLines lines = 
    match lines with
    | [] -> []
    | currentLine::remaining ->
        let parsedLine = convertDataRow currentLine
        let parsedTail = processLines remaining
        parsedLine::parsedTail

let main = 
    let stats = 
        File.ReadLines(@"C:\Users\Gabriel\Documents\Visual Studio 2013\Projects\Real World Functional Programming\Chapter 4\population_1900.csv")
        |> Seq.toList
        |> processLines
    
    let sum = stats |> List.sumBy snd
    let percentage x = (float x) / (float sum) * 100.0
    stats 
    |> List.iter (fun (country, value) -> 
                    printfn "%-20s %d (%.2f%%)" country value (percentage value))