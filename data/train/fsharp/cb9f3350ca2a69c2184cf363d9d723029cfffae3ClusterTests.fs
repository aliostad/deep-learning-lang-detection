namespace Nata.IO.KafkaNet.Tests

open System
open System.Reflection
open System.Text
open FSharp.Data
open NUnit.Framework

open Nata.Core
open Nata.IO
open Nata.IO.Channel
open Nata.IO.KafkaNet

[<TestFixture>]
type ClusterTests() =

    let cluster = ["tcp://127.0.0.1:9092"]

    // to unit test on a local kafka instance, the following broker
    // settings are required (in ./config/server.properties):
    //
    // num.partitions=1
    // auto.create.topics.enable=true
    
    let connect() =
        Topic.connect cluster
        |> Source.mapIndex (Offsets.Codec.OffsetsToInt64 0)
        |> Source.mapData (Codec.BytesToString)
        |> Source.mapData (Codec.StringToInt32)

    [<Test; Timeout(360000)>]
    member x.TestReadWriteIntegers() =
        let expected = [ 1..100 ]

        let topic = connect() <| guid()
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
