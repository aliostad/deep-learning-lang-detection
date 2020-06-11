#load "../../packages/MBrace.Azure/MBrace.Azure.fsx"
#load "../../packages/MBrace.Azure.Management/MBrace.Azure.Management.fsx"
#r "../../packages/Streams/lib/net45/Streams.dll"
#r "../../packages/MBrace.Flow/lib/net45/MBrace.Flow.dll"
 
namespace global

module Config =

    open System.IO
    open MBrace.Core
    open MBrace.Runtime
    open MBrace.Azure
    open MBrace.Azure.Management

    // This script is used to reconnect to your cluster.

    // You can download your publication settings file at 
    //     https://manage.windowsazure.com/publishsettings
    let pubSettingsFile = @"C:\path\to\your.publishsettings"

    // If your publication settings defines more than one subscription,
    // you will need to specify which one you will be using here.
    let subscriptionId = None : string option

    // Your prefered Azure service name for the cluster.
    // NB: must be a valid DNS prefix unique across Azure.
    let clusterName = "enter a valid cloud service name"

    // Your prefered Azure region. Assign this to a data center close to your location.
    let region = Region.North_Europe
    // Your prefered VM size
    let vmSize = VMSize.Large
    // Your prefered cluster count
    let vmCount = 4

    /// Optional cluster configuration for non-provisioned clusters
    let configuration = None : Configuration option

    /// Gets the already existing deployment
    let GetDeployment() = Deployment.GetDeployment(pubSettingsFile, serviceName = clusterName, ?subscriptionId = subscriptionId) 

    /// Provisions a new cluster to Azure with supplied parameters
    let ProvisionCluster() = 
        Deployment.Provision(pubSettingsFile, region, vmCount, vmSize, serviceName = clusterName, ?subscriptionId = subscriptionId)

    /// Resizes the cluster using an updated VM count
    let ResizeCluster(newVmCount : int) =
        let deployment = GetDeployment()
        deployment.Resize(newVmCount)

    /// Deletes an existing cluster deployment
    let DeleteCluster() =
        let deployment = GetDeployment()
        deployment.Delete()

    /// Connect to the cluster 
    let GetCluster() = 
        let config =
            match configuration with
            | None -> GetDeployment().Configuration
            | Some cfg -> cfg

        AzureCluster.Connect(config, logger = ConsoleLogger(true), logLevel = LogLevel.Info)

    /// Updates the current config file with supplied parameters
    let UpdateConfig(pubSettingsPath : string, subscriptionId : string option, clusterName : string, region : Region, vmSize : VMSize, vmCount : int) =
        let this = Path.Combine(__SOURCE_DIRECTORY__, __SOURCE_FILE__)
        let updatedLines =
            [ for line in File.ReadAllLines this ->
                let (|Let|_|) (name : string) (line : string) =
                    if line.TrimStart().StartsWith("let " + name + " =") then Some(fun value -> sprintf "    let %s = %s" name value)
                    else None

                match line with
                | Let "pubSettingsFile" f -> f (sprintf "\"\"\"%s\"\"\"" pubSettingsPath)
                | Let "subscriptionId" f -> f (sprintf "%A : string option" subscriptionId)
                | Let "clusterName" f -> f (sprintf "%A" clusterName)
                | Let "region" f -> f (sprintf "Region.Define %A" region.Id)
                | Let "vmSize" f -> f (sprintf "VMSize.Define %A" vmSize.Id)
                | Let "vmCount" f -> f (string vmCount)
                | l -> l ]

        File.WriteAllLines(this, updatedLines)