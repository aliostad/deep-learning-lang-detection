namespace SentimentFS.AnalysisServer.WebApi

module Tweets =
    open SentimentFS.AnalysisServer.Core.Config
    open Akka.Actor
    open SentimentFS.AnalysisServer.Core.Actor
    open SentimentFS.AnalysisServer.WebApi.Storage
    open SentimentFS.AnalysisServer.Core.Tweets.TweetsMaster
    open SentimentFS.AnalysisServer.Core.Tweets.Messages
    open Suave
    open Suave.Filters
    open Suave.Operators
    open Suave.Successful
    open SentimentFS.AnalysisServer.Core.Tweets.Messages

    let tweetsController (system: ActorSystem) =

        let getTweetsBySearchKeys(query: string):WebPart =
            fun (x : HttpContext) ->
                async {
                    let api = system.ActorSelection(Actors.apiActor.Path)
                    let! result = api.Ask<Tweets option>({ key = query }) |> Async.AwaitTask
                    return! (SuaveJson.toJson result) x
                }


        pathStarts "/api/tweets" >=> choose [
            GET >=> choose [ pathScan "/api/tweets/%s" getTweetsBySearchKeys ]
        ]


