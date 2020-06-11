// Learn more about F# at http://fsharp.org
// See the 'F# Tutorial' project for more help.

module Config =

    open System.IO
    open MBrace.Core
    open MBrace.Runtime
    open MBrace.Azure
    open MBrace.Azure.Management
    open System

    // This script is used to reconnect to your cluster.

    // You can download your publication settings file at 
    //     https://manage.windowsazure.com/publishsettings
    let pubSettingsFile = @"E:\github\MbraceAzuer\MBrace.StarterKit-master\AzureEAGopfs.publishsettings"

    // If your publication settings defines more than one subscription,
    // you will need to specify which one you will be using here.
    let subscriptionId : string option = None

    // Your prefered Azure service name for the cluster.
    // NB: must be a valid DNS prefix unique across Azure.
    let clusterName = "VikEmbraceCBR"

    // Your prefered Azure region. Assign this to a data center close to your location.
    let region = Region.West_US
    // Your prefered VM size
    let vmSize = VMSize.Large
    // Your prefered cluster count
    let vmCount = 4

    // set to true if you would like to provision
    // the custom cloud service bundled with the StarterKit
    // In order to use this feature, you will need to open
    // the `CustomCloudService` solution under the `azure` folder 
    // inside the MBrace.StarterKit repo.
    // Right click on the cloud service item and hit "Package.."
    let useCustomCloudService = false
    let private tryGetCustomCsPkg () =
        if useCustomCloudService then
            let path = __SOURCE_DIRECTORY__ + "/../azure/CustomCloudService/bin/app.publish/MBrace.Azure.CloudService.cspkg" |> Path.GetFullPath
            if not <| File.Exists path then failwith "Find the 'MBrace.Azure.CloudService' project under 'azure\CustomCloudService' and hit 'Package...'."
            Some path
        else
            None

    let GetSubscriptionManager() = 
        SubscriptionManager.FromPublishSettingsFile(pubSettingsFile, region, ?subscriptionId = subscriptionId, logger = new ConsoleLogger())

    /// Gets the already existing deployment
    let GetDeployment() = GetSubscriptionManager().GetDeployment(clusterName) 

    /// Provisions a new cluster to Azure with supplied parameters
    let ProvisionCluster() = 
        GetSubscriptionManager().Provision(vmCount, serviceName = clusterName, vmSize = vmSize, ?cloudServicePackage = tryGetCustomCsPkg())

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
        let deployment = GetDeployment()
        AzureCluster.Connect(deployment, logger = ConsoleLogger(true), logLevel = LogLevel.Info)

open System
open System.IO
open MBrace.Core
open MBrace.Runtime
open MBrace.Azure
open MBrace.Azure.Management

[<EntryPoint>]
let main argv = 
    let cluster = Config.GetCluster()

    let task = 
        cloud { return "Hello world!" } 
        |> cluster.Run
        
    Console.ReadLine() |> ignore
    0 // return an integer exit code