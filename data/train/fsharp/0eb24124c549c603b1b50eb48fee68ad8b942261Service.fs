namespace EdmundsNet

open EdmundsNet.Requests
open EdmundsNet.Vehicles
open Fleece
open System.Runtime.CompilerServices

[<Extension>]
type ServiceUtils =
    [<Extension>]
    static member GetOrThrow(x: _ ParseResult Async) =
        match Async.RunSynchronously x with
        | Choice1Of2 a -> a
        | Choice2Of2 e -> failwith e

type Service(apiKey: string) =
    member x.AsyncLookupByVIN(vin: string) : VINLookupResponse ParseResult Async =
        let service = "/vins/" + vin
        doRequest service apiKey

    member x.AsyncGetEquipmentByStyle(styleID: int) : Equipments ParseResult Async =
        let service = sprintf "/styles/%d/equipment" styleID
        doRequest service apiKey