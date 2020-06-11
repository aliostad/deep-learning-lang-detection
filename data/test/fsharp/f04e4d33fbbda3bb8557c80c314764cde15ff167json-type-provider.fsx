(*
Type Providers: fsharp.data and the JSON type provider
*)

// StackExchange API
// https://api.stackexchange.com/docs

// https://api.stackexchange.com/docs/questions

#r "packages/FSharp.Data/lib/net40/FSharp.Data.dll"
open FSharp.Data

// get an example response from the API, create a type from it
// https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow

type Question = JsonProvider<"https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&site=stackoverflow">
let sample = Question.GetSample()

sample.Items
|> Seq.map (fun q -> q.Title, q.Owner.DisplayName)

// I can now start making queries...

let questionTagged (tag:string) = 
    sprintf "https://api.stackexchange.com/2.2/questions?order=desc&sort=activity&tagged=%s&site=stackoverflow" tag

let fsharp = "F%23"

questionTagged fsharp 
|> Question.Load 
|> fun qs -> qs.Items
|> Seq.map (fun q -> q.Owner.DisplayName)
|> Seq.distinct
|> Seq.toList

