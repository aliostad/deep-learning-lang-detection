module grabber

open Microsoft.Azure.Documents
open Microsoft.Azure.Documents.Client
open Microsoft.Azure.Documents.Linq
open FSharp.Data

type AppConfig = {
    DbUri : string;
    DbKey : string;
    ApiKey: string;
}

type PlayerSearchResponse = JsonProvider<"""{"status":"ok","meta":{"count":100},"data":[{"nickname":"asdf00000","account_id":2166897},{"nickname":"asdf0072007","account_id":39819189}]}""">

let getPlayersAsync key search = 
    async {
        let reqString = sprintf "https://api.worldoftanks.ru/wot/account/list/?application_id=%s&search=%s" key search
        let! resp = Http.AsyncRequestString(reqString) 
        return PlayerSearchResponse.Parse resp
    }

let doRequest cfg search =
    let getPlayersAsyncWithKey = getPlayersAsync cfg.ApiKey
    let res = [|"Az_"; "Amway"; "Jove"|] |> Array.map getPlayersAsyncWithKey
    res
    
 
let initConfig (args:string[]) =
    match args.Length with
    | 3 -> 
        let config = {DbUri = args.[0]; DbKey = args.[1]; ApiKey = args.[2]}
        Some config
    | _ ->
        let dbUri = match System.Environment.GetEnvironmentVariable "DB_URI" with
                    | null -> ""
                    | s -> s
        let dbKey = match System.Environment.GetEnvironmentVariable "DB_KEY" with
                    | null -> ""
                    | s -> s
        let apiKey = match System.Environment.GetEnvironmentVariable "API_KEY" with
                     | null -> ""
                     | s -> s
        match 0 = dbKey.Length * dbUri.Length * apiKey.Length with
        | false -> Some {DbUri = dbUri; DbKey = dbKey; ApiKey = apiKey}
        | true -> None

type Player() =
    member val account_id = "" with get,set
    member val nickname = "" with get,set


let writeToDbSmth (client:DocumentClient) =
    seq {2..1000}
    |> Seq.iter(fun i ->
                    let p = new Player()
                    printfn "%d" i
                    p.account_id <- i.ToString()
                    p.nickname <- "Test" + i.ToString()
                    let res = client.CreateDocumentAsync(UriFactory.CreateDocumentCollectionUri("stats", "players"), p)
                    res |> Async.AwaitTask |> Async.RunSynchronously |> ignore)


[<EntryPoint>]
let main argv =
    printfn "%A" argv
    let config = initConfig argv
    match config with
    | Some cfg -> 
        printfn "%A" cfg
        let client = new DocumentClient(new System.Uri(cfg.DbUri), cfg.DbKey)
        let res = writeToDbSmth client
        printfn "%A" res
        0
    | None -> 
        printfn "Sad :("
        0
