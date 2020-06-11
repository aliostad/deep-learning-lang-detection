namespace XLCatlin.DataLab.XCBRA.Command

// Web/Suave support for Command execution

open GraphQL.Types
open GraphQL
open XLCatlin.DataLab.XCBRA.ReadModelStore
open XLCatlin.DataLab.XCBRA.EventStore
open XLCatlin.DataLab.XCBRA.DomainModel
open XLCatlin.DataLab.XCBRA

// ===========================================
// Suave support
// ===========================================

module WebParts =
    open Suave                 // always open suave
    open Suave.Operators       // for >=>

    let deserializeCommand jsonString =
        try
            let cmd = ApiSerialization.deserialize<ApiCommand>(jsonString)
            cmd |> Ok
        with
        | ex ->
            ApiCommandError.ValidationError ex.Message
            |> Error

    let executeApiCommand (commandService:IApiCommandExecutionService) (cmd:ApiCommand) : AsyncResult<_,_> =
        let convertException (ex:exn) = 
            ApiCommandError.ServerError (ex.Message)

        try
            commandService.Execute(cmd)
            |> AsyncResult.catch convertException 

        with
        | ex ->
            ex |> convertException |> AsyncResult.ofError


    let executeJsonCommand (commandService:IApiCommandExecutionService) jsonString =
        asyncResult {
            let! cmd = 
                deserializeCommand jsonString 
                |> AsyncResult.ofResult

            return! (executeApiCommand commandService cmd)
        }

    let resultToWebPart result =
        result 
        |> function
            | Ok () -> 
                Successful.OK "ok"
            | Error (ApiCommandError.ServerError msg) ->
                ServerErrors.INTERNAL_ERROR msg 
            | Error (ApiCommandError.AuthenticationError msg) ->
                RequestErrors.UNAUTHORIZED msg 
            | Error (ApiCommandError.ValidationError errorList) ->
                RequestErrors.BAD_REQUEST (sprintf "%A" errorList) //TODO replace with JSON
            | Error (ApiCommandError.ExecutionError msg) ->
                RequestErrors.BAD_REQUEST msg //TODO replace with 412

    let executeCommand commandService :WebPart = 
        warbler (fun httpContext ->

            let result = 
                httpContext.request.rawForm 
                |> System.Text.Encoding.UTF8.GetString
                |> executeJsonCommand commandService
                |> Async.RunSynchronously //TODO: Support async

            // choose a webpart based on the result
            result |> resultToWebPart 
            )

