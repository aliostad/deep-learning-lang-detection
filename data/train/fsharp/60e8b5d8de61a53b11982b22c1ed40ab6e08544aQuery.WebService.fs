namespace XLCatlin.DataLab.XCBRA.Query

// Web/Suave support for Queries 

open XLCatlin.DataLab.XCBRA.ReadModelStore
open XLCatlin.DataLab.XCBRA.EventStore
open XLCatlin.DataLab.XCBRA.DomainModel
open XLCatlin.DataLab.XCBRA
open WebUtilities

// ===========================================
// Suave support
// ===========================================

module WebParts =
    open Suave                 // always open suave
    open Suave.Operators       // for >=>


    let asyncCatch asyncValue = 
        asyncValue 
        |> Async.Catch
        |> Async.map (fun choice ->
            match choice with
            | Choice1Of2 success -> success 
            | Choice2Of2 ex -> Error <| ApiQueryError.ServerError (ex.Message)
            )

    let runHandler handler =
        try
            handler()
            |> AsyncResult.map ApiSerialization.serialize
            |> asyncCatch
            |> Async.RunSynchronously //TODO: Support async
        with
        | ex ->
            ApiQueryError.ServerError (ex.Message)
            |> Error

    let resultToWebPart result =
        result 
        |> function
            | Ok str -> 
                Successful.OK str
            | Error (ApiQueryError.ServerError msg) ->
                ServerErrors.INTERNAL_ERROR msg 
            | Error (ApiQueryError.AuthenticationError msg) ->
                RequestErrors.UNAUTHORIZED msg 
            | Error (ApiQueryError.ValidationError errorList) ->
                RequestErrors.BAD_REQUEST (sprintf "%A" errorList) //TODO replace with JSON
            | Error (ApiQueryError.QueryError msg) ->
                RequestErrors.BAD_REQUEST msg //TODO replace with 412

    let tryGetIntParam r key =
        tryGetParam r key
        |> Option.bind (fun s -> 
            System.Int32.TryParse(s) 
            |> function
                | true,v -> Some v
                | false,_ -> None
            )

    let paging =
        request (fun r _ ->
            let offset = tryGetIntParam r "offset" |> ifNone 0
            let fetchNext  = tryGetIntParam r "fetchNext" |> ifNone 1000
            let paging = {
                ApiPaging.offset = offset 
                fetchNext = fetchNext  
                }
            paging 
            )

    let locationsFilter =
        request (fun _ _ ->
            //let name = tryGetParam r "Name"
            //let postalCountry = tryGetParam r "PostalCountry"
            let filter = 
                    { country = [] 
                    ; searchString = None 
                    ; searchArea  = None
                    ; ownership = [] 
                    ; occupancy  = []
                    ; totalArea = Range.empty
                    ; totalInsuredValue = (Currency.usd, Range.empty)
                    ; siteCondition = []
                    ; plantLayout = []
                    ; lastSurveyDate = None
                    ; favouritesOnly = false
                    }
            filter
            )

    let buildingsFilter id =
        request (fun _ _ ->
            //let name = tryGetParam r "Name"
            //let buildingType = tryGetParam r "BuildingType"
            //let filter = {
                //BuildingFilter.LocationId = LocationId id
                //BuildingFilter.Name = name
                //BuildingFilter.BuildingType = buildingType
                //}
            { locationId = id ; name = None ; occupancy = []}
            )

    let queryAllLocations (queryService:IApiQueryService) :WebPart =
        warbler (fun httpContext ->
            let filter = locationsFilter httpContext 
            let paging = paging httpContext 
            let query = {filter=filter; paging=paging}
            let handler() = queryService.AllLocations(query)
            let result = runHandler handler
            // choose a webpart based on the result
            result |> resultToWebPart 
            )

    let queryLocationById (queryService:IApiQueryService) locationId : WebPart =
        warbler (fun _ ->
            let query = {ApiIdQuery.id=LocationId locationId}
            let handler() = queryService.LocationById(query)
            let result = runHandler handler
            result |> resultToWebPart 
            )


    let queryBuildingsAtLocation (queryService:IApiQueryService) locationId :WebPart =
        warbler (fun httpContext ->
            let filter = buildingsFilter (Some locationId) httpContext 
            let paging = paging httpContext 
            let query = {filter=filter; paging=paging}
            let handler() = queryService.BuildingsAtLocation(query)
            let result = runHandler handler
            result |> resultToWebPart 
            )

    let queryWarehouseById (queryService:IApiQueryService) warehouseId : WebPart =
        warbler (fun _ ->
            let query = {ApiIdQuery.id=BuildingId warehouseId}
            let handler() = queryService.WarehouseById(query)
            let result = runHandler handler
            result |> resultToWebPart 
            )
