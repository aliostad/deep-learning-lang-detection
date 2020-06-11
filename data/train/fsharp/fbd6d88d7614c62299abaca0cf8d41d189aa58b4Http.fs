namespace Dale

module Http =
  open System
  open System.Net.Http
  open FSharp.Data
  open FSharp.Data.HttpRequestHeaders
  open Dale.Storage

  type Handler = HttpRequestMessage -> HttpResponseMessage
  exception ExportException of string

  let collectBatches(req :HttpRequestMessage) =
    let body = req.Content.ReadAsStringAsync().Result
    let json = JsonValue.Parse body
    json.AsArray()
    |> Array.map (fun i ->
                   {Uri = i.GetProperty("contentUri").AsString();
                    Ttl = i.GetProperty("contentExpiration").AsDateTime()})

  let getRespText body =
      match body with
      | Text t -> t
      | _ -> ""

  let fetchAuthToken tenant clientId clientSecret =
    let url = "https://login.microsoftonline.com/" + tenant + "/oauth2/token"
    let resp =
      Http.Request(url, 
                   headers=[Accept "application/json"],
                   body=FormValues ["grant_type", "client_credentials";
                                    "client_id", clientId;
                                    "client_secret", clientSecret;
                                    "resource", "https://manage.office.com"])
    
    let json = JsonValue.Parse (getRespText resp.Body)
    match resp.StatusCode with
    | 200 -> Some (json.GetProperty("access_token").AsString())
    | _ -> None

  let fetchBatch oauthToken url =
    let resp =
      Http.Request(url, httpMethod = "GET",
                   headers = [Authorization ("Bearer " + oauthToken);
                              Accept "application/json"])
    match resp.StatusCode with
    | 200 -> Some ({Json=JsonValue.Parse (getRespText resp.Body);
                    ContentUri=url})
    | _ -> None

  let mapToAuditWrites (json) =

    let prop2string (j :Option<JsonValue>) =
      match j with
      | Some v -> v.AsString()
      | None -> ""

    let toAuditWrite (e :JsonValue) =
      let dt = e.GetProperty("CreationTime").AsString().Split [|'T'|]
      { UserId = e.GetProperty("UserId").ToString();
        AuditEvent =
         { ServiceType = prop2string (e.TryGetProperty("Workload"));
           Id = prop2string (e.TryGetProperty("Id"));
           Date = Seq.head dt;
           Time = Seq.last dt;
           ObjectId = prop2string (e.TryGetProperty("ObjectId"));
           Operation = prop2string (e.TryGetProperty("Operation"));
           Status = prop2string (e.TryGetProperty("ResultStatus"));
           Json = e.ToString() }}

    match json with
    | None -> None
    | Some (j :JsonValue) -> Some (j.AsArray() |> Array.map toAuditWrite)
