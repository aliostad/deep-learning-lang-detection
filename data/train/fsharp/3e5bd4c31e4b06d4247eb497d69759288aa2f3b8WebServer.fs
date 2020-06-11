namespace SentimentFS.AnalysisServer.WebApi

module WebServer =

    open System.IO
    open SentimentFS.AnalysisServer.WebApi.Analysis
    open SentimentFS.AnalysisServer.WebApi.SentimentApi
    open SentimentFS.AnalysisServer.WebApi.Tweets
    open Suave
    open Suave.Logging
    open System.Net
    open Suave.Filters
    open Suave.Operators
    open Suave.RequestErrors
    open Suave.Successful
    open SentimentFS.AnalysisServer.Core.Config
    open Akka.Actor

    let app (config: AppConfig) (system: ActorSystem)  =
        choose [
            sentimentController system
            tweetsController system
            analysisController system
        ]

    let start (config: AppConfig) (system: ActorSystem) =
        let application = app config system
        startWebServer defaultConfig application
