module BaseActor

open Akka.FSharp
open System
open System.Linq.Expressions
open Metrics.MetricInterface
open Metrics.MetricExtensions
open Akka.Event
open LogBuilder
open Metrics

type Expr<'T,'TLog when 'TLog :> ILogBuilder> = Expression<System.Action<Actor<'T>, 'T, 'TLog>>

type Wrap =
    static member Handler(e:  Expression<System.Action<Actor<'T>, 'T, #ILogBuilder>>) = e

let toExprName (expr: Expr<_,_>) = 
    match expr.Body with
    | :? MethodCallExpression as methodCall -> methodCall.Method.Name
    | x -> x.ToString()

let loggerActor<'TMsg> (handler: Expr<'TMsg,_>) (mailbox: Actor<'TMsg>) =
    let exprName = handler |> toExprName
    let metrics  = mailbox.Context.GetMetricsProducer (ContextName exprName)
    let akkaLogger   = mailbox.Log.Value
    
    let errorMeter      = metrics.CreateMeter   (MetricName "Error Rate",              Errors)
    let instanceCounter = metrics.CreateCounter (MetricName "Instances Counter",       Items)
    let messagesMeter   = metrics.CreateMeter   (MetricName "Message Processing Rate", Items)
    let operationsTimer = metrics.CreateTimer   (MetricName "Operation Durations",     Requests, MilliSeconds, MilliSeconds)

    instanceCounter.Increment()
    mailbox.Defer instanceCounter.Decrement

    let completeOperation (msgType: Type) (logger: #ILogBuilder) =
        logger.Set (OperationName exprName)
        logger.OnOperationCompleted()

        match logger.TryGet(OperationDuration TimeSpan.Zero) with
        | Some(OperationDuration dur) -> 
            operationsTimer.Measure(Amount (int64 dur.TotalMilliseconds), Item (Some exprName))
        | _ -> ()

        messagesMeter.Mark(Item (Some msgType.Name))

    let registerExn (msgType: Type) e (logger: #ILogBuilder) = 
        errorMeter.Mark(Item (Some msgType.Name))
        logger.Fail e

    let wrapHandler handler mb (logBuilder: unit -> #ILogBuilder) =
        let innherHandler mb msg  =
            let logger = logBuilder()
            let msgType = msg.GetType()
            logger.Set (MessageType msgType)
            try
                try
                    logger.OnOperationBegin()
                    logger.Set LogLevel.InfoLevel
                    handler mb msg logger                    
                with
                | e -> registerExn msgType e logger; reraise()
            finally
                completeOperation msgType logger
        innherHandler mb

    let wrapExpr (expr: Expr<_,_>) mb logger = 
        let action = expr.Compile()
        wrapHandler 
            (fun mb msg log -> action.Invoke(mb, msg, log))
            mb
            (fun () -> new LogBuilder(logger))

    let rec loop() = 
        actor {
            let! msg = mailbox.Receive()
            wrapExpr handler mailbox akkaLogger msg
            return! loop()
        }
    loop()