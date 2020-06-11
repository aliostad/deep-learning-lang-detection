module Havarnov.AzureServiceBus.CSharpWrapper

open System

open Havarnov.AzureServiceBus
open Havarnov.AzureServiceBus.Utils
open Havarnov.AzureServiceBus.Error
open Havarnov.AzureServiceBus.ConnectionString

type AzureServiceBusException (message:string, ?innerException:exn) =

    inherit Exception (message,
        match innerException with | Some(ex) -> ex | _ -> null)

module Helper =
    let handleError err =
        match err with
        | NoMessageAvailableInQueue -> null
        | AuthorizationFailure -> raise (AzureServiceBusException "Authorization failure")
        | UnknownError -> raise (AzureServiceBusException "Unknown error")
        | QueueOrTopicDoesNotExists name ->
            raise (AzureServiceBusException
                (sprintf "Queue or topic with name = \"%s\" does not exists" name))
        | _ -> raise (AzureServiceBusException "TODO: error")

module Parser =
    let ParseConnectionString str =
        match parse str with
        | Ok c -> c
        | Error e ->
            raise (FormatException("foo bar"))

type ConnectionString = ConnectionString

open Helper

[<AllowNullLiteral>]
type Message<'Msg when 'Msg: null>(msg: 'Msg, properties: BrokerProperties) =

    member this.Data with get() = msg
    member this.Properties with get() = properties


type QueueClient<'Msg when 'Msg: null>(connectionString, queueName) =
    let inner = Havarnov.AzureServiceBus.QueueClient<'Msg>(connectionString, queueName)

    member this.PostAsync msg =
        inner.Post msg
        |> Async.map (fun r -> match r with
                                | Ok r -> ()
                                | Error e ->
                                    handleError e |> ignore
                                    ())
        |> Async.StartAsTask

    member this.ReceiveAsync() =
        inner.Receive()
        |> Async.map (fun r -> match r with
                                | Ok r -> Message(r.Data, r.Properties)
                                | Error e ->
                                    handleError e)
        |> Async.StartAsTask

    member this.DestructiveReceiveAsync() =
        inner.DestructiveReceive()
        |> Async.map (fun r -> match r with
                                | Ok r -> r
                                | Error e ->
                                    handleError e)
        |> Async.StartAsTask

    member this.DeleteMsgAsync lockToken sequenceNumber =
        inner.DeleteMsg lockToken sequenceNumber
        |> Async.map (fun r -> match r with
                                | Ok r -> r
                                | Error e ->
                                    handleError e |> ignore
                                    ())
        |> Async.StartAsTask
