open System
 
let convertDataRow(csvLine:string) =
    let cells = List.ofSeq(csvLine.Split(','))
    match cells with
    | title::number::_ ->
    let parsedNumber = Int32.Parse(number)
    (title, parsedNumber)
    | _ -> failwith "Incorrect data format"
 
let rec processLines(lines) =
    match lines with
    | [] -> []
    | currentLine::remaining ->
     printf "call to convertDataRow with: %A \n" currentLine
     let parsedLine = convertDataRow(currentLine)
     printf "recursive call to processLines with list: %A \n" remaining
     let parsedReset = processLines(remaining)
     printf "parsedReset is bound to: %A \n" parsedReset
     printf "end of processLines result is: %A \n" (parsedLine :: parsedReset) ; parsedLine :: parsedReset
     
let test = processLines ["Test,123";"test2,456"]