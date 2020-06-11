module SendTweetJobHandlerTestFixture

open FsUnit.Xunit
open Lacjam
open Lacjam.Core
open Lacjam.Worker
open Lacjam.Worker.Scheduler
open Microsoft.FSharp.Control
open NServiceBus
open NSubstitute
open Ploeh
open Ploeh.AutoFixture
open System
open System.Diagnostics
open Xunit
open Lacjam.Core.Infrastructure.Exceptions
open Lacjam.Core.Runtime.Ioc
open Lacjam.Core.Infrastructure.Logging

let public fixture = AutoFixture.Fixture()
let logger = Substitute.For<ILogWriter>()
let bus = Substitute.For<IBus>()
let js = Substitute.For<IJobScheduler>()
let qs = Substitute.For<Quartz.IScheduler>()

[<Fact>]
let ``Should fail if total chars > 140``() =
    let job = fixture.Create<Jobs.SendTweetJob>()
    let sb = new System.Text.StringBuilder()
    let list = List.ofSeq [ 1..200 ]  |> Seq.iter(fun x-> sb.Append(x) |> ignore)
    job.Payload <- sb.ToString()
    let handler = new Handlers.SendTweetJobHandler(bus, logger)
    Assert.Throws<ValidationException>(fun _ -> handler.Handle(job)) |> ignore
    ()