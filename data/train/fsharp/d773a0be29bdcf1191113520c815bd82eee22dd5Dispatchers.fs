namespace FSharp.Actor 

open System
open System.Threading
open FSharp.Actor
open FSharp.Actor.Types

type DispatcherStartException(inner:exn) =
    inherit Exception("Error on dispatcher startup", inner)
   
type DispatcherShutdownException(inner:exn) =
    inherit Exception("Error on dispatcher shutdown", inner)
    
type DispatcherMessageHandlingException(inner:exn, message:MessageEnvelope) =
    inherit Exception("Error on dispatcher handling message", inner)
    member val Message = message with get


type DisruptorBasedDispatcher() = 
    
    let mutable registry : IRegister = Unchecked.defaultof<_>
    let mutable transports : seq<ITransport> = Seq.empty
    let mutable supervisor : ActorRef = Unchecked.defaultof<_>

    let genericHandler handleF = 
        { new Disruptor.IEventHandler<MessageEnvelope> with
               member x.OnNext(data, sequence, endOfBatch) =
                    handleF(data)
        }

    let transportHandler (transport:ITransport) = 
        { new Disruptor.IEventHandler<MessageEnvelope> with
               member x.OnNext(data, sequence, endOfBatch) =
                    transport.Post(data)
        }

    let errorHandler = 
        { new Disruptor.IExceptionHandler with
            member x.HandleOnStartException(error) =
                 //TODO: Really should have and actor or event stream to handle these sort of things
                 Logger.Current.Error("Dispatcher failed to start", Some error)
            member x.HandleOnShutdownException(error) =
                 Logger.Current.Error("Dispatcher failed to shutdown", Some error)
            member x.HandleEventException(error, sequence, data) =
                 Logger.Current.Error("Dispatcher event errored", Some error)

        }

    let mutable router : Disruptor.Dsl.Disruptor<MessageEnvelope> = null

    let publish payload = 
        router.PublishEvent(fun msg seq -> 
                              msg.Message <- payload.Message
                              msg.Target <- payload.Target
                              msg.Sender <- payload.Sender
                              msg.Properties <- payload.Properties
                              msg 
                           )

    let resolveAndPost (msg:MessageEnvelope) = 
        match registry.TryResolve msg.Target with
        | Some(r) -> r.Post(msg)
        | None -> 
            Logger.Current.Error(sprintf "Undeliverable message %A" msg, None)

    let wireTransportReceiversAndGetPublishers (transports:seq<ITransport>) =
         transports |> Seq.iter (fun (transport:ITransport) -> transport.Receive |> Event.add resolveAndPost; transport.Start())

    let createRouter() = 
        let disruptor = Disruptor.Dsl.Disruptor(MessageEnvelope.Factory, 1024, Tasks.TaskScheduler.Default)
        disruptor.HandleExceptionsWith(errorHandler)
        disruptor.HandleEventsWith(genericHandler resolveAndPost) 
                 .Then(Seq.map transportHandler transports |> Seq.toArray) |> ignore
        router <- disruptor
        disruptor.Start() |> ignore
        wireTransportReceiversAndGetPublishers transports

    interface IDispatcher with
        member x.Post(msg) = publish msg
        member x.Dispose() = 
            router.Halt()
            router <- null
            transports |> Seq.iter (fun t -> t.Dispose())
        member x.Configure(reg:IRegister, ts:seq<ITransport>, sup:ActorRef) = 
            registry <- reg
            transports <- ts
            supervisor <- sup
            createRouter()
