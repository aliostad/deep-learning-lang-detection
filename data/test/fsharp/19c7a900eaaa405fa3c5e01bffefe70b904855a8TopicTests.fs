namespace Nata.IO.KafkaNet.Tests

open System
open System.Reflection
open System.Text
open FSharp.Data
open NUnit.Framework

open Nata.Core
open Nata.IO
open Nata.IO.Capability
open Nata.IO.KafkaNet

[<TestFixture>]
type TopicTests() =
    inherit Nata.IO.Tests.LogStoreTests()

    let cluster = ["tcp://127.0.0.1:9092"]

    // to unit test on a local kafka instance, the following broker
    // settings are required (in ./config/server.properties):
    //
    // num.partitions=1
    // auto.create.topics.enable=true
    
    override x.Connect() =
        Topic.connect cluster
        |> Source.mapIndex (Offsets.Codec.OffsetsToInt64 0)
        <| guid()

    [<Test>]
    override x.TestReadFromBeforeEnd() = Assert.Ignore("Not yet supported.")
    [<Test>]
    override x.TestSubscribeFromBeforeEnd() = Assert.Ignore("Not yet supported.")