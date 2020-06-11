namespace Havarnov.AzureServiceBus

open System
open System.Net
open System.Net.Http
open System.Net.Http.Headers

open Newtonsoft.Json

open Havarnov.AzureServiceBus.Utils
open Havarnov.AzureServiceBus.Error
open Havarnov.AzureServiceBus.ConnectionString
open Havarnov.AzureServiceBus.SharedAccessKey

type BrokerProperties = {
    LockToken: string;
    SequenceNumber: string;
    // LockedUntilUtc: string option;
}

type Message<'Msg> = {
    Data: 'Msg;
    Properties: BrokerProperties;
}

type QueueClient<'Msg>(connectionString: ConnectionString, queueName: string) =
    let sharedAccessKey = SharedAccessKey connectionString

    let mutable client = new HttpClient()
    do client.BaseAddress <- connectionString.Endpoint

    let createRequest (path: string) method =
        async {
            let request = new HttpRequestMessage()

            let! sharedAccessKeyHeader = sharedAccessKey.Get()
            request.Headers.Authorization <-
                AuthenticationHeaderValue(
                    "SharedAccessSignature", sharedAccessKeyHeader)

            request.RequestUri <- Uri(connectionString.Endpoint, path)
            request.Method <- method

            return request
        }

    let makeRequest (path: string) method =
        async {
            let! request = createRequest path method

            return!
                client.SendAsync(request)
                |> Async.AwaitTask
        }

    member this.DeleteMsg lockToken sequenceNumber =
        async {
            let path =
                sprintf "%s/messages/%s/%s"
                    queueName
                    sequenceNumber
                    lockToken

            let! res = makeRequest path HttpMethod.Delete

            return
                match res.StatusCode with
                | HttpStatusCode.OK -> Ok ()
                | HttpStatusCode.Unauthorized-> Error AuthorizationFailure
                | HttpStatusCode.BadRequest-> Error BadRequest
                | HttpStatusCode.NotFound ->
                    Error (NoMessageFound (lockToken, sequenceNumber))
                | HttpStatusCode.Gone -> Error (QueueOrTopicDoesNotExists queueName)
                | HttpStatusCode.InternalServerError -> Error InternalAzureError
                | statusCode ->
                    let body =
                        res.Content.ReadAsStringAsync()
                        |> Async.AwaitTask
                        |> Async.RunSynchronously
                    printfn "error (statusCode: %A): %s" statusCode body
                    Error UnknownError
        }

    member this.Receive() =
        async {
            let path = sprintf "%s/messages/head" queueName
            let! res = makeRequest path HttpMethod.Post

            return!
                match res.StatusCode with
                | HttpStatusCode.Created ->
                    async {
                    // msg data
                    let! body = res.Content.ReadAsStringAsync() |> Async.AwaitTask
                    let msgData = JsonConvert.DeserializeObject<'Msg>(body)

                    // broker properties
                    let propertiesStr =
                        res.Headers.GetValues("BrokerProperties")
                        |> Seq.head
                    printfn "props received: %s" propertiesStr
                    let properties =
                        JsonConvert.DeserializeObject<BrokerProperties>(propertiesStr)

                    return
                        Ok ({
                            Data = msgData;
                            Properties = properties;
                        })
                    }
                | HttpStatusCode.NoContent ->
                    async { return Error NoMessageAvailableInQueue }
                | HttpStatusCode.BadRequest ->
                    async { return Error BadRequest }
                | HttpStatusCode.Unauthorized ->
                    async { return Error AuthorizationFailure }
                | HttpStatusCode.Gone ->
                    async { return Error (QueueOrTopicDoesNotExists queueName) }
                | HttpStatusCode.InternalServerError ->
                    async { return Error InternalAzureError }
                | _ -> async { return Error UnknownError }
        }

    member this.DestructiveReceive() =
        async {
            let path = sprintf "%s/messages/head" queueName
            let! res = makeRequest path HttpMethod.Delete

            return!
                match res.StatusCode with
                | HttpStatusCode.OK ->
                    async {
                        let propertiesStr =
                            res.Headers.GetValues("BrokerProperties")
                            |> Seq.head
                        printfn "props   received: %s" propertiesStr

                        let! body = res.Content.ReadAsStringAsync() |> Async.AwaitTask
                        return Ok (JsonConvert.DeserializeObject<'Msg>(body))
                    }
                | HttpStatusCode.NoContent ->
                    async { return Error NoMessageAvailableInQueue }
                | HttpStatusCode.BadRequest ->
                    async { return Error BadRequest }
                | HttpStatusCode.Unauthorized ->
                    async { return Error AuthorizationFailure }
                | HttpStatusCode.Gone | HttpStatusCode.NotFound ->
                    async { return Error (QueueOrTopicDoesNotExists queueName) }
                | HttpStatusCode.InternalServerError ->
                    async { return Error InternalAzureError }
                | code -> async {
                        printfn "status code received: %A" code
                        return Error UnknownError
                    }
        }

    member this.Post msg =
        this.PostWithBrokerProperties msg None

    member this.PostWithBrokerProperties msg brokerProperties =
        async {

            let! request =
                createRequest
                    (sprintf "%s/messages" queueName)
                    HttpMethod.Post

            let msgBytes = JsonConvert.SerializeObject(msg) |> toBytes
            let content = new ByteArrayContent(msgBytes)
            request.Content <- content

            if Option.isSome brokerProperties then
                let brokerPropertiesJson = JsonConvert.SerializeObject(brokerProperties)
                request.Headers.Add("BrokerProperties", brokerPropertiesJson)

            let! res =
                client.SendAsync(request)
                |> Async.AwaitTask

            return
                match res.StatusCode with
                | HttpStatusCode.Created -> Ok ()
                | HttpStatusCode.BadRequest -> Error BadRequest
                | HttpStatusCode.Unauthorized-> Error AuthorizationFailure
                | HttpStatusCode.Forbidden -> Error QuotaExceededOrMessageTooLarge
                | HttpStatusCode.Gone -> Error (QueueOrTopicDoesNotExists queueName)
                | HttpStatusCode.InternalServerError -> Error InternalAzureError
                | _ -> Error UnknownError
        }