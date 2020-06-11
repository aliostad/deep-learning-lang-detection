module Havarnov.AzureServiceBus.UnitTests

open System

open Xunit

module BrokerProperties =
    open Newtonsoft.Json

    open Havarnov.AzureServiceBus

    [<Fact>]
    let deserializeBrokerProperties () =
        // let propStr =
        //     """{"DeliveryCount":1,"EnqueuedSequenceNumber":0,"EnqueuedTimeUtc":"Wed, 19 Apr 2017 19:00:39 GMT","LockToken":"a1d774f6-ae8d-4338-a4dc-1cd26e360092","LockedUntilUtc":"Wed, 19 Apr 2017 19:01:53 GMT","MessageId":"6d8c5eb04e07459f85a38069e7e6ae9f","PartitionKey":"241","SequenceNumber":41095346599755778,"State":"Active","TimeToLive":1209600}"""
        let propStr =
            """{"LockToken":"a1d774f6-ae8d-4338-a4dc-1cd26e360092","SequenceNumber":41095346599755778}"""
        let prop = JsonConvert.DeserializeObject<BrokerProperties>(propStr)

        Assert.Equal("a1d774f6-ae8d-4338-a4dc-1cd26e360092", prop.LockToken)

module ConnectionString =
    open Havarnov.AzureServiceBus.ConnectionString

    [<Fact>]
    let parseConnectionString () =
        let c = parse "Endpoint=sb://test.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=+foobar="
        match c with
        | Ok c ->
            Assert.Equal("RootManageSharedAccessKey", c.SharedAccessKeyName)
            Assert.Equal("+foobar=", c.SharedAccessKey)
            Assert.Equal(Uri("https://test.servicebus.windows.net/"), c.Endpoint)
        | Error e -> Assert.True(false, e)
