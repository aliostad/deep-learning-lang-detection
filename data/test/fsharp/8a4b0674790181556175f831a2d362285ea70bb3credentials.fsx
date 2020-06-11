#I "../packages/MBrace.Azure.Standalone/tools"
#I "../packages/Streams/lib/net45"
#I "../packages/MBrace.Flow/lib/net45"
#load "../packages/MBrace.Azure.Standalone/MBrace.Azure.fsx"

namespace global

[<AutoOpen>]
module ConnectionStrings = 

    open MBrace
    open MBrace.Azure
    open MBrace.Azure.Client
    open MBrace.Azure.Runtime

    // Both of the connection strings can be found under "Cloud Service" --> "Configure" --> scroll down to "MBraceWorkerRole"
    //
    // The storage connection string is of the form  
    //    DefaultEndpointsProtocol=https;AccountName=myAccount;AccountKey=myKey 
    //
    // The serice bus connection string is of the form
    //    Endpoint=sb://%s.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=%s

    let myStorageConnectionString = "DefaultEndpointsProtocol=https;AccountName=neelastaad53604a0e284983;AccountKey=MJwHStYj7nDLXS4b3RvyXtJPK8RRmcntxuT231GtXM6aifBnaHvwfOZM6oLakTP054DgNmEdbAARSg45d6hgzw=="
    let myServiceBusConnectionString = "Endpoint=sb://brisk-ne4091ad53604a.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=4LO6OFLFva09B1jKzM1ZEh1Ip8o7CPw1m04IsuOpI8M="

    // Alternatively you can specify the connection strings by calling the functions below
    //
    // storageName: the one you specified when you created cluster.
    // storageAccessKey: found under "Manage Access Keys" for that storage account in the Azure portal.
    // serviceBusName: the one you specified when you created cluster.
    // serviceBusKey: found under "Configure" for the service bus in the Azure portal
    
    let createStorageConnectionString(storageName, storageAccessKey) = sprintf "DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s" storageName storageAccessKey
    let createServiceBusConnectionString(serviceBusName, serviceBusKey) = sprintf "Endpoint=sb://%s.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=%s" serviceBusName serviceBusKey

    let config =
        { Configuration.Default with
            StorageConnectionString = myStorageConnectionString
            ServiceBusConnectionString = myServiceBusConnectionString }