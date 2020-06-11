module Golem.API

open FSharp.Data

let [<Literal>] BaseUrl = "http://api.golem.de/api/"
let [<Literal>] ArticleUrl = BaseUrl + "article/"

let [<Literal>] RequestSuffix = "/?format=json&key="

type ArticleType = | Latest | Top 

let asString = function
    | Latest -> "latest"
    | Top -> "top"

type Article = JsonProvider<"article.json">

let fetchArticles developerKey articleType (limit : option<int>) =
    let articleTypeAsString = articleType |> asString
    let url =
        match limit with
        | Some data -> ArticleUrl + articleTypeAsString + string(data) + RequestSuffix + developerKey
        | None -> ArticleUrl + articleTypeAsString + RequestSuffix + developerKey
    Article.Load url