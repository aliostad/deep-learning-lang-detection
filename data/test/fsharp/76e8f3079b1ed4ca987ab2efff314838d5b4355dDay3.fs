module Day3

open System

let private processInput1 =
    let input = Common.readAsLines "Day3.input.txt"
    let triangles = 
        input
        |> Array.map (fun s -> s.Split ([|" "|], StringSplitOptions.RemoveEmptyEntries) |> Array.map (fun n -> int n))
        |> Array.map (fun xyz -> (xyz.[0], xyz.[1], xyz.[2]))
    triangles

let private processInput2 =
    let input = Common.readAsLines "Day3.input.txt"
    let triangles = 
        input
        |> Array.map (fun s -> s.Split ([|" "|], StringSplitOptions.RemoveEmptyEntries) |> Array.map (fun n -> int n))
        |> Array.chunkBySize 3
        |> Array.map (fun group ->
            [|
                (group.[0].[0], group.[1].[0], group.[2].[0]);
                (group.[0].[1], group.[1].[1], group.[2].[1]);
                (group.[0].[2], group.[1].[2], group.[2].[2])
            |])
        |> Array.collect id
    triangles

let isValidTriangle (x, y, z) =
    match (x, y, z) with
    | (x, y, z) when x >= y + z -> false
    | (x, y, z) when y >= x + z -> false
    | (x, y, z) when z >= x + y -> false
    | _ -> true

let validCount triangles =
    triangles
    |> Array.map isValidTriangle
    |> Array.filter id
    |> Array.length

let part1 = validCount processInput1

let part2 = validCount processInput2
