module CountingWords.Sequential

module private Impl = 
    open System
    open System.Text
    open System.Text.RegularExpressions
    open System.IO
    open System.Linq

    open CountingWords.Common

    let wordChart (words : seq<string>) =
        let d = addWordsToDict (new FreqDict()) words
        d.Select (fun (KeyValue x) -> x)

    let readLines (stream : Stream) = 
        seq {
            use sr = new StreamReader(stream)
            let eof = ref false
            while not !eof do
                match sr.ReadLine() with
                | null -> eof := true
                | l -> yield l
        }
    
    let topWords howMany chart =
        List.ofSeq chart
        |> List.sortBy (fun (k, v) -> v)
        |> List.rev
        |> Seq.truncate howMany

    let top10Words c = topWords 10 c

    let processStream stream =
        readLines stream
        |> Seq.map parseText
        |> Seq.concat
        |> wordChart
        |> top10Words

let processStream = Impl.processStream
    
