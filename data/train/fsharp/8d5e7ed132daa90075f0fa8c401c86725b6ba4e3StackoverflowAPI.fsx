#load "References.fsx"

open System
open FSharp.Data
open System.Web
open AuthParams

let baseUrl = """https://api.stackexchange.com/2.2/"""
let defaultParams = [ 
    ("site", "stackoverflow"); 
    ("access_token", soApiToken); 
    ("key", soApiKey) 
   ]
let buildParamsString (queryParams:(string*string) list) = 
    queryParams 
    |> List.map(fun (name,value) -> 
        (HttpUtility.UrlEncode name),
        (HttpUtility.UrlEncode value)
    )
    |> List.map(fun (name,value) -> sprintf "%s=%s" name value) 
    |> List.reduce (sprintf "%s&%s")
let buildUrl methodName queryParams = 
    let paramsString = (List.append queryParams defaultParams) |> buildParamsString
    sprintf "%s%s?%s" baseUrl methodName paramsString



type QuestionsResult = JsonProvider<"""https://api.stackexchange.com/2.2/questions?site=stackoverflow""">
type AnswersResult = JsonProvider<"""https://api.stackexchange.com/2.2/answers?site=stackoverflow&filter=!9YdnSMKKT""">
type BadgesResult = JsonProvider<"""https://api.stackexchange.com/2.2/badges?site=stackoverflow""">
type CommentsResult = JsonProvider<"""https://api.stackexchange.com/2.2/comments?site=stackoverflow""">
type TagsResult = JsonProvider<"""https://api.stackexchange.com/2.2/tags?site=stackoverflow""">
type UsersResult = JsonProvider<"""https://api.stackexchange.com/2.2/users?site=stackoverflow""">

let getQuestionAnswers id = AnswersResult.Load(buildUrl ("questions/" + string id + "/answers") [])
let getAnswer id = AnswersResult.Load(buildUrl ("answers/" + string id) [])
let getComment id = CommentsResult.Load(buildUrl ("comments/" + string id) [])
let getUser id = UsersResult.Load(buildUrl ("users/" + string id) [ ("pagesize", "100") ])
let getUsers (ids:int seq) = 
    let ids = 
        ids
        |> Seq.map string
        |> Seq.chunkBySize 30
        |> Seq.map ( Seq.reduce(fun x y -> y + ";" + x) )
    ids |> Seq.map getUser |> Seq.map(fun x -> x.Items) |> Seq.concat

let getTopQuestionsByTag tag count = 
    let pagesCount = Math.Floor(float count / 100.) |> int
    [ 1 .. pagesCount ]
    |> List.map (fun page -> 
        QuestionsResult.Load (
            buildUrl "search" [("tagged", tag);  ("order", "desc"); ("sort", "votes"); ("page", string page)]))  
    |> List.map(fun x -> x.Items) |> Array.concat 
