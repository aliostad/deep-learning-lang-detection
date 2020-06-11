namespace OAuth2Client
open System.Runtime.InteropServices

type HttpClientFactory = 
  static member WithOAuth2( scope,
                            [<Optional;DefaultParameterValue(null)>]?storage,
                            [<Optional;DefaultParameterValue(null)>]?proxy : System.Net.IWebProxy,
                            [<Optional;DefaultParameterValue(null)>]?handler
                             ) : System.Net.Http.HttpClient =
    let handler =
      if Option.isSome handler then handler.Value else
       let h = new System.Net.Http.HttpClientHandler()
       if proxy.IsSome then 
         h.Proxy <- proxy.Value
       h
    let storage : IStorageAsync = defaultArg storage (upcast OAuth2Client.Storage.JsonFileStorage.Default)
    let oauth2handler = new OAuth2Client.AuthHandler.OAuth2BearerHandler(handler, storage, scope, null)
    new System.Net.Http.HttpClient(oauth2handler)
    