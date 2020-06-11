#r "../packages/FSharp.Data/lib/net40/FSharp.Data.dll"
#r "../packages/Newtonsoft.Json/lib/net45/Newtonsoft.Json.dll"

open System
open System.Globalization
open System.IO
open FSharp.Data
open Newtonsoft.Json

type Config = JsonProvider<"./config.json">
type Company = JsonProvider<"./json/ttwo.json">

let getGameInfo url =
    Http.RequestString (
      url     = url, 
      query   = [ "api_key", (Config.GetSample().GiantBomb.ApiKey)
                  "format", "json"
                  "field_list", "name,original_release_date" ])

Company.GetSample().Results.PublishedGames
|> Array.truncate 100
|> Array.Parallel.mapi (fun i game -> 
    printfn "%i" i
    getGameInfo game.ApiDetailUrl)
|> Array.iter (fun s -> printfn "%s" s)
