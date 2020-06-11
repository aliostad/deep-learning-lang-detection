namespace OAuth2Client

[<AutoOpen>]
module HttpClientExtensions = 
  type System.Net.Http.HttpClient with
    /// Create a new HttpClient with the Oauth2 auth handler already plugged in.
    /// The storage will be used to gather the existing secrets and credentials,
    /// and to store any newly refreshed credentials from the OAuth2 host.
    /// If no inner handler is specified, a new System.Net.Http.HttpClientHandler
    /// will be created to handle requests.
    static member WithOAuth2(scope:string, ?storage:OAuth2Client.IStorageAsync, ?innerHandler) =
      let handler = if Option.isNone innerHandler then new System.Net.Http.HttpClientHandler() else innerHandler.Value
      let storage : IStorageAsync = defaultArg storage (upcast OAuth2Client.Storage.JsonFileStorage.Default)
      HttpClientFactory.WithOAuth2(scope, storage, null, handler)
