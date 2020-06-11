module P4Stats

open System
open System.Diagnostics

// regex active pattern matcher
let (|Regex|_|) pattern input =
    let m = System.Text.RegularExpressions.Regex.Match(input, pattern)
    if m.Success && m.Groups.Count > 1 then
        Some [for i in 1..m.Groups.Count-1 -> m.Groups.[i].Value]
    else
        None

// launch process & get output
let getProcessOutput exe args =
    let startInfo = ProcessStartInfo(exe, args, UseShellExecute = false, RedirectStandardOutput = true)
    let proc = Process.Start(startInfo)

    proc.StandardOutput.ReadToEnd().Split([|'\n'|], System.StringSplitOptions.RemoveEmptyEntries)

// get command-line arguments
let p4port = Environment.GetCommandLineArgs().[1]
let p4user = Environment.GetCommandLineArgs().[2]

// get all changes
let changes =
    getProcessOutput "p4" (sprintf "-p %s changes -u %s" p4port p4user)
    |> Array.map (fun line ->
        match line with
        | Regex @"^Change (\d+)" [id] -> int id
        | _ -> failwithf "Unexpected input: '%s'" line)
    |> Array.sort

// get line diff count for each change
let diffs =
    changes
    |> Array.map (fun id ->
        getProcessOutput "p4" (sprintf "-p %s describe -ds %d" p4port id)
        |> Array.sumBy (fun line ->
            match line with
            | Regex @"add \d+ chunks (\d+) lines" [a] -> int a
            | Regex @"deleted \d+ chunks (\d+) lines" [d] -> - int d
            | Regex @"changed \d+ chunks (\d+) / (\d+) lines" [d; a] -> int a - int d
            | _ -> 0))

// print overall statistics
printfn "%d changes, %d total line diff, %d min, %d max" diffs.Length (Array.sum diffs) (Array.min diffs) (Array.max diffs)
