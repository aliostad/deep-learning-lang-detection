open System

let convertDataRow(str:string) =
    let cells = List.ofSeq(str.Split(','))
    match cells with
    | lbl::num::_->
        let numI = Int32.Parse(num)
        (lbl, numI)
    | _ -> failwith "Incorrect data format!"

let rec processLines (lines) =
    match lines with
    | [] -> []
    | str :: tail ->
        let row = convertDataRow(str)
        let rest = processLines (tail)
        row :: rest

let rec countSum (rows) =
    match rows with
    | [] -> 0
    | (_, n) :: tail ->
        let sumRest = countSum (tail)
        n + sumRest

open System.IO

let lines = List.ofSeq(File.ReadAllLines(@"C:\Users\user\Desktop\Population.csv"))
let data = processLines(lines)
let sum = float(countSum(data))

for (lbl, num) in data do
    let perc = int((float(num)) / sum * 100.0)
    Console.WriteLine("{0,-18} - {1,8}  ({2}%)",
                        lbl, num, perc)