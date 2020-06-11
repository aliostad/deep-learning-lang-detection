open HttpClient

let apiKey = "######"
let apiServer = "free.rome2rio.com"

let autocompleteEndpoint = sprintf "http://%s/api/1.2/xml/Autocomplete" apiServer
let completeFor query = 
        createRequest Get autocompleteEndpoint
            |> withQueryStringItem { name = "key"; value = apiKey}
            |> withQueryStringItem { name = "query"; value = query}

[<EntryPoint>]
let main argv = 
    completeFor "Isle of Skye"
        |> getResponseBodyAsync
        |> Async.RunSynchronously
        |> printfn "%s"
    0
