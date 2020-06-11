namespace EdmundsNet

module Requests =
    open System
    open System.Net
    open System.Web
    open System.Json
    open Fleece

    let newHttpRequest (uri: Uri) =
        WebRequest.Create uri :?> HttpWebRequest

    let private baseEndpoint = "https://api.edmunds.com/api/vehicle/v2"
    // https://api.edmunds.com/api/vehicle/v2/vins/2G1FC3D33C9165616?fmt=json&api_key=

    let buildUrl service apiKey = 
        let qs = HttpUtility.ParseQueryString ""
        qs.["api_key"] <- apiKey
        qs.["fmt"] <- "json"
        let url = baseEndpoint + service + "?" + qs.ToString()
        Uri url

    let inline doRequest service apiKey =
        async {
            let request = newHttpRequest (buildUrl service apiKey)
            try
                use! response = request.AsyncGetResponse()
                use responseStream = response.GetResponseStream()
                let json = JsonValue.Load responseStream
                return fromJSON json
            with 
            | :? WebException as e -> 
                return Choice2Of2 (e.Status.ToString())
            | e -> 
                return Choice2Of2 (e.ToString())
        }
