// Follow users of @fsibot
#r @"System.Linq.Expressions"

open System
open LinqToTwitter
open System.Configuration

let createContext () =

    let appSettings = ConfigurationManager.AppSettings
    
    let apiKey = appSettings.["TwitterApiKey"]
    let apiSecret = appSettings.["TwitterApiSecret"]
    let accessToken = appSettings.["TwitterAccessToken"]
    let accessTokenSecret = appSettings.["TwitterAccessTokenSecret"]

    let credentials = SingleUserInMemoryCredentialStore()
    credentials.ConsumerKey <- apiKey
    credentials.ConsumerSecret <- apiSecret
    credentials.AccessToken <- accessToken
    credentials.AccessTokenSecret <- accessTokenSecret
    let authorizer = SingleUserAuthorizer()
    authorizer.CredentialStore <- credentials
    new TwitterContext(authorizer)

let run (userName: string, log: TraceWriter) =  

    log.Info(sprintf "Attempt to follow '%s'" userName)
      
    let context = createContext ()
    
    let _ = 
        context.CreateFriendshipAsync(userName, true) 
        |> Async.AwaitTask
        |> Async.RunSynchronously
        
    log.Info(sprintf "Following: '%s'" userName)