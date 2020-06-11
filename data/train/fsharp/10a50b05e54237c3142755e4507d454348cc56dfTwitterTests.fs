module FSharpNews.Tests.DataPull.Service.TwitterTests

open System
open NUnit.Framework
open Suave.Types
open Suave.Http
open Suave.Web
open FSharpNews.Data
open FSharpNews.Utils
open FSharpNews.Tests.Core

let writeTweet json (req: HttpRequest) =
    async { do! TwitterApi.writeHeaderBodyDelimeter req
            do! TwitterApi.writeMessage req json
            do! TwitterApi.writeEmptyInfinite req }

[<SetUp>]
let Setup() = do Storage.deleteAll()

[<Test>]
let ``One tweet in stream => one activity in storage``() =
    use tw = TwitterApi.runServer (POST >>= url TwitterApi.streamPath >>== TwitterApi.handle (writeTweet TestData.Twitter.streamJson))
    do ServiceApplication.startAndSleep Twitter

    Storage.getAllActivities()
    |> List.map fst
    |> Collection.assertEquiv [TestData.Twitter.streamActivity]

[<Test>]
let ``Retweets are filtered``() =
    use tw = TwitterApi.runServer (POST >>= url TwitterApi.streamPath >>== TwitterApi.handle (writeTweet TestData.Twitter.retweetJson))
    do ServiceApplication.startAndSleep Twitter

    Storage.getAllActivities().Length |> assertEqual 0

[<Test>]
let ``Replies are filtered``() =
    use tw = TwitterApi.runServer (POST >>= url TwitterApi.streamPath >>== TwitterApi.handle (writeTweet TestData.Twitter.replyJson))
    do ServiceApplication.startAndSleep Twitter

    Storage.getAllActivities().Length |> assertEqual 0

[<Test>]
let ``Search since last tweet``() =
    do Storage.save (TestData.Twitter.streamActivity, "")

    use twsearch = TwitterApi.runServer (GET >>= url TwitterApi.searchPath >>= OK TestData.Twitter.searchJson)
    use twstream = TwitterApi.runEmptyStream ()
    do ServiceApplication.startAndSleep Twitter

    let savedTweets = Storage.getAllActivities()
    savedTweets.Length |> assertEqual 2
    savedTweets |> List.map fst |> Collection.assertEquiv [TestData.Twitter.streamActivity; TestData.Twitter.searchActivity]

[<Test>]
let ``fssnip filtered out``() =
    use tw = TwitterApi.runServer (POST >>= url TwitterApi.streamPath >>== TwitterApi.handle (writeTweet TestData.Twitter.fssnipJson))
    do ServiceApplication.startAndSleep Twitter

    Storage.getAllActivities().Length |> assertEqual 0
