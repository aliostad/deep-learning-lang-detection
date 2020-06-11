namespace StackOverflowApi

module ApiRequests =
   open WebUtilities.WebRequest
   open WebUtilities.WebResponse

   type ReadStatus = All | UnreadOnly
   let readStatusAsUrlRequest = function All -> "" | UnreadOnly -> "/unread"

   type RequestType =
      | Mine
      | ForUser of string

   let requestTypeAsUrlRequest = function
      | Mine -> "/me"
      | ForUser(user) -> "/users/" + user


   type IApiRequest = abstract member requestUrl : unit -> string
   type IAuthenticatedApiRequest = inherit IApiRequest  

   let createApiRequest (request : IApiRequest) =
      createHttpRequest   { Url = request.requestUrl(); RequestType = GET }
         |> addHeader( "Accept-Encoding", "gzip,deflate")

   type ApiAccessToken = { ApiAccessToken : string ; ClientKey : string }
   let createAuthenticatedApiRequest accessToken (request : IAuthenticatedApiRequest) = 
      // Need to append the accessToken details to the Url
      createApiRequest 
         { 
            new IApiRequest 
               with member x.requestUrl() = 
                     let requestUrl = request.requestUrl() 
                     sprintf "%s%s%s" requestUrl  (if requestUrl.Contains("?") then "&" else "?") ( sprintf "access_token=%s&key=%s" accessToken.ApiAccessToken accessToken.ClientKey)
         }


   // TODO: Need to add: ?page=1&pagesize=20 to requests
   module V2_2 =
      open JsonDataObjects

      let baseApiUrl = "https://api.stackexchange.com/2.2/"
 
      module Notifications = 
         let requestName = "Notifications"

         /// Creates a notification request object across all sites
         /// This is for the currently logged in user
         let CreateSiteAgnostic readStatus =
            let url = baseApiUrl + requestName + readStatusAsUrlRequest readStatus
            { new IAuthenticatedApiRequest with member x.requestUrl() = url }

         /// Creates a notification request object for the site specified
         /// and the user requested
         let Create site requestType readStatus =
            let url = 
               baseApiUrl 
               + requestTypeAsUrlRequest requestType 
               + requestName 
               + readStatusAsUrlRequest readStatus
               + "?site=" + site

            { new IAuthenticatedApiRequest with member x.requestUrl() = url }

      module Inbox =
         let requestName = "Inbox"
         type Inbox(readStatus) = 
            interface IAuthenticatedApiRequest with member x.requestUrl() = baseApiUrl + requestName + readStatusAsUrlRequest readStatus  

         let sendRequest token ( request : Inbox ) = 
            createAuthenticatedApiRequest token request
               |> sendRequest Parsers.asJsonObject<JsonStackExchangeCollection<JsonInboxItem>>
