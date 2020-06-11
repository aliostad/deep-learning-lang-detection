module ExampleActors

open BaseActor
open LogBuilder
open Akka.FSharp

type ActorMessages =
    | Wait of int
    | Stop

let waitProcess = function
    | Wait d -> Async.Sleep d |> Async.RunSynchronously
    | Stop   -> ()

let waitOrStopProcess (mailbox: Actor<_>) = function
    | Wait d -> Async.Sleep d |> Async.RunSynchronously
    | Stop   -> mailbox.Context.Stop mailbox.Self

let failProcess (log: ILogBuilder) =
    try
        failwith "unexpected problem!"
    with
        | e -> log.Fail e

let failOrStopProcess (mailbox: Actor<_>) msg (log: ILogBuilder) =
    try
        match msg with
        | Wait d -> failwith "can't wait!"
        | Stop   -> mailbox.Context.Stop mailbox.Self
    with
        | e -> log.Fail e

let spawnWaitWorker() =
    loggerActor <| Wrap.Handler(fun mb msg log -> waitProcess msg)

let spawnWaitOrStopWorker() =
    loggerActor <| Wrap.Handler(fun mb msg log -> waitOrStopProcess mb msg)

let spawnFailWorker() =
    loggerActor <| Wrap.Handler(fun mb msg log -> failProcess log)

let spawnFailOrStopWorker() =
    loggerActor <| Wrap.Handler(fun mb msg log -> failOrStopProcess mb msg log)