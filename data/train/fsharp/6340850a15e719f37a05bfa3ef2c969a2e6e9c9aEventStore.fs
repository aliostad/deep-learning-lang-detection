module StuffExchange.Ports.EventStore

open StuffExchange.EventStore.AsyncExtensions
open StuffExchange.EventStore.Store
open StuffExchange.Core.Railway
open StuffExchange.Contract.Events


let getEventsForAggregate id =
    id.ToString()
    |> readStream 

let addEventToAggregate id event =
    appendToStream (id.ToString()) event |> Success

let subscribeToEventType eventType eventHandler =
    let streamId = sprintf "$et-%s" eventType
    subscribeToStream streamId eventHandler

let subscribeToDomainEvents eventHandler =
    let streamId = "domainEvents" 
    subscribeToStream streamId eventHandler


    