namespace EveLib

open System
open System.Xml
open System.Xml.Linq
open EveLib
open EveLib.FSharp
open ClientUtils

type EveClient (apiKey:ApiKey) =

    let apiValues = [ ("keyID", string apiKey.Id); ("vCode", apiKey.VCode) ]
    let character = lazy( CharacterQueries(apiValues) )
    let corporation = lazy( CorporationQueries(apiValues) )
    let eve = lazy( EveQueries(apiValues) )
    let map = lazy( MapQueries(apiValues) )
        
    let getCharacters () = async {
        let! response = getResponse "/account/Characters.xml.aspx" apiValues
        let rowset = RowSet(response.Result.Element(xn "rowset"))
        return { 
            Id = apiKey.Id;
            QueryTime = response.QueryTime;
            CachedUntil = response.CachedUntil;
            Characters =
                rowset.Rows 
                |> Seq.map (fun r -> { Id = xval r?characterID; 
                                       Name = xval r?name; 
                                       CorpId = xval r?corporationID; 
                                       CorpName = xval r?corporationName })
                |> Seq.cache
        }
    }

    let getServerStatus () = async {
        let! response = getResponse "/server/ServerStatus.xml.aspx" []
        return { ServerOpen = response.Result.Element(xn "serverOpen") |> xval;
                 OnlinePlayers = response.Result.Element(xn "onlinePlayers") |> xval;
                 QueryTime = response.QueryTime;
                 CachedUntil = response.CachedUntil }
    }

    interface EveLib.FSharp.IEveClient with
        member x.GetCharacters() = getCharacters()
        member x.GetServerStatus() = getServerStatus()
        member x.Character = upcast character.Value
        member x.Corporation = upcast corporation.Value
        member x.Eve = upcast eve.Value
        member x.Map = upcast map.Value

    interface EveLib.Async.IEveClient with
        member x.GetCharacters() = getCharacters() |> Async.StartAsTask
        member x.GetServerStatus() = getServerStatus() |> Async.StartAsTask
        member x.Character = upcast character.Value
        member x.Corporation = upcast corporation.Value
        member x.Eve = upcast eve.Value
        member x.Map = upcast map.Value

    static member CreateFSharp apiKey = EveClient(apiKey) :> EveLib.FSharp.IEveClient
    static member CreateAsync apiKey = EveClient(apiKey) :> EveLib.Async.IEveClient


