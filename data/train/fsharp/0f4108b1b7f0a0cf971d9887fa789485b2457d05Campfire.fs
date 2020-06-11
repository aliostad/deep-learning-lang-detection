module Campfire
open System.Net

type Body = {body:string}
type Message = {message:Body}

let private createWebClient room api =
    let client = new WebClient()
    client.Credentials <-  NetworkCredential(api, "X") :> ICredentials
    client.Headers.Add("Content-Type", "application/json")
    client

let publishMessage room api message = 
    use client = createWebClient room api
    client.UploadString(room.ToString(), message.ToString())

let postMessage room api messages =     
    messages 
    |> Seq.map (fun m -> {message={body=m}}) 
    |> Seq.map (fun m -> Newtonsoft.Json.JsonConvert.SerializeObject m)
    |> Seq.iter (fun x -> publishMessage room api x |> ignore)