module Niancat.Api.WebParts

open Suave
open Suave.Filters
open Suave.Operators
open Suave.RequestErrors
open Suave.Writers
open Suave.WebSocket
open Suave.Sockets
open Suave.Sockets.Control

open Niancat.Api.CommandApi
open Niancat.Api.QueryApi
open Niancat.Api.JsonFormatters

open Niancat.Application.CommandHandlers
open Niancat.Application.ApplicationServices
open Niancat.Core.Events

let publishEventsOnWebsockets (eventsStream : Event<Event list>) (ws : WebSocket) cx = socket {
    while true do
        let! events =
            Async.AwaitEvent(eventsStream.Publish)
            |> SocketOp.ofAsync

        for event in events do
            let eventData =
                event |> eventAsJson |> string |> System.Text.Encoding.UTF8.GetBytes |> ByteSegment

            do! ws.send Text (ByteSegment (Array.ofSeq eventData)) true
}

let niancat applicationService =
    choose [
        path "/command" >=> choose [
            POST >=> commandApiHandler applicationService
            METHOD_NOT_ALLOWED ""
        ]
        path "/events" >=> handShake (publishEventsOnWebsockets applicationService.eventStream)
        GET >=> queryApiHandler applicationService.queries
        NOT_FOUND ""
    ]
