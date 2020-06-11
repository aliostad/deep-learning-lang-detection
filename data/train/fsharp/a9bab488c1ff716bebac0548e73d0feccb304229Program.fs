module Digest.Console.Program

open System
open System.Diagnostics
open Digest
open Digest.ArticleSource
open Digest.Console.Article

let state = new State()

let enqueueUris uris = 
    uris |> Seq.iter (fun u -> state.QueueForProcessing u)

let rankUri uri =
    async {
        Trace.TraceInformation("Ranking " + uri.ToString())
        if (state.HasProcessedArticle uri) then
            return Seq.empty
        else
            let! a = Article.Get uri
            match a with
                | None -> return Seq.empty
                | Some(article) ->
                    let rank = Article.ClassifyArticle article
                    state.SetRanking article rank
                    return Article.ExtractLinks article
    }


let rec processQueue(item, processFunction) =
    async {
        match item with
            | Some(x) -> 
                let moveNext i = processQueue(i, processFunction)
                let! uris = processFunction x
                enqueueUris uris
                return! moveNext(state.GetNextUri())
            | None -> return ()
    }

let runProgram func = async {
    let reddit = new RedditArticleSource("programming")
    let! uris = reddit.GetArticles()
    enqueueUris uris

    return! processQueue(state.GetNextUri(), func)
}

let runRankingProgram = runProgram rankUri

let showStats() = 
    let count = state.GetArticleCount()
    let top10 = state.GetTopRecommended 10
    printfn "Processed %d articles" count
    printfn "The top 10 articles are..."
    top10 |> Seq.map (fun(KeyValue(k, v)) -> k.ToString()) |> Seq.iter(fun (l) -> printfn "%s" l)

[<EntryPoint>]
let main argv = 
    Trace.Listeners.Add(new ConsoleTraceListener()) |> ignore

    printfn "Please enter 'Run' or 'Show'"
    let userChoice = Console.ReadLine()

    match userChoice.ToLowerInvariant() with 
        | "run" -> runRankingProgram |> Async.RunSynchronously
        | "show" -> showStats()
        | _ -> printfn "Unrecognized Input"

    Console.ReadLine() |> ignore
    0