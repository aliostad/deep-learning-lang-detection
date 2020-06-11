module Calculations

open System
open System.IO

let convertDataRow(csvLine:string) =
    let cells = List.ofSeq(csvLine.Split(','))
    match cells with
    | title::number::_ ->
        let parsedNumber = Int32.Parse(number)
        (title, parsedNumber)
    | _ -> failwith "Incorrect data format!"

let rec processLines(lines) =
    match lines with
    | [] -> []
    | currentLine::remaining ->
        let parsedLine = convertDataRow(currentLine)
        let parsedRest = processLines(remaining)
        parsedLine :: parsedRest

let rec calculateSum(rows) =
    match rows with
    | [] -> 0
    | (_,value)::tail -> 
        let remainingSum = calculateSum(tail)
        value + remainingSum

//let x = convertDataRow("title,123")

//let testData = processLines ["Test1,123"; "Tests2,456"]

//let lines = List.ofSeq(File.ReadAllLines("import.txt"))
//let data = processLines(lines)
//let sum = float(calculateSum(data))
//
//for (title, value) in data do
//    let percentage = int((float(value)) / sum * 100.0)
//    Console.WriteLine("{0,-18} - {1, 8} ({2}%)", title, value, percentage)
//Console.WriteLine("-----------------------------------")
//let rk = Console.ReadLine
