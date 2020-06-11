module webshenanigans.WebCalls

open FSharp.Data

open webshenanigans.Domain
open webshenanigans.Railway
open webshenanigans.Types

let pingUri = Setting.ApiRootOntologyTypeahead.ToString() |> sprintf "%sadmin/ping"

let accessorsUri = Setting.ApiRootOntologyTypeahead.ToString() |> sprintf "%slookup/accessors/all"

let queryUri a q = Setting.ApiRootOntologyTypeahead.ToString()
                   |> fun x -> sprintf "%slookup/%s/?query=%s" x a q 

let getSyncResponse uri =
    try
        Http.RequestString(uri)
        |> Success
    with
        | ex -> ex |> WebCallFailureException |> Failure

let parseApiResponse f x =
  try
    x
    |> ApiResponse.Parse
    |> function x -> x.Response.Data |> Array.toSeq
                                     |> Seq.map (function x -> f x.Id x.Label)
    |> Success
  with
  | ex -> ex |> ParseWebResponseException |> Failure

let parsePingResponse x =
  try
    x
    |> ApiPingResponse.Parse
    |> function x -> match x.Response.Status with
                     | "OK" -> Success ()
                     | _ -> sprintf "%s: %s" x.Response.Status x.Response.Message
                            |> WebCallFailure
                            |> Failure
  with
  | ex -> ex |> ParseWebResponseException |> Failure
 
let webcall f =
  getSyncResponse
  >=> parseApiResponse f

let pingCall =
  getSyncResponse
  >=> parsePingResponse

let pingApi =
  pingUri
  |> pingCall 

let getAccessors =
  accessorsUri
  |> webcall Ontology.from

let getValues (a:string) (q:string) =
  queryUri a q
  |> webcall OntologyItem.from