namespace Nata.IO.Kafunk.Tests

open System
open System.Reflection
open System.Text
open FSharp.Data
open NUnit.Framework

open Nata.Core
open Nata.IO
open Nata.IO.Capability
open Nata.IO.Kafunk

[<TestFixture>]
type TopicPartitionTests() =
    inherit Nata.IO.Tests.LogStoreTests()

    let cluster = Connection.create { Settings.defaultSettings with Hosts=["tcp://127.0.0.1:9092"] }

    // to unit test on a local kafka instance, the following broker
    // settings are required (in ./config/server.properties):
    //
    // num.partitions=1
    // auto.create.topics.enable=true
    
    override x.Connect() =
        TopicPartition.connect cluster
        |> Source.mapChannel (fst, (fun (x) -> x,0))
        |> Source.mapIndex (Offset.position,(fun x -> {Offset.PartitionId=0;Position=x}))
        <| guid()