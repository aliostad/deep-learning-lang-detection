namespace NBlast.Api.Controllers

open System
open System.Web.Http
open System.Net.Http.Formatting
open NBlast.Storage.Core.Index
open NBlast.Storage.Core
open NBlast.Api.Async
open NBlast.Api.Models
open NBlast.Storage.Core.Extensions
open System.Web.Http.Cors


[<RoutePrefix("api/queue")>]
[<EnableCors("*", "*", "GET")>]
type QueueController(indexingQueuekeeper: IIndexingQueueKeeper) = 
    inherit ApiController()

    [<HttpGet>]
    [<Route("{amount}/top")>]
    member me.Top (amount) = {
        Logs = indexingQueuekeeper.PeekTop amount; 
        Total = indexingQueuekeeper.Count()
    }

