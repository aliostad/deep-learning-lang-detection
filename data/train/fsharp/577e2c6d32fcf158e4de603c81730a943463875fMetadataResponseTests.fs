module ElectroElephant.Tests.MetadataResponseTests

open ElectroElephant.MetadataResponse
open ElectroElephant.Tests.StreamWrapperHelper
open FsCheck
open Fuchu

let brokerA = 
  { node_id = 1
    host = "heavensgate.com"
    port = 666 }

let brokerB = 
  { node_id = 2
    host = "devilsgate.com"
    port = 999 }

let partition_metadataA = 
  { error_code = 1s
    id = 123
    leader = 2
    replicas = [ 1; 2; 3 ]
    isr = [ 1; 2 ] }

let partition_metadataB = 
  { error_code = 2s
    id = 321
    leader = 2
    replicas = [ 1; 2; 3 ]
    isr = [ 1; 2 ] }

let topic_metadataA = 
  { error_code = 1s
    name = "icecream"
    partitions = [ partition_metadataA; partition_metadataB ] }

let partition_metadataC = 
  { error_code = 1s
    id = 123
    leader = 2
    replicas = [ 1; 2; 3 ]
    isr = [ 1; 2 ] }

let partition_metadataD = 
  { error_code = 2s
    id = 321
    leader = 2
    replicas = [ 1; 2; 3 ]
    isr = [ 1; 2 ] }

let topic_metadataB = 
  { error_code = 1s
    name = "icecream"
    partitions = [ partition_metadataC; partition_metadataD ] }

let sample_metadata_response = 
  { brokers = [ brokerA; brokerB ]
    topic_metadatas = [ topic_metadataA; topic_metadataB ] }

[<Tests>]
let tests = 
  testList "Serialization and Deserialization" [ testCase "before and after should be the same" <| fun _ -> 
                                                   let result = 
                                                     stream_wrapper<MetadataResponse> sample_metadata_response serialize 
                                                       deserialize
                                                   Assert.Equal("should be the same", sample_metadata_response, result)
                                                 testCase "FsCheck test" <| fun _ -> 
                                                   let fs (msg_set : MetadataResponse) = 
                                                     stream_wrapper<MetadataResponse> msg_set serialize deserialize = msg_set
                                                   Check.QuickThrowOnFailure fs ]