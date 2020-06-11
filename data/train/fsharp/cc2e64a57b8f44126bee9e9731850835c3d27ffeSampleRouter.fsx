#load "Bootstrap.fsx"

open System
open Akka.Actor
open Akka.FSharp

type RouterMessage =
    | RouterMessage of string

let processRunner (id:int) (mailbox: Actor<RouterMessage>) =
    let rec loop() = actor {
        let! msg = mailbox.Receive ()
        match msg with
        | RouterMessage message -> message |> sprintf "Endpoint %i received `%s`" id |> Console.WriteLine
    }

    loop()

let routerRunner (process0 : IActorRef) (process1 : IActorRef) (mailbox : Actor<RouterMessage>) =
    let rec loop pid = actor {
        let! msg = mailbox.Receive ()
        sprintf "Router will route to `%d`" pid |> Console.WriteLine

        let proc, nextPid = if pid = 1 then process1, 0 else process0, 1
        proc <! msg

        return! loop nextPid
    }

    loop 0

let system = System.create "CInfinity" <| Configuration.defaultConfig ()
let process0 = spawn system "p0" <| processRunner 0
let process1 = spawn system "p2" <| processRunner 1
let router = spawn system "router" <| routerRunner process0 process1

router <! RouterMessage ("Hello world! - should go to 0")
router <! RouterMessage ("Hello world! - should to to 1")

