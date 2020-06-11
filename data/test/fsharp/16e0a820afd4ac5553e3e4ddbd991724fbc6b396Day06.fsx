open System
open System.IO
open System.Collections.Generic

let process size f (ss : string[]) =
    let result = Array.init size (fun _ -> List<char>())
    for s in ss do
        for i in 0..(size - 1) do
            result.[i].Add(s.[i])
    result
    |> Array.map (fun lst ->
        lst
        |> Seq.countBy id
        |> f (fun (key, count) -> (count, key))
        |> fst)
    |> String

let input = File.ReadAllLines(__SOURCE_DIRECTORY__ + "/input.txt")
input |> process 8 Seq.maxBy |> printfn "Part 1: %s"
input |> process 8 Seq.minBy |> printfn "Part 2: %s"