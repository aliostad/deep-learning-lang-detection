namespace EpisodeWebMvc.Controllers

open EpisodeWebMvc
open System
open System.IO
open Microsoft.AspNetCore.Mvc
open Microsoft.Extensions.Options
open Newtonsoft.Json
open Newtonsoft.Json.Linq
open ShowFinder
open EpisodeFinder
open JsonTransformations

[<Route("api/process")>]
type ProcessController(service: JobService) =
    inherit Controller()

    [<HttpGet>]
    member this.Get() =
        match service.CurrentJob with
        |None -> let response = JObject()
                 response.Add("message", JToken.FromObject("no job running"))
                 response
        |Some job -> job.ToJson()

    [<HttpPost>]
    member this.Post(infos: string) =
        let json = JsonConvert.DeserializeObject<JObject[]>(infos)
        let f = json
                |> Seq.map(fun info -> { episodename = info.Value<string>("episodename");
                                        episodenumber = info.Value<int>("episodenumber");
                                        show = info.Value<string>("show");
                                        season = info.Value<int>("season");
                                        file = info.Value<string>("file"); })
        service.RunProcess f

        match service.CurrentJob with
        |Some job -> job.ToJson()
        |_ -> JObject.Parse("{\"error\":\"unable to create job\"}")