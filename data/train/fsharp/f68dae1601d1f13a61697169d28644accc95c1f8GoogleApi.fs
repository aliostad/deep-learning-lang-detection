namespace SquashScrape

open Google.Apis.Auth.OAuth2
open System.Threading
open Google.Apis.Util.Store
open Google.Apis.Services
open System.IO
open System
open Google.Apis.Calendar.v3
open Google.Apis.Gmail.v1

module GoogleApi =

    let scopes =
        [|
        CalendarService.Scope.CalendarReadonly
        GmailService.Scope.GmailSend
        |]
    let applicationName = "Squash Scraper"

    let getCredential () =

        use stream = File.OpenRead "client_secret.json"

        let credPath =
            Environment.GetFolderPath Environment.SpecialFolder.Personal
            |> fun personal -> Path.Combine(personal, ".credentials", "squashscrape-google.json")
    
        let credential =
            GoogleWebAuthorizationBroker.AuthorizeAsync(
                GoogleClientSecrets.Load(stream).Secrets,
                scopes,
                "user",
                CancellationToken.None,
                FileDataStore(credPath, true)).Result

        printfn "Credential file saved to: %s" credPath

        credential
    
    let getInitializer () =
        let initializer = BaseClientService.Initializer()
        initializer.HttpClientInitializer <- getCredential()
        initializer.ApplicationName <- applicationName
        initializer
