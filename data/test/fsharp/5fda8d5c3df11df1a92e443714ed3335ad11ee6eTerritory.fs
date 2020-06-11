namespace Route4MeSdk.FSharp

open System
open System.Collections.Generic
open FSharpExt
open FSharp.Data
open Newtonsoft.Json
open Newtonsoft.Json.Linq

[<CLIMutable>]
type TerritoryParameters = {
    [<JsonProperty("type")>]
    Type : string
    
    [<JsonProperty("data")>]
    Data : string[]
}

[<CLIMutable>]
type Territory = {
    [<JsonProperty("territory_id")>]
    Id : string

    [<JsonProperty("member_id")>]
    MemberId : int option

    [<JsonProperty("territory_name")>]
    Name : string

    [<JsonProperty("territory_color")>]
    Color : string

    [<JsonProperty("addresses")>]
    Addresses : string[]
    
    [<JsonProperty("territory")>]
    Parameters : TerritoryParameters }

    with
        static member Get(?take:int, ?skip:int, ?apiKey) =
            let query = 
                [ take |> Option.map(fun v -> "limit", v.ToString())
                  skip |> Option.map(fun v -> "offset", v.ToString()) ]
                |> List.choose id

            Api.Get(Url.V4.territory, [], query, apiKey)
            |> Result.map Api.Deserialize<Territory[]>

        static member Get(id, ?apiKey) =
            let query = [("territory_id", id)]

            Api.Get(Url.V4.territory, [], query, apiKey)
            |> Result.map Api.Deserialize<Territory>

        static member Add(name:string, color:string, parameters:TerritoryParameters, ?apiKey) =
            let request = 
                [("territory_name", box name)
                 ("territory_color", box color)
                 ("territory", box parameters)]
                |> dict

            Api.Post(Url.V4.territory, [], [], apiKey, request)
            |> Result.map Api.Deserialize<Territory>

        static member Update(territory:Territory, ?apiKey) =
            territory.Id
            |> Option.ofObj
            |> Result.ofOption(ValidationError("Territory Id must be supplied."))
            |> Result.andThen(fun id ->
                Api.Post(Url.V4.territory, [], [], apiKey, territory)
                |> Result.map Api.Deserialize<Territory>)

        member self.Update(?apiKey) =
            match apiKey with
            | None -> Territory.Update(self)
            | Some v -> Territory.Update(self, v)

        static member Delete(territory:Territory, ?apiKey) =
            territory.Id
            |> Option.ofObj
            |> Result.ofOption(ValidationError("Territory Id must be supplied."))
            |> Result.andThen(fun id ->
                let query = [("territory_id", id)]
                Api.Delete(Url.V4.territory, [], query, apiKey))

        member self.Delete(?apiKey) =
            match apiKey with
            | None -> Territory.Delete(self)
            | Some v -> Territory.Delete(self, v)
