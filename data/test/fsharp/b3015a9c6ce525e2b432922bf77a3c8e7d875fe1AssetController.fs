module AmApi.Api.Asset

open System
open Suave
open Suave.Successful
open Suave.RequestErrors

open AmApi
open AmApi.Util
open AmApi.Railway
open AmApi.Commands.Asset
open AmApi.Operations.Asset
open AmApi.Persistence

let private saveAsset executeAssetCommand cmd onSuccess =
    let result = executeAssetCommand cmd
    match result with
    | Failure (err: AssetCommandError) ->
        Logger.Warn (sprintf "AssetController.Create error: %A" err)
        match err with
        | DuplicateId -> CONFLICT (sprintf "%A" err)
        | NotFound -> NOT_FOUND ""
        | _ -> BAD_REQUEST (sprintf "%A" err)
    | Success _ -> onSuccess

let createAsset executeAssetCommand (asset:DomainTypes.Asset) =
    saveAsset executeAssetCommand (AssetCommand.Create(asset)) 
    <| CREATED (sprintf Path.Assets.assetById (string asset.Id))

let updateAsset executeAssetCommand (asset:DomainTypes.Asset) (id:Guid) =
    if asset.Id <> id then 
        (BAD_REQUEST "Url parameter and asset id must match")
    else
        saveAsset executeAssetCommand (AssetCommand.Update(asset)) 
        <| OK ""

let getAsset getAssetById (id:Guid) =
    match getAssetById id with
    | Some asset -> Common.jsonResponse asset
    | None -> NOT_FOUND ""