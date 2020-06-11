module datafunctions

open System

let convertDataRow(csvLine:string) =
    let cells = List.ofSeq(csvLine.Split(','))
    match cells with
    | title::number::_ -> 
        let parsedNumber = Int32.Parse(number)
        (title,parsedNumber)
    | _ -> failwith "Incorrect data format!"

let rec processLines(lines) =
    match lines with
    | [] -> []
    | currentLine::remaining ->
        convertDataRow(currentLine) :: processLines(remaining)

let rec calculateSum(rows) =
    match rows with
    | [] -> 0
    | (_, value)::tail -> value + calculateSum(tail)

