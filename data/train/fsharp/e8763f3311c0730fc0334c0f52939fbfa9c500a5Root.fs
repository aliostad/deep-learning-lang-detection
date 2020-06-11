namespace Dale

open Http
open Storage
open Middleware
open JsonRedactor
open System.Net.Http
open System.Net

type Exporter(configuration :Dale.Configuration) =

  let fullRedact =
   redactJson fullRedaction configuration.RedactedFields

  let partialRedact =
   redactJson partialRedaction configuration.PartiallyRedactedFields

  let account = fetchAccount configuration.AzureConnectionString

  let queue = Storage.fetchAuditQueue account configuration.AzureQueueName

  let dump = dumpBlob account

  let writeToTable = writeToAzureTable account

  let filterContent content =
    match content with
    | Some c -> Some { ContentUri = c.ContentUri;
                       Json = (fullRedact >> partialRedact) c.Json }
    | None -> None

  let fetchAuthToken' =
    fetchAuthToken configuration.Tenant configuration.ClientId configuration.ClientSecret

  let doExport (batch :string) =
    let token = fetchAuthToken'

    let fetchBatchWithToken = fun (batch :string) ->
      match token with
      | Some t -> (fetchBatch t batch)
      | None -> None

    batch
    |> fetchBatchWithToken
    |> filterContent
    |> dump
    |> mapToAuditWrites
    |> writeToTable

  let queueBatches (req :HttpRequestMessage) =
    let batches = collectBatches req
    queueContentToAzure queue batches

  let auditHandler (req :HttpRequestMessage) :HttpResponseMessage =
    let res = queueBatches req
    new HttpResponseMessage(HttpStatusCode.OK)

  let wrappedAuditHandler :Handler =
    auditHandler
    |> isWellFormed
    |> isValidation
    |> methodAllowed

  member this.ExportWithException batch =
    let res = doExport batch
    match res with
    | Some r -> (r |> Array.map(sprintf "%A"))
    | None -> raise (ExportException("Unable to persist Audit Events."))

  member this.Handler = wrappedAuditHandler

  member this.AsyncHandler =
   (fun req ->
             async { return wrappedAuditHandler req })

  member this.Handle req =
    wrappedAuditHandler req
