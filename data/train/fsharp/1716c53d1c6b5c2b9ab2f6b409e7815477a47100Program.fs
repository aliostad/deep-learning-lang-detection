// from https://www.hackerrank.com/challenges/sequence-full-of-colors

module ColorsSequenceModule

open System
open System.Text

let check_prefix (red, green, yellow, blue) =
    match (red, green, yellow, blue) with
    | _ when (abs (red - green) > 1) -> false
    | _ when (abs (yellow - blue) > 1) -> false
    | _ -> true

let check_result (red, green, yellow, blue) =
    match (red, green, yellow, blue) with
    | _ when red <> green -> false
    | _ when yellow <> blue -> false
    | _ -> true

let parse_color ch (red, green, yellow, blue) =
    match ch with
    | 'R' -> red + 1, green, yellow, blue
    | 'G' -> red, green + 1, yellow, blue
    | 'Y' -> red, green, yellow + 1, blue
    | 'B' -> red, green, yellow, blue + 1
    | _ -> failwith "Unknown color"

let process_color (str : string) =
    let charSeq = str.GetEnumerator()
    let rec process_color_impl (red, green, yellow, blue) =
        match charSeq.MoveNext() with
        | false -> check_result (red, green, yellow, blue)
        | true ->
            let (newRed, newGreen, newYellow, newBlue) = parse_color charSeq.Current (red, green, yellow, blue)
            let checkResult = check_prefix (newRed, newGreen, newYellow, newBlue)
            match checkResult with
            | false -> false
            | true -> process_color_impl (newRed, newGreen, newYellow, newBlue)
    process_color_impl (0, 0, 0, 0)

let output_result =
    function
    | true -> printfn "True"
    | false -> printfn "False"

[<EntryPoint>]
let main argv = 
    let count = Console.ReadLine() |> int
    let source = [for _ in 1 .. count -> Console.ReadLine()]
    let dest = source |> List.map (fun item -> process_color item)
    dest |> List.iter output_result
    0 // return an integer exit code