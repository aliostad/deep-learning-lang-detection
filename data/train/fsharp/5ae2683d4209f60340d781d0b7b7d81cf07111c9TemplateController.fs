module AmApi.Api.Template

open System
open Suave
open Suave.Successful
open Suave.RequestErrors

open AmApi
open AmApi.Util
open AmApi.Railway
open AmApi.Commands.Template
open AmApi.Operations.Template
open AmApi.Persistence

let createTemplate executeTemplateCommand template =
    let cmd = TemplateCommand.Create(template)
    let result = executeTemplateCommand cmd

    match result with
    | Failure (err: TemplateCommandError) ->
        Logger.Warn (sprintf "TemplateController.Create error: %A" err)
        match err with
        | DuplicateId -> CONFLICT (sprintf "%A" err)
        | _ -> BAD_REQUEST (sprintf "%A" err)
    | Success _ ->
        CREATED (sprintf Path.Assets.templateById (string template.Id))


let getTemplate getTemplateById (id:Guid) : WebPart =
    match getTemplateById id with
    | Some template -> Common.jsonResponse template
    | None -> NOT_FOUND ""