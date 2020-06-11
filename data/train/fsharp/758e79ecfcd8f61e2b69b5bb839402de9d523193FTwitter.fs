module FTwitter

open FSharp.Data

open System
open System.IO
open System.Threading
open System.Windows.Forms
open System.Collections.Generic

open FSharp.Control
open FSharp.WebBrowser
open FSharp.Data.Toolbox.Twitter

type ApiKey = JsonProvider<""" {"Secret" : "aabbcc123", "Key" : "abc123", "Pin" : "123abc", "AccessToken" : "abc123", "AccessTokenSecret" : "abc123"} """>

let interestingHashTags = ["#MakeAmericaGreatAgain"; "#Trump2016"]

let apiKey = ApiKey.Parse(File.ReadAllText("C:\\Projects\\fsharpmarkov\\apikey.json"))

let twitter = Twitter.AuthenticateAppSingleUser(apiKey.Key, apiKey.Secret, apiKey.AccessToken, apiKey.AccessTokenSecret)

let rec statuses (hashTags : string list) = 
    seq { for hashTag in hashTags do 
            let results = twitter.Search.Tweets((List.head hashTags))
            for status in results.Statuses do
                yield status 
            } 


