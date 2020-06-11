namespace StackOverflow.Test.Console

module main =
   open System
   open System.Windows.Forms

   open WebUtilities.WebRequest
   open WebUtilities.WebResponse

   open StackOverflowApi.OAuth
   open StackOverflowApi.ApiRequests

   open BrowserWindow
   open OAuthClientAppSettings

   let getAccessToken accessCode = 
      async {
         let! accessResponse = sendAccessRequest OAuthParams accessCode
         match accessResponse with
         | Success(token) -> System.Diagnostics.Debug.WriteLine(token); return token.Token
         | WebException(exn) -> System.Diagnostics.Debug.WriteLine(exn.ToString()); return exn.Message
         | ApiErrorResponse(statusCode, statusDesc, apiResponse) -> System.Diagnostics.Debug.WriteLine(apiResponse); return statusDesc
      } 

   let simulateSomeRequest accessToken = 
      System.Diagnostics.Debug.WriteLine(accessToken)
      async { 
//         let! response = createHttpRequest2 { Url = "https://api.stackexchange.com/2.2/Notifications?" + "access_token=" + accessToken + "&key=" + OAuthParams.ClientKey; RequestType = GET } |> sendRequest Parsers.asString 
//         let! response = createHttpRequest2 { Url = "https://api.stackexchange.com/2.2/me/Notifications?site=StackOverflow&" + "access_token=" + accessToken + "&key=" + OAuthParams.ClientKey; RequestType = GET } |> sendRequest Parsers.asString 
//         let! response = createAuthenticatedApiRequest { ApiAccessToken = accessToken ; ClientKey = OAuthParams.ClientKey } (V2_2.Notifications.Notifications()) |> sendRequest Parsers.asString 
//         let! response = createAuthenticatedApiRequest { ApiAccessToken = accessToken ; ClientKey = OAuthParams.ClientKey } (V2_2.Notifications.NotificationsForMe("stackoverflow")) |> sendRequest Parsers.asString 

         let rqst = V2_2.Inbox.Inbox(All)
         let! response = V2_2.Inbox.sendRequest { ApiAccessToken = accessToken ; ClientKey = OAuthParams.ClientKey }  rqst

         match response with
            | Success(value) -> System.Diagnostics.Debug.WriteLine(value)
            | _ -> System.Diagnostics.Debug.WriteLine("Error")
         return()
      } |> Async.Start

   let onUserHasBeenAuthenticated accessCode =
      async {
         let! accessToken = getAccessToken accessCode
         simulateSomeRequest accessToken
         return ()
      } |> Async.Start


   [<EntryPoint>]
   [<STAThread>]
   let main argv = 
      let soAuthUrl = buildRequestUrl OAuthParams

      Application.EnableVisualStyles()
      let form, browser = showWebBrowser

      browser.Navigate(new System.Uri(soAuthUrl))
      browser.Navigated 
         |> Observable.filter ( fun args -> args.Url.Host = OAuthParams.RedirectUrl.Replace("http://", ""))
         |> Observable.map ( fun args -> getAccessCodeFromUrl args.Url)
         |> Observable.subscribe (fun accessCode ->  onUserHasBeenAuthenticated accessCode.Value |> ignore)
         |> ignore

      Application.Run(form)
      0
       
        