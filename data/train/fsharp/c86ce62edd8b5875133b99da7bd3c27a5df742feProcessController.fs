namespace OtrWeb.Controllers

open JsonHandling
open OtrDecoder
open OtrWeb
open OtrWeb.Options
open Newtonsoft.Json.Linq
open Microsoft.AspNetCore.Mvc
open Microsoft.Extensions.Options
open System.IO

[<Route("api/process")>]
type ProcessController(decodeConfig : IOptions<OtrOptions>, jobService : JobService) =
    inherit Controller()

    let decodeOptions = decodeConfig.Value

    let processEpisode input =
        jobService.ProcessEpisode input decodeOptions
        let response = JObject()
        response.Add("message", JToken.FromObject("job created"))     
        response   

    let processMovie input =
        jobService.ProcessMovie input decodeOptions
        let response = JObject()
        response.Add("message", JToken.FromObject("job created"))
        response

    let unknown = JObject()

    [<HttpGet>]
    member this.Get() =
        match jobService.CurrentJob with
        |Some job -> job.ToJson()
        |_ -> let response = JObject()
              response.Add("message", JToken.FromObject("no job running"))
              response

    [<HttpPost>]
    member this.Post(fileinfo : string) = 
        let input = JObject.Parse(fileinfo);
        match jobService.CurrentJob with
        |Some job when not job.IsDone -> job.ToJson()
        |_ -> let response = match input.Value<string>("type") with
                             |"episode" -> processEpisode input
                             |"movie" -> processMovie input
                             |_ -> unknown
              response