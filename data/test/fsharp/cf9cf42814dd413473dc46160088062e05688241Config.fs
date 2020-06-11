namespace SentimentFS.AnalysisServer.Core.Config
open System.Collections.Generic
open SentimentFS.AnalysisServer.Core.Tweets.TwitterApiClient

[<CLIMutable>]
type CassandraConfig = { KeyspaceName: string; EndPoints: string[]; IsAuthenticated: bool; Username: string; Password: string; Replications: Dictionary<string, string> }

[<CLIMutable>]
type Sentiment = { InitFileUrl: string }

[<CLIMutable>]
type AppConfig = { Cassandra: CassandraConfig; Sentiment: Sentiment; TwitterApiCredentials: TwitterCredentials; Port: uint16 }
with static member Zero() = { Cassandra = { KeyspaceName = ""; EndPoints = [||]; IsAuthenticated = false; Username = ""; Password = ""; Replications = Dictionary<string, string>() }
                              Sentiment = { InitFileUrl = "" }
                              TwitterApiCredentials = { ConsumerKey = ""; ConsumerSecret = ""; AccessToken = ""; AccessTokenSecret = "" }
                              Port = 8080us }
