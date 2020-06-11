namespace FSharp.DataProcessingPipelines.Infrastructure

open System
open System.Globalization
open System.Threading
open EasyNetQ
open FSharp.DataProcessingPipelines.Core
open FSharp.DataProcessingPipelines.Core.Pipes

module RabbitMQ =

    /// OutputPipe type implementation for RabbitMQ
    type RabbitMQOutputPipe<'T when 'T : not struct> (serviceBus:IBus, topic:String) = 

        inherit IOutputPipe<'T> ()

        let Bus = serviceBus
        let Topic = topic

        override this.Publish m = 
            try
                Bus.Publish<'T>(m, Topic)
            with
                | ex -> 
                    // log exception
                    reraise()

    /// InputPipe type implementation for RabbitMQ
    type RabbitMQInputPipe<'T when 'T : not struct> 
        (serviceBus:IBus, subscriberId:String, topic:String, locale:String) = 

        inherit IInputPipe<'T> ()

        let Bus = serviceBus
        let SubscriberId = subscriberId
        let Topic = topic
        let Locale = locale

        override this.Subscribe (handler:('T -> unit)) = 
            let InternalHandler (message:'T) = 
                Thread.CurrentThread.CurrentCulture <- new CultureInfo(Locale)
                handler message
            try
                Bus.Subscribe<'T>(SubscriberId, (fun m -> InternalHandler m), (fun x -> x.WithTopic(Topic) |> ignore)) |> ignore
            with
            | ex -> 
                // log exception
                reraise()
