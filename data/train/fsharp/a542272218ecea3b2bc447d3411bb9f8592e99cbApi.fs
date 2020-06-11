namespace Nebula.XML

open Nebula
open System
open System.Net
open System.Xml.Linq
open FSharp.Data
open FSharpx.Collections
open FSharpx.Http
open System.Xml
open System.Dynamic
open System.Collections.Generic
open ApiTypes
open XmlToExpando
open System.IO
open System.Xml.Linq
open System.Globalization

exception EveApiException of int * string
exception ApiKeyRequiredException

type ApiServer =
    | Tranquility = 0
    | Singularity = 1

/// <summary>
/// This class is main class in the library allowing to
/// connect to EVE Online API (XML) and operate on it's methods.
/// </summary>
type Api(cache:Nebula.ICache, apiKey:APIKey option, apiServer:ApiServer) =

    let emptyParams = []
       
    let getNonAuthenticatedWebClient queryParams = 
        let webClient = new WebClient()
        webClient.QueryString <- queryParams |> NameValueCollection.ofSeq
        webClient

    let getAuthenticatedWebClient queryParams = 
        match apiKey with
        | Some(key) ->
            let webClient = new WebClient()
            let nvc = [ "keyID", string(key.KeyId); "vCode", key.VerificationCode ] 
                        |> List.append queryParams
                        |> NameValueCollection.ofSeq 

            webClient.QueryString <- nvc
            webClient
        | None -> raise ApiKeyRequiredException

    let queryApiServer url (webClient: WebClient) :XmlEveResponse = 
        let getUri() =
            let baseUrl = match apiServer with
                          | ApiServer.Singularity -> "https://api.testeveonline.com/"
                          | ApiServer.Tranquility -> "https://api.eveonline.com/"
                          | _ -> ""
            new Uri(baseUrl + url)

        let getData() = 
            try
                async {
                    let! data = webClient.AsyncDownloadString(getUri())
                    return data
                } |> Async.RunSynchronously
            with
            | :? WebException as ex ->
                (new System.IO.StreamReader(ex.Response.GetResponseStream())).ReadToEnd()

        let cacheKey = webClient.QueryString 
                        |> NameValueCollection.toList 
                        |> List.append ["url", url.ToString()]
                        |> List.fold (fun acc x -> acc + "||" + 
                                                   match x with
                                                   | (a, b) -> a + "|" + b) ""
        

        match cache.Get(cacheKey) with
        | Some(result) -> result |> createXmlObject
        | None -> 
            let response = getData() 
            let parsedResponse = response |> createXmlObject
            match parsedResponse.Result with
            | Some(result) -> 
                cache.Set cacheKey response (parsedResponse.CachedUntil - parsedResponse.CurrentTime)
                parsedResponse
            | None -> 
                if parsedResponse.Error.IsSome then
                    let error = parsedResponse.Error.Value
                    raise (EveApiException (error.Code, error.Message))
                else
                    parsedResponse

    let authenticatedCall url parameters =
        getAuthenticatedWebClient parameters
        |> queryApiServer url 
      
    let nonAuthenticatedCall url parameters = 
        getNonAuthenticatedWebClient parameters
        |> queryApiServer url 

    /// <summary>
    /// API server 
    /// </summary>
    member x.ApiServer = apiServer

    /// <summary>
    /// Instance of ICache responsbile for caching API requests.
    /// </summary>
    member x.Cache = cache

    /// <summary>
    /// Instance of APIKey used to query API server
    /// </summary>
    member x.APIKey = apiKey

    /// <summary>
    /// Returns status of account. Requires API key.
    /// </summary>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    member x.AccountStatus() =
        authenticatedCall "/account/AccountStatus.xml.aspx" emptyParams
        |> API.Account.Calls.AccountStatus 

    /// <summary>
    /// Returns API key info. Requires API key.
    /// </summary>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    member x.AccountAPIKeyInfo() =
        authenticatedCall "/account/APIKeyInfo.xml.aspx" emptyParams
        |> API.Account.Calls.APIKeyInfo 

    /// <summary>
    /// Returns characters on account. Requires API key.
    /// </summary>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    member x.AccountCharacters() =
        let characters = authenticatedCall "/account/Characters.xml.aspx" emptyParams
                         |> API.Account.Calls.Characters

        for character in characters do
            character.Api <- x

        characters

    /// <summary>
    /// Returns map for factional warfare.
    /// </summary>
    /// <exception cref="EveApiException"></exception>
    member x.MapFactionalWarfareSystems() =
        nonAuthenticatedCall "/map/FacWarSystems.xml.aspx" emptyParams
        |> API.Map.Calls.FacWarSystems

    /// <summary>
    /// Returns jumps.
    /// </summary>
    /// <exception cref="EveApiException"></exception>
    member x.MapJumps() =
        nonAuthenticatedCall "/map/Jumps.xml.aspx" emptyParams
        |> API.Map.Calls.Jumps

    /// <summary>
    /// Returns kills.
    /// </summary>
    /// <exception cref="EveApiException"></exception>
    member x.MapKills() =
        nonAuthenticatedCall "/map/Kills.xml.aspx" emptyParams
        |> API.Map.Calls.Kills

    /// <summary>
    /// Returns sovereignty data.
    /// </summary>
    /// <exception cref="EveApiException"></exception>
    member x.MapSovereignty() =
        nonAuthenticatedCall "/map/Sovereignty.xml.aspx" emptyParams
        |> API.Map.Calls.Sovereignty

    /// <summary>
    /// Returns account balance for character. Requires API key.
    /// </summary>
    /// <param name="characterId">character id</param>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    member x.CharAccountBalance (characterId:int) =
        authenticatedCall "/char/AccountBalance.xml.aspx" [ "characterID", string(characterId) ]
        |> API.Character.Calls.AccountBalance

    /// <summary>
    /// Returns asset list for character. Requires API key.
    /// For detailed explanation of field values go to: https://neweden-dev.com/Char/AssetList
    /// </summary>
    /// <param name="characterId">character id</param>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    member x.CharAssetList (characterId:int) =
        authenticatedCall "/char/AssetList.xml.aspx" [ "characterID", string(characterId) ]
        |> API.Character.Calls.AssetList

    /// <summary>
    /// Returns blueprints list for character. Requires API key.
    /// For detailed explanation of field values go to: https://neweden-dev.com/Char/Blueprints
    /// </summary>
    /// <param name="characterId">character id</param>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    member x.CharBlueprints (characterId:int) = 
        authenticatedCall "char/Blueprints.xml.aspx" ["characterID", string(characterId)]
        |> API.Character.Calls.Blueprints

    member x.CharacterSheet (characterId:int) =
        authenticatedCall "char/CharacterSheet.xml.aspx" ["characterID", string(characterId)]
        |> API.Character.Calls.CharacterSheet

    member x.CharBookmarks (characterId:int) =
        authenticatedCall "char/Bookmarks.xml.aspx" ["characterID", string(characterId)]
        |> API.Character.Calls.Bookmarks

    /// <summary>
    /// Creates API object for querying EVE Online XML backend. Using Tranquility server by default.
    /// Some methods will throw <see cref="ApiKeyRequiredException">ApiKeyRequiredException</see> if they require API key to be executed.
    /// </summary>
    /// <param name="cache">ICache instance</param>
    new(cache:Nebula.ICache) = Api(cache, None, ApiServer.Tranquility)

    /// <summary>
    /// Creates API object for querying EVE Online XML backend. Using Tranquility server by default.
    /// </summary>
    /// <param name="cache">ICache instance</param>
    /// <param name="apiKey">API key</param>
    new(cache:Nebula.ICache, apiKey:APIKey) = Api(cache, Some(apiKey), ApiServer.Tranquility)

    /// <summary>
    /// Creates API object for querying EVE Online XML backend.
    /// </summary>
    /// <param name="cache">ICache instance</param>
    /// <param name="apiKey">API key</param>
    /// <param name="apiServer">API server</param>
    new(cache:Nebula.ICache, apiKey:APIKey, apiServer:ApiServer) = Api(cache, Some(apiKey), apiServer)

