module Backlog.Client.Net

open FSharp.Data
open Newtonsoft.Json

let apiKey = "Pn7NlD0KcnXU1E4YkkWtDlxxNFVRmPIH0Okl0ZnyofOeDbmqCnMesNryvXjBETfP"

type RequestType = Get | Post | Patch | Delete

let HttpGet url =
    Http.Request (url, query = ["apiKey", apiKey], httpMethod = HttpMethod.Get)

let HttpPost url data =
    Http.Request (url, query = ["apiKey", apiKey], httpMethod = HttpMethod.Post, body = HttpRequestBody.FormValues(data))

let HttpPatch url data =
    Http.Request(url, query = ["apiKey", apiKey], httpMethod = HttpMethod.Patch, body = HttpRequestBody.FormValues(data))

let HttpDelete url =
    Http.Request(url, query = ["apiKey", apiKey], httpMethod = HttpMethod.Delete)

let HttpBodyToEntity<'T>(body : HttpResponseBody) : Option<'T> = 
    match body with 
    | Text t -> Some ( JsonConvert.DeserializeObject<'T>(t) )
    | _ -> None
