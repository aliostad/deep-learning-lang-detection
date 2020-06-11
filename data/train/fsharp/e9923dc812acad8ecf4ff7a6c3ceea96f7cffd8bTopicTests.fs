namespace Nata.IO.Kafunk.Tests

open System
open System.Reflection
open System.Text
open FSharp.Data
open NUnit.Framework

open Nata.Core
open Nata.IO
open Nata.IO.Channel
open Nata.IO.Kafunk

[<TestFixture>]
type TopicTests() =
    inherit Nata.IO.Tests.LogStoreTests()

    let cluster = Connection.create { Settings.defaultSettings with Hosts=["tcp://127.0.0.1:9092"] }

    // to unit test on a local kafka instance, the following broker
    // settings are required (in ./config/server.properties):
    //
    // num.partitions=1
    // auto.create.topics.enable=true
    
    override x.Connect() =
        Topic.connect cluster
        |> Source.mapIndex (Offsets.Codec.OffsetsToInt64 0)
        <| guid()

    [<Test; Timeout(360000)>]
    member x.TestReadWriteIntegers() =
        let expected = [ 1..100 ]
        let topic =
            Topic.connect cluster
            |> Source.mapIndex (Offsets.Codec.OffsetsToInt64 0)
            |> Source.mapData (Codec.BytesToString)
            |> Source.mapData (Codec.StringToInt32)
            <| guid()
        let read, write =
            reader topic,
            writer topic

        expected 
        |> Seq.iter (Event.create >> write)

        let actual =
            read()
            |> Seq.take (List.length expected)
            |> Seq.map (Event.data)
            |> Seq.sort
            |> Seq.toList

        Assert.AreEqual(expected, actual)
        
    [<Test>]
    override x.TestReadFromBeforeEnd() = Assert.Ignore("Not yet supported.")
    [<Test>]
    override x.TestSubscribeFromBeforeEnd() = Assert.Ignore("Not yet supported.")