module FsdnApi

open System
open System.IO
open System.Net.Http
open Newtonsoft.Json

type Request = { signature: string }
type Response = { url: string; clazz: string; method: string }

type JsonName = { class_name: string; id: string; ``namespace``: string }
type JsonApi = { link: string; name: JsonName }
type JsonValues = { api: JsonApi }
type JsonRespones = { values: JsonValues[] }

let private baseUrl = "http://fsdn.azurewebsites.net/api/search?exclusion=Argu%2BNewtonsoft.Json%2BFAKE.Lib%2BFParsec%2BFSharp.Compiler.Service%2BFSharp.Collections.ParallelSeq%2BFSharp.Control.AsyncSeq%2BFSharp.Control.Reactive%2BFSharp.Data%2BFSharp.ViewModule.Core%2BFsPickler%2BFsUnit%2BSuave%2BSuave.Experimental%2BSystem.Reactive.Core%2BSystem.Reactive.Interfaces%2BSystem.Reactive.Linq%2BSystem.ValueTuple&respect_name_difference=enabled&greedy_matching=disabled&ignore_parameter_style=enabled&ignore_case=enabled&swap_order=enabled&complement=enabled&limit=10&language=fsharp&single_letter_as_variable=enabled&query="

let execute (req: Request) = async {
    use client = new HttpClient()
    use msg = new HttpRequestMessage()

    msg.RequestUri <- Uri(baseUrl + Uri.EscapeDataString(req.signature))
    msg.Headers.Accept.ParseAdd "application/json, text/plain, */*"
    msg.Headers.Referrer <- Uri "http://fsdn.azurewebsites.net/"
    msg.Headers.UserAgent.ParseAdd "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36"

    let! resp = client.SendAsync msg |> Async.AwaitTask
    let! json = resp.Content.ReadAsStringAsync () |> Async.AwaitTask

    return match resp.StatusCode with
           | Net.HttpStatusCode.BadRequest -> Error json
           | _ -> 
               use reader = new JsonTextReader(new StringReader(json))
               let xs = JsonSerializer().Deserialize<JsonRespones>(reader)
               xs.values |> Array.toList 
                         |> List.map (fun x -> { url = x.api.link
                                                 clazz = x.api.name.``namespace`` + "." + x.api.name.class_name
                                                 method = x.api.name.id })
                         |> Ok
}