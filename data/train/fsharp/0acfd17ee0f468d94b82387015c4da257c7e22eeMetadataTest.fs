module ElectroElephant.Tests.Integration.Metadata

open ElectroElephant.Client
open ElectroElephant.MetadataResponse
open Fuchu

open System
open System.Threading

let broker_conf = 
  { brokers = 
      [ { hostname = "192.168.1.96"
          port = 9092 } ]
    topics = None }


/// IMPORTANT, if your running these tests against a local cluster then make sure that
/// the cluster is started, and that you have created a atleast one topic. For some reason
/// the kafka broker will claim it has no brokers until a topic is created.
[<Tests>]
let tests = 
  testList "smoke tests" [
    testCase "attempt to get metadata and verify we get something sane back." <| fun _ -> 
      let reset_event = new ManualResetEvent(false)

      let callback (state : ClientState) =
        Assert.Equal("should have one broker", 1, state.broker_to_actor.Count)
        Assert.Equal("should have one topic", 1, state.topic_to_partition.Count)
        Assert.Equal("should contain a yellow car topic", true ,
          state.topic_to_partition.ContainsKey "yellocars")
        reset_event.Set() |> ignore

      bootstrap broker_conf (Some callback) |> ignore
      reset_event.WaitOne() |> ignore
   ]