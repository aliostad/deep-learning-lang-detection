#if INTERACTIVE
#r "System.Core"
#r "FSharp.PowerPack"
#endif
open System
open System.IO
open System.Text.RegularExpressions

let dir = @"G:\gutenberg\bibles"
let soughtWord = new Regex("Christ")

let main() =
    let files = Directory.GetFiles(dir)
    let processFile file =
        printfn "file: %s" file
        let stream = File.OpenText(file)
        let s = stream.ReadToEnd()
        let matches = soughtWord.Matches s
        printfn "result: %s - %i" file matches.Count 
    Seq.iter processFile files
// Vista:    00:00:22.577, CPU: 00:00:09.219
// Win7+HD:  00:00:04.967, CPU: 00:00:05.647
// Win7+Key: 00:00:04.800, CPU: 00:00:05.569

let asyncMain() =
    let files = Directory.GetFiles(dir)
    let processFile file =
        async { printfn "file: %s" file
                let! stream = File.AsyncOpenText(file)
                let! s = stream.AsyncReadToEnd()
                let matches = soughtWord.Matches s
                printfn "result: %s - %i" file matches.Count }
    Async.RunSynchronously (Async.Parallel (Seq.map processFile files))
// Vista:     00:01:24.375, CPU: 00:00:08.533
// Win7+HD:  00:00:28.032, CPU: 00:00:07.238
// Win7+Key: 00:00:08.135, CPU: 00:00:05.428

let asyncMain1() =
    let files = Directory.GetFiles(dir)
    let processFile file =
        async { printfn "file: %s" file
                let stream = File.OpenText(file)
                let! s = stream.AsyncReadToEnd()
                let matches = soughtWord.Matches s
                printfn "result: %s - %i" file matches.Count }
    Async.RunSynchronously (Async.Parallel (Seq.map processFile files))
// Vista:    00:01:28.825, CPU: 00:00:08.533
// Win7+HD:  out of memory
// Win7+Key: out of memory

let asyncMain2() =
    let files = Directory.GetFiles(dir)
    let processFile file =
        async { printfn "file: %s" file
                let! stream = File.AsyncOpenText(file)
                let s = stream.ReadToEnd()
                let matches = soughtWord.Matches s
                printfn "result: %s - %i" file matches.Count }
    Async.RunSynchronously (Async.Parallel (Seq.map processFile files))
// Vista:    00:00:43.320, CPU: 00:00:08.346
// Win7+HD:  00:00:15.360, CPU: 00:00:06.676, 
// Win7+Key: 00:00:03.809, CPU: 00:00:05.553