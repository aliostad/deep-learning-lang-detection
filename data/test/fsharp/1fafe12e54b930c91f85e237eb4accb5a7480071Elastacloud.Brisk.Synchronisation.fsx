(* This script updates blob assets in the different Brisk regions *)

#I @"..\packages"
#r @"Elastacloud.AzureManagement.Fluent\lib\net45\Elastacloud.AzureManagement.Fluent.dll"
#r @"WindowsAzure.Storage\lib\net40\Microsoft.WindowsAzure.Storage.dll"
#r @"Microsoft.WindowsAzure.ConfigurationManager\lib\net40\Microsoft.WindowsAzure.Configuration.dll"
#r "System.Xml.Linq.dll"

namespace Elastacloud.Brisk

module Synchronisation =
    open System
    open Elastacloud.AzureManagement.Fluent.Helpers.PublishSettings
    open Elastacloud.AzureManagement.Fluent.Clients
    open Microsoft.WindowsAzure.Storage
    open Microsoft.WindowsAzure.Storage.Blob

    type CopyResult = Uri * Uri

    type FileSyncResult = 
        | NewFile
        | UpdatedFile
        | FileAlreadyExists
        | Failed

    type StorageCredentials = 
        { AccountName : string
          StorageKey : string }

    type CertificateDetails = 
        { SubscriptionId : Guid
          Path : string }

    let private getStorageCredentials certificateDetails storageAccountName = 
        let [ managementCert ] = 
            let extractor = PublishSettingsExtractor certificateDetails.Path
            extractor.AddAllPublishSettingsCertificatesToPersonalMachineStore(certificateDetails.SubscriptionId.ToString()) 
            |> Seq.toList
    
        let storageKey = 
            let storageClient = StorageClient((certificateDetails.SubscriptionId.ToString "D"), managementCert)
            storageClient.GetStorageAccountKeys storageAccountName |> Seq.head
    
        CloudStorageAccount(Auth.StorageCredentials(storageAccountName, storageKey), true)

    let private getBlobPart (uri : Uri) = 
        uri.Segments
        |> Seq.skip 2
        |> Seq.truncate 5
        |> String.concat ""

    let private copyBlobTo (dest : ICloudBlob) (source : ICloudBlob) =
        try
            let sourceUri = Uri(sprintf "%s%s" (source.Uri.ToString()) (source.GetSharedAccessSignature(SharedAccessBlobPolicy(Permissions = SharedAccessBlobPermissions.Read, SharedAccessStartTime = (Nullable DateTimeOffset.UtcNow), SharedAccessExpiryTime = (Nullable (DateTimeOffset.UtcNow.AddDays 1.))))))
            Some(dest.StartCopyFromBlob(sourceUri) |> ignore)
        with _ -> None

    /// Synchronises a single file between a source and destination. If the file already exists, ensure the hashes are the same, otherwise start a blob copy.
    let private syncFile (sourceBlob : ICloudBlob, destBlob : ICloudBlob) =
        let copyResult = sourceBlob.Uri, destBlob.Uri
        async {
            let! destinationBlobExists = destBlob.ExistsAsync() |> Async.AwaitTask
            if destinationBlobExists then
                do! destBlob.FetchAttributesAsync() |> Async.AwaitIAsyncResult |> Async.Ignore
                if sourceBlob.Properties.Length = destBlob.Properties.Length then
                    return FileAlreadyExists, copyResult
                else
                    return 
                        match sourceBlob |> copyBlobTo destBlob with
                        | Some() -> UpdatedFile, copyResult
                        | None -> Failed, copyResult
            else 
                return
                    match sourceBlob |> copyBlobTo destBlob with
                    | Some() -> NewFile, copyResult
                    | None -> Failed, copyResult
        }

    /// Synchronises all the files in a container between source and dest.
    let private syncContainer (sourceContainer : CloudBlobContainer, destContainer : CloudBlobContainer) = 
        async {
            do! destContainer.CreateIfNotExistsAsync() |> Async.AwaitTask |> Async.Ignore
            let! blobs = sourceContainer.ListBlobsSegmentedAsync("", true, BlobListingDetails.All, Nullable 5000, null, null, null) |> Async.AwaitTask
            return!
                blobs.Results
                |> Seq.choose(function
                   | :? ICloudBlob as blob -> Some blob
                   | _ -> None)
                |> Seq.map (fun sourceBlob -> 
                   let blobName = getBlobPart sourceBlob.Uri       
                   let destBlob = 
                       match sourceBlob with
                       | :? CloudBlockBlob -> destContainer.GetBlockBlobReference(blobName) :> ICloudBlob
                       | :? CloudPageBlob -> destContainer.GetPageBlobReference(blobName) :> ICloudBlob
                       | _ -> failwith "WTF!"
                   sourceBlob, destBlob)
                |> Seq.map syncFile
                |> Async.Parallel
        }

    /// Synchronises an entire depot.
    let private syncDepot (source : CloudStorageAccount) (dest : CloudStorageAccount) = 
        async {
            let! sourceContainers = source.CreateCloudBlobClient().ListContainersSegmentedAsync("", ContainerListingDetails.None, Nullable 5000, null, null, null) |> Async.AwaitTask
            let destClient = dest.CreateCloudBlobClient()
            return!
                sourceContainers.Results
                |> Seq.map (fun sourceContainer -> sourceContainer, destClient.GetContainerReference(sourceContainer.Name))
                |> Seq.map syncContainer
                |> Async.Parallel
        }

    /// Synchronises all depots.
    let SyncAllDepots (certificateDetails : CertificateDetails, source : string, depots : string seq) = 
        async {
            let sourceStorageAccount = getStorageCredentials certificateDetails source
            let! results =
                depots
                |> Seq.map (fun destAccount -> syncDepot sourceStorageAccount (getStorageCredentials certificateDetails destAccount))
                |> Async.Parallel
        
            return
                results
                |> Seq.collect id
                |> Seq.collect id
                |> Seq.cache
        }

    let SourceDepot = "briskdepoteun"
    let TargetDepots = [ "briskdepotusw"; "briskdepoteuw"; "briskdepotuse"; "briskdepotussc";  ]

    let BizsparkCert = 
        { SubscriptionId = Guid "84bf11d2-7751-4ce7-b22d-ac44bf33cbe9"
          Path = "C:\Users\Isaac\Downloads\BizSpark Plus-7-8-2014-credentials.publishsettings" }

    //#time
    //let results =
    //    SyncAllDepots (BizsparkCert, SourceDepot, TargetDepots)
    //    |> Async.RunSynchronously
    //    |> Seq.toArray
    //
    //results
    //|> Seq.map(fun (res, (src, dest)) -> res, sprintf "%A %A" dest src)
    //|> Seq.groupBy fst
    //|> Seq.map(fun (a,b) -> a, b |> Seq.map snd |> Seq.toArray)
    //|> Seq.toArray
    //
    //
    //
