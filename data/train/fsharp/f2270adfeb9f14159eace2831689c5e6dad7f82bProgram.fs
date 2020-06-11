// from https://www.hackerrank.com/challenges/string-o-permute

module StringPermuteModule

open System
open System.Text

let process_string (source : string) =
    let sourceLength = source.Length
    let storage = new StringBuilder(sourceLength)
    let rec process_string_impl index =
        match index with
        | _ when index = sourceLength -> storage.ToString()
        | _ when index = (sourceLength - 1) -> storage.Append(source.[index]).ToString()
        | _ ->
            storage.Append(source.[index + 1]).Append(source.[index]) |> ignore
            process_string_impl (index + 2)
    process_string_impl 0

[<EntryPoint>]
let main argv = 
    let count = Console.ReadLine() |> int
    let source = [for _ in 1 .. count -> Console.ReadLine()]
    let dest = source |> Seq.map process_string
    dest |> Seq.iter (fun str -> printfn "%s" str)
    0 // return an integer exit code