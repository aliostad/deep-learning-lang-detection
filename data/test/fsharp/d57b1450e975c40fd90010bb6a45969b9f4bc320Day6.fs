module Day6

open System

let private processInput =
    Common.readAsLines "Day6.input.txt"
    |> Array.map (fun s -> s.ToCharArray())

let transpose (matrix:_[][]) =
    Array.init matrix.[0].Length (fun i -> 
        Array.init matrix.Length (fun j -> 
            matrix.[j].[i]))

let pickChar sortfn chars =
    chars
    |> Seq.groupBy id
    |> Seq.map (fun (char, group) -> (char, Seq.length group))
    |> Seq.sortBy (fun (_, count) -> sortfn count)
    |> Seq.map (fun(char, _) -> char)
    |> Seq.head

let decode sortfn input =
    input
    |> transpose
    |> Seq.map (pickChar sortfn)
    |> Seq.toArray

let part1 =
    let chars = decode (fun n -> -n) processInput
    new String(chars)

let part2 =
    let chars = decode id processInput
    new String(chars)