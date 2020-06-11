namespace SentimentFS.AnalysisServer.Core.Tests

module Actor =
    open Expecto
    open SentimentFS.AnalysisServer.Core.Actor

    [<Tests>]
    let tests =
        testList "Actor" [
            testList "Actors" [
                test "AnalysisActor" {
                    let subject = Actors.analysisActor
                    Expect.equal subject.Name "analysis" "name should equal tweets"
                    Expect.isNone subject.Parent "Parent should be None"
                    Expect.equal subject.Path "/user/api/analysis" "path should equal /user/api/analysis"
                }
                test "TweetsMaster" {
                    let subject = Actors.tweetsMaster
                    Expect.equal subject.Name "tweets" "name should equal tweets"
                    Expect.isNone subject.Parent "Parent should be None"
                    Expect.equal subject.Path "/user/api/tweets" "path should equal /user/api/tweets"
                }
                test "TweetsDbActor" {
                    let subject = Actors.tweetStorageActor
                    Expect.equal subject.Name "storage" "name should equal storage"
                    Expect.isSome subject.Parent "Parent should be Some"
                    Expect.equal subject.Path "/user/api/tweets/storage" "path should equal /user/api/tweets/storage"
                }
                test "TwitterApiActor" {
                    let subject = Actors.twitterApiActor
                    Expect.equal subject.Name "twitter-api" "name should equal twitter-api"
                    Expect.isSome subject.Parent "Parent should be Some"
                    Expect.equal subject.Path "/user/api/tweets/twitter-api" "path should equal /user/api/tweets/twitter-api"
                }
            ]
        ]
