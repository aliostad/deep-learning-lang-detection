module WebHost

open Sunergeo.Core
open System.Threading.Tasks
open Microsoft.AspNetCore.Hosting
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Http
open Sunergeo.Logging
open Microsoft.Extensions.DependencyInjection

type HttpStatusCode = int

let toJsonBytes
    (o: obj)
    : byte[] =
    let jsonResult:string = Sunergeo.Core.Todo.todo()
    jsonResult |> System.Text.Encoding.UTF8.GetBytes
    

let writeValueToHttpResponse
    (value: 'a)
    (response: HttpResponse)
    :unit =
    let valueAsJson = value |> toJsonBytes
    response.ContentType <- "application/json"
    response.Body.Write(valueAsJson, 0, valueAsJson.Length)


let setHttpResponseStatusCodeForError
    (error: Error)
    (response: HttpResponse)
    :unit =
    match error.Status with
    | ErrorStatus.InvalidOp ->
        response.StatusCode <- StatusCodes.Status400BadRequest
                        
    | ErrorStatus.PermissionDenied ->
        response.StatusCode <- StatusCodes.Status401Unauthorized

    | ErrorStatus.Unknown ->
        response.StatusCode <- StatusCodes.Status500InternalServerError


let appendOkResultToHttpResponse
    (value: 'a option)
    (response: HttpResponse)
    :unit =
    match value with
    | None ->
        response.StatusCode <- StatusCodes.Status204NoContent
    | Some x ->
        response.StatusCode <- StatusCodes.Status200OK
        response |> writeValueToHttpResponse x

        
let runHandler<'Result>
    (handler: (unit -> Async<Result<'Result, Error>>) option)
    (okHandler: 'Result -> (obj * HttpStatusCode) option)
    (writeToLog: LogLevel -> string -> unit)
    (response: HttpResponse)
    : Async<unit> = 
              
    async {
        match handler with
        | Some handler ->
            let! handlerResult = handler ()

            match handlerResult with
            | Result.Ok value ->
                response |> appendOkResultToHttpResponse (value |> okHandler)

                sprintf "%i" response.StatusCode
                |> writeToLog LogLevel.Information

            | Result.Error error ->
                response |> setHttpResponseStatusCodeForError error
                response |> writeValueToHttpResponse error.Message
                
                sprintf "%i: %s" response.StatusCode error.Message
                |> writeToLog LogLevel.Warning

        | None ->
            response.StatusCode <- StatusCodes.Status404NotFound

            sprintf "%i" response.StatusCode
            |> writeToLog LogLevel.Error
    }