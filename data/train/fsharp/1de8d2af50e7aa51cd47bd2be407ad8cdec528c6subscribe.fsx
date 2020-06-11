#I "./packages/FSharp.Data/lib/portable-net45+netcore45/"
#r "FSharp.Data.dll"
#r "FSharp.Data.DesignTime.dll"

open System
open FSharp.Data
open FSharp.Data.HttpRequestHeaders

// Your values here ------------------------------------------------------------
let tenant = ""
let tenantId = ""
let clientId = ""
let clientSecret = ""
let webHookUrl = ""
let authId = clientId
// -----------------------------------------------------------------------------

let fetchAuthToken =
  let url = "https://login.microsoftonline.com/" + tenant + "/oauth2/token"
  let json =
    Http.RequestString(url, 
                       headers=[Accept "application/json"],
                       body=FormValues ["grant_type", "client_credentials";
                                         "client_id", clientId;
                                         "client_secret", clientSecret;
                                         "resource", "https://manage.office.com"])
  let res = JsonValue.Parse json
  res.GetProperty("access_token").AsString()

printfn "%s" "Begin subscription..."

let token = "Bearer " + fetchAuthToken

let subscribe contentType =
  let url = "https://manage.office.com/api/v1.0/" + tenantId +
            "/activity/feed/subscriptions/start"
  let reqbody =
   "{'webhook': {"  +
      "'address': '" + webHookUrl + "', " +
      "'authId': '" + authId + "', " +
      "'expiration': ''" +
      "}}"

  printfn "%s %s %s" "Sending Subscription Request for" contentType "..."
  let resp =
    Http.Request(url,
                 headers = [Accept "application/json"; 
                            Authorization token;
                            ContentType HttpContentTypes.Json],
                 query = ["contentType", contentType],
                 body = TextRequest reqbody)
  printfn "%s %A" "Response Status:" resp.StatusCode

subscribe "Audit.SharePoint"
subscribe "Audit.Exchange"
subscribe "Audit.AzureActiveDirectory"
subscribe "Audit.General"
printfn "%s" "Subscription completed."
