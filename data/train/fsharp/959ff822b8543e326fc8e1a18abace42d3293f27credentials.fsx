#load "../../packages/MBrace.Azure.Client/bootstrap.fsx"

namespace global

[<AutoOpen>]
module ConnectionStrings = 

    open MBrace
    open MBrace.Azure
    open MBrace.Azure.Client
    open MBrace.Azure.Runtime

    let myStorageConnectionString = "your"
    let myServiceBusConnectionString = "your"

    let createStorageConnectionString(storageName, storageAccessKey) = sprintf "DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s" storageName storageAccessKey
    let createServiceBusConnectionString(serviceBusName, serviceBusKey) = sprintf "Endpoint=sb://%s.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=%s" serviceBusName serviceBusKey

    let config =
        { Configuration.Default with
            StorageConnectionString = myStorageConnectionString
            ServiceBusConnectionString = myServiceBusConnectionString }

    
