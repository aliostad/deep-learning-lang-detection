namespace AntichessCheatDetection.Controllers

open Microsoft.AspNetCore.Mvc
open Microsoft.AspNetCore.Mvc.Filters

open AntichessCheatDetection.Modules.Api
open AntichessCheatDetection.Modules.Investigate

open System.Collections.Generic

open Newtonsoft.Json

type ApiController(apiKeyDbRepo: IApiKeyDbRepo, queueDbRepo: IQueueDbRepo, investigateDbRepo: IInvestigateDbRepo) =
    inherit Controller()

    override this.OnActionExecuting (context : ActionExecutingContext) =
        match context.HttpContext.Request.Method.ToUpperInvariant() with
        | "POST" ->
            let ok, apiKeyO = context.ActionArguments.TryGetValue("key")
            let apiKey = string apiKeyO
            match ok && apiKeyDbRepo.IsValidKey(apiKey) with
            | true ->
                base.OnActionExecuting(context)
            | _ ->
                context.Result <- this.BadRequest() :> IActionResult
        | _ ->
            context.Result <- this.BadRequest() :> IActionResult
    
    [<Route("/Api/QueueNext")>]
    member this.Queue(key: string) =
        let nextQueueItem = queueDbRepo.GetNextQueueItem()
        this.Content(if isNull nextQueueItem then "" else nextQueueItem.Name)
    
    [<Route("/Api/QueueItemInProgress")>]
    member this.QueueItemInProgress(key: string, playerName: string) =
        match queueDbRepo.SetInProgress(playerName.ToLowerInvariant()) with
        | true -> StatusCodeResult(200)
        | _ -> StatusCodeResult(500)
    
    [<Route("/Api/PlayerGamesProcessed")>]
    member this.PlayerGamesProcessed(key: string, playerName: string, games: string) =
        let investigations = JsonConvert.DeserializeObject<IEnumerable<Investigation>>(games, UnixDateTimeConverter())
        investigateDbRepo.InsertInvestigations investigations
        match queueDbRepo.SetAsProcessed(playerName.ToLowerInvariant()) with
        | true -> StatusCodeResult(200)
        | _ -> StatusCodeResult(500)