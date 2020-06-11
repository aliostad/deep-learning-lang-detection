namespace DreamhostNet

open System.Net.Http


module Common =

    [<Literal>]
    let DefaultApiEndpoint = "https://api.dreamhost.com/"

    let private http =
        lazy(new HttpClient())

    let private httpGet (http:HttpClient) uri = 
        async {
            let! response = http.GetAsync (System.Uri(uri)) |> Async.AwaitTask
            let! body = response.Content.ReadAsStringAsync () |> Async.AwaitTask
            return body
        }

    let private httpPost (http:HttpClient) uri (kvps:System.Collections.Generic.KeyValuePair<string,string> seq) = 
        async {
            let targetUri = uri |> System.Uri
            use content = new FormUrlEncodedContent (kvps)
            let! response = http.PostAsync (targetUri, content) |> Async.AwaitTask
            let! body = response.Content.ReadAsStringAsync () |> Async.AwaitTask
            return body
        }

    type ResponseFormat = 
        | Json // there are other formats like tab, xml, yaml, html, but not parsing those.
        member x.Name = 
            match x with
            | Json -> "json"

    type ResponseStatus = 
        | Error of Reason:string
        | Success
        | Unknown of StatusCode:string

    type ApiParams = 
        | ApiParams of Key:string * Command:string * UniqueId:string option * Format:ResponseFormat option
    with
        member x.ToQueryParameters () =
            match x with
            | ApiParams (key, cmd, uniqueId, format) ->
                [
                    yield "key", key
                    yield "cmd", cmd
                    if uniqueId.IsSome then yield "unique_id", uniqueId.Value
                    if format.IsSome then yield "format", format.Value.Name
                ] |> Map.ofList<string,string>

    type IParameterizedCommand =
        abstract member ToQueryParameters : unit -> Map<string,string>

    let get<'t when 't :> IParameterizedCommand> (baseUri:string) (apiParams:ApiParams) (commandParams:'t) =
        let uriBuilder = System.UriBuilder (baseUri)
        uriBuilder.Query <- 
            let apiParamMap = apiParams.ToQueryParameters ()
            let cmdParamMap = commandParams.ToQueryParameters ()
            Map.fold (fun acc key value -> Map.add key value acc) apiParamMap cmdParamMap
            |> Seq.map (fun kvp -> sprintf "%s=%s" kvp.Key kvp.Value)
            |> String.concat "&"
        httpGet http.Value uriBuilder.Uri.AbsoluteUri

    let post<'t when 't :> IParameterizedCommand> (baseUri:string) (apiParams:ApiParams) (commandParams:'t) =
        let uriBuilder = System.UriBuilder (baseUri)
        let apiParamMap = apiParams.ToQueryParameters ()
        let cmdParamMap = commandParams.ToQueryParameters ()
        Map.fold (fun acc key value -> Map.add key value acc) apiParamMap cmdParamMap
        |> Seq.map (fun kvp -> System.Collections.Generic.KeyValuePair<_,_>(kvp.Key, kvp.Value))
        |> httpPost http.Value uriBuilder.Uri.AbsoluteUri

