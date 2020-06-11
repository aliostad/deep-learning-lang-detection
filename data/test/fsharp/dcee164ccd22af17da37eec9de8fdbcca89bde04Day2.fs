module Day2

open System

let private keypad1 =
    (
        (2, 2),
        [
            ["";"";"";"";""];
            ["";"1";"2";"3";""];
            ["";"4";"5";"6";""];
            ["";"7";"8";"9";""];
            ["";"";"";"";""]
        ]
    )

let private keypad2 =
    (
        (1, 3),
        [
            ["";"";"";"";"";"";""];
            ["";"";"";"1";"";"";""];
            ["";"";"2";"3";"4";"";""];
            ["";"5";"6";"7";"8";"9";""];
            ["";"";"A";"B";"C";"";""];
            ["";"";"";"D";"";"";""];
            ["";"";"";"";"";"";""]
        ]
    )

let private processInput =
    let input = Common.readAsLines "Day2.input.txt"
    let instructions = 
        input
        |> Array.map (fun s -> s.Trim().ToCharArray())
    instructions

let private keynumber (keys:string list list) location =
    keys.[snd location].[fst location]

let private move keys (x, y) direction =
    let next =
        match direction with
        | 'L' -> (x - 1, y)
        | 'R' -> (x + 1, y)
        | 'U' -> (x, y - 1)
        | 'D' -> (x, y + 1)   
        | _ -> (x, y)
    let newkey = keynumber keys next
    match newkey with
        | "" -> (x, y)
        | _ -> next

let private findLocation (start, keys) directions =
    directions |> Array.fold (move keys) start

let private findCode keypad instructions =
    let codeChars =
        instructions
        |> Array.map (findLocation keypad)
        |> Array.map (keynumber (snd keypad))
    let code = String.Join("", codeChars)
    code

let part1 = 
    let instructions = processInput
    findCode keypad1 instructions

let part2 = 
    let instructions = processInput
    findCode keypad2 instructions
