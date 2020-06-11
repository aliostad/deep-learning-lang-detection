// http://www.meetup.com/thefunclub/events/104441382/
module CountingWords.Main

open System
open System.IO

[<EntryPoint>]
let main argv = 
    let processFun, filePath =
        match argv with
        | [| filePath |]
        | [| "-p"; filePath |] ->
            let bufferSize =
                let fileSize = System.IO.FileInfo(filePath).Length
                let cores = System.Environment.ProcessorCount
                max (200 * 1024) (int <| min (5000L * 1024L) (fileSize / (int64 cores)))
            Parallel.processStream bufferSize, filePath
        | [| "-p200k"; filePath |] -> Parallel.processStream (200 * 1024), filePath
        | [| "-p2mb"; filePath |] ->  Parallel.processStream (2000 * 1024), filePath
        | [| "-p10mb"; filePath |] -> Parallel.processStream (10000 * 1024), filePath
        | [| "-s"; filePath |] -> Sequential.processStream, filePath
        | _ -> failwith "USAGE: CountingWords.exe [-s|-p|-p200k|-p2mb|-p10mb] <file path>"

    let sw = new System.Diagnostics.Stopwatch()
    sw.Start()

    let chart =
        use stream = new FileStream(filePath, FileMode.Open)
        processFun stream

    sw.Stop()

    let printChart chart =
        for (word, count) in chart do
            printfn "%s: %d" word count

    printChart chart

    printfn "Time: %A" sw.Elapsed

    0 // return an integer exit code