[<System.Runtime.CompilerServices.Extension>]
module CharacterExtensions =
    open System.Runtime.CompilerServices

    let apiCast (api:obj) = api :?> Api
    // C# way of adding extension methods...

    /// <summary>
    /// Returns account balance for character. Requires API key.
    /// </summary>
    /// <param name="characterId">character id</param>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    [<Extension>]
    let AccountBalance(c : API.Account.Records.Character) = 
        let api = c.Api |> apiCast 
        api.CharAccountBalance c.CharacterId    
        
    /// <summary>
    /// Returns asset list for character. Requires API key.
    /// For detailed explanation of field values go to: https://neweden-dev.com/Char/AssetList
    /// </summary>
    /// <param name="characterId">character id</param>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    [<Extension>]    
    let AssetList(c:API.Account.Records.Character) =
        let api = c.Api |> apiCast 
        api.CharAssetList c.CharacterId

    /// <summary>
    /// Returns blueprints list for character. Requires API key.
    /// For detailed explanation of field values go to: https://neweden-dev.com/Char/Blueprints
    /// </summary>
    /// <param name="characterId">character id</param>
    /// <exception cref="EveApiException"></exception>
    /// <exception cref="ApiKeyRequiredException"></exception>
    [<Extension>]    
    let Blueprints(c:API.Account.Records.Character) =
        let api = c.Api |> apiCast 
        api.CharBlueprints c.CharacterId



    // F# way...
    type Nebula.XML.API.Account.Records.Character with
        /// <summary>
        /// Returns account balance for character. Requires API key.
        /// </summary>
        /// <param name="characterId">character id</param>
        /// <exception cref="EveApiException"></exception>
        /// <exception cref="ApiKeyRequiredException"></exception>
        member public x.AccountBalance() =
            let api = x.Api |> apiCast 
            api.CharAccountBalance x.CharacterId
        
        /// <summary>
        /// Returns asset list for character. Requires API key.
        /// For detailed explanation of field values go to: https://neweden-dev.com/Char/AssetList
        /// </summary>
        /// <param name="characterId">character id</param>
        /// <exception cref="EveApiException"></exception>
        /// <exception cref="ApiKeyRequiredException"></exception>
        member public x.AssetList() =
            let api = x.Api |> apiCast 
            api.CharAssetList x.CharacterId

        /// <summary>
        /// Returns blueprints list for character. Requires API key.
        /// For detailed explanation of field values go to: https://neweden-dev.com/Char/Blueprints
        /// </summary>
        /// <param name="characterId">character id</param>
        /// <exception cref="EveApiException"></exception>
        /// <exception cref="ApiKeyRequiredException"></exception>
        member public x.Blueprints() =
            let api = x.Api |> apiCast 
            api.CharBlueprints x.CharacterId