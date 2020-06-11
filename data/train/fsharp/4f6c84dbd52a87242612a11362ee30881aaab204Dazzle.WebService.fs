namespace XLCatlin.DataLab.XCBRA.Dazzle

// Web/Suave support for DazzleCalculations

open XLCatlin.DataLab.XCBRA.ReadModelStore
open XLCatlin.DataLab.XCBRA.DomainModel
open XLCatlin.DataLab.XCBRA.Dazzle
open XLCatlin.DataLab.XCBRA
open WebUtilities

// ===========================================
// Suave support
// ===========================================

module WebParts =
    open Suave                 // always open suave
    open Suave.Operators       // for >=>

    let deserializeStartCommand jsonString =
        try
            let cmd = ApiSerialization.deserialize<DazzleStartCommand>(jsonString)
            cmd |> Ok
        with
        | ex ->
            DazzleError.ValidationError ex.Message
            |> Error

    let asyncCatch asyncValue = 
        asyncValue 
        |> Async.Catch
        |> Async.map (fun choice ->
            match choice with
            | Choice1Of2 success -> success 
            | Choice2Of2 ex -> Error <| DazzleError.ServerError (ex.Message)
            )

    let runHandler handler =
        try
            handler()
            |> AsyncResult.map ApiSerialization.serialize
            |> asyncCatch
            |> Async.RunSynchronously //TODO: Support async
        with
        | ex ->
            DazzleError.ServerError (ex.Message)
            |> Error

    let resultToWebPart result =
        result 
        |> function
            | Ok str -> 
                Successful.OK str
            | Error (DazzleError.ServerError msg) ->
                ServerErrors.INTERNAL_ERROR msg 
            | Error (DazzleError.AuthenticationError msg) ->
                RequestErrors.UNAUTHORIZED msg 
            | Error (DazzleError.ValidationError errorList) ->
                RequestErrors.BAD_REQUEST (sprintf "%A" errorList) //TODO replace with JSON
            | Error (DazzleError.DazzleError msg) ->
                RequestErrors.BAD_REQUEST msg //TODO replace with 412


    // Start a calculation
    let start (dazzleService:IApiDazzleService) : WebPart =
        warbler (fun httpContext ->
            result {
                let! cmd =
                    httpContext.request.rawForm 
                    |> System.Text.Encoding.UTF8.GetString
                    |> deserializeStartCommand 
                let handler() = dazzleService.Start cmd 
                let! result = runHandler handler
                return result
            } |> resultToWebPart 
            )

    // get the status of a calculation
    let getStatus (dazzleService:IApiDazzleService) calculationId : WebPart =
        warbler (fun _ ->
            let handler() = dazzleService.Status(DazzleCalculationId calculationId)
            let result = runHandler handler
            result |> resultToWebPart 
            )


    