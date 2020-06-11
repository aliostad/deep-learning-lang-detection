namespace XLCatlin.DataLab.XCBRA.Query

/// Main entry point for handling domain commands.
/// ICommandService from DomainModel is implemented at the bottom of the file.

open XLCatlin.DataLab.XCBRA

open Savanna
open Savanna.Utilities
open Savanna.Domain
open XLCatlin.DataLab.XCBRA.EventStore
open XLCatlin.DataLab.XCBRA.ReadModelStore
open XLCatlin.DataLab.XCBRA.DomainModel


type ApiQueryService (readModelStore:IReadModelStore) =

    /// Convert a DomainCommandError into a ApiCommandError
    let toApiQueryError (e:ReadModelError) =
        let msg = sprintf "%A" e   // convert to string for now
        ApiQueryError.QueryError msg 

    let toApiQueryResult result = 
        result 
        |> Result.mapError toApiQueryError // map the error to different type

    interface IApiQueryService with
        member this.AllLocations(listQuery) = 
            readModelStore.GetLocations(listQuery.filter,listQuery.paging)
            |> toApiQueryResult 
            |> async.Return  //TODO Async not implemented yet

        member this.LocationById(idQuery) =
            readModelStore.GetLocationById(idQuery.id)
            |> toApiQueryResult 
            |> async.Return  //TODO Async not implemented yet

        member this.BuildingsAtLocation(listQuery) =
            readModelStore.GetBuildingsAtLocation(listQuery.filter,listQuery.paging)
            |> toApiQueryResult 
            |> async.Return  //TODO Async not implemented yet

        member this.WarehouseById(idQuery)=
            readModelStore.GetWarehouseById(idQuery.id)
            |> toApiQueryResult 
            |> async.Return  //TODO Async not implemented yet
        




