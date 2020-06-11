namespace TwoPeek.Library

open FSharp.Data

open System
open System.IO
    
// Make one of these to load up an API key and connect.
// We'll look for a file "api.key" in this directory or
// its parents.
type Key private (id: string, db: Db.Connection) =
    let baseReqString = "https://api.guildwars2.com/v2/"
    let authHeaders = ["Authorization", "Bearer " + id]

    member this.Id = id

    member this.GetAccountInfo() =
        // TODO make an agent for doing this :)
        Http.RequestString(baseReqString + "account", headers = authHeaders)

    member this.GetAccountMaterialStorage() =
        Http.RequestString(baseReqString + "account/materials", headers = authHeaders)

    interface IDisposable with
        member this.Dispose() =
            (db :> IDisposable).Dispose()

    static member Open() =
        let db = Db.Connection.Local()
        let apiKeyFilename = "api.key"

        match File.locate apiKeyFilename with
        | true, keyFile ->
            let id =
                File.ReadLines keyFile
                |> Seq.map (fun l -> l.Trim())
                |> Seq.filter (fun l -> l.Length > 0)
                |> Seq.head
        
            new Key (id, db)
        | false, _ -> failwith "No key file found"


