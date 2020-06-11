// from https://www.hackerrank.com/challenges/prefix-compression

module PrefixCompressionModule

open System
open System.Text

let process_strings (str1 : string) (str2 : string) =
    let length1 = str1.Length
    let length2 = str2.Length
    let prefix = new StringBuilder(min length1 length2)
    let rec process_strings_impl index =
        match index with
        | _ when (index = length1) && (index = length2) -> (prefix.ToString(), "", "")
        | _ when (index = length1) && (index < length2) -> (prefix.ToString(), "", str2.Substring(index))
        | _ when (index < length1) && (index = length2) -> (prefix.ToString(), str1.Substring(index), "")
        | _ when str1.[index] <> str2.[index] -> (prefix.ToString(), str1.Substring(index), str2.Substring(index))
        | _ ->
            prefix.Append(str1.[index]) |> ignore
            process_strings_impl (index + 1)
    process_strings_impl 0

let show_result =
    function
    | "" -> printfn "0"
    | str -> printfn "%d %s" str.Length str

[<EntryPoint>]
let main argv = 
    let str1 = Console.ReadLine()
    let str2 = Console.ReadLine()
    let prefix, left, right = process_strings str1 str2
    show_result prefix
    show_result left
    show_result right
    0 // return an integer exit code