module Handlers

open AvailabilityService.Contract.Events

type TicketsCancelledHandler(notify, getCallback : string -> Async<string>) =
    inherit RabbitMQ.Subscriber.MessageHandler<TicketsCancelledEvent>()
    override this.HandleMessage (messageId) (sentAt) (message : TicketsCancelledEvent) = async {
        let! callback = getCallback message.EventId
        do! notify callback messageId message
    }

type TicketsCancellationFailedHandler(notify, getCallback : string -> Async<string>) =
    inherit RabbitMQ.Subscriber.MessageHandler<TicketsCancellationFailedEvent>()
    override this.HandleMessage (messageId) (sentAt) (message : TicketsCancellationFailedEvent) = async {
        let! callback = getCallback message.EventId
        do! notify callback messageId message
    }

type TicketsAllocatedHandler(notify, getCallback : string -> Async<string>) =
    inherit RabbitMQ.Subscriber.MessageHandler<TicketsAllocatedEvent>()
    override this.HandleMessage (messageId) (sentAt) (message : TicketsAllocatedEvent) = async {
        let! callback = getCallback message.EventId
        do! notify callback messageId message
    }

type TicketsAllocationFailedHandler(notify, getCallback : string -> Async<string>) =
    inherit RabbitMQ.Subscriber.MessageHandler<TicketsAllocationFailedEvent>()
    override this.HandleMessage (messageId) (sentAt) (message : TicketsAllocationFailedEvent) = async {
        let! callback = getCallback message.EventId
        do! notify callback messageId message
    }