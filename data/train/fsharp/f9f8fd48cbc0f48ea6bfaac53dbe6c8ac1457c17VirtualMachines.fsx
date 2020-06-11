#r "C:\\Users\\Richard\\Downloads\\Lenovo backup\\Projects\\Elastacloud\\fluent-management\\Elastacloud.AzureManagement.Fluent\\bin\\Release\\Elastacloud.AzureManagement.Fluent.dll"
#r "C:\\Users\\Richard\\Downloads\\Lenovo backup\\Projects\\Elastacloud\\fluent-management\\Elastacloud.AzureManagement.Fluent\\bin\\Release\\Elastacloud.AzureManagement.Fluent.Types.dll"
#r "C:\\Users\\Richard\\Downloads\\Lenovo backup\\Projects\\Elastacloud\\fluent-management\\Elastacloud.AzureManagement.Fluent\\bin\\Release\\Elastacloud.AzureManagement.Fluent.Utils.dll"
#r "C:\\Program Files (x86)\\Reference Assemblies\\Microsoft\\Framework\\.NETFramework\\v4.5\\System.Xml.Linq.dll"
#r @"..\packages\IPNetwork.1.3.1.0\lib\LukeSkywalker.IPNetwork.dll"
#r @"..\packages\FSharp.Data.2.0.14\lib\net40\FSharp.Data.dll"

open Elastacloud.AzureManagement.Fluent
open Elastacloud.AzureManagement.Fluent.Types
open Elastacloud.AzureManagement.Fluent.Clients
open Elastacloud.AzureManagement.Fluent.VirtualNetwork
open Elastacloud.AzureManagement.Fluent.Helpers.PublishSettings
open FSharp.Data
open System.Xml.Linq
open System.Net
open LukeSkywalker.IPNetwork
open System
open Elastacloud.AzureManagement.Fluent.VirtualMachines.Classes
open Elastacloud.AzureManagement.Fluent.Types.VirtualMachines
open System.Collections.Generic
open System.Security.Cryptography.X509Certificates
open Elastacloud.AzureManagement.Fluent.Types.VirtualNetworks
open Elastacloud.AzureManagement.Fluent.Watchers
open Elastacloud.AzureManagement.Fluent.Types.Exceptions

let subscriptionId = "84bf11d2-7751-4ce7-b22d-ac44bf33cbe9"
/// Start Fuctions 
let settingCert fileName subscriptionId =
    let settings = PublishSettingsExtractor fileName
    settings.AddAllPublishSettingsCertificatesToPersonalMachineStore(subscriptionId).[0] 
let getFromBizsparkPlus = settingCert "C:\\Users\\Richard\\Downloads\\Lenovo backup\\Projects\\bizspark.pubsettings"
let vmClient = LinuxVirtualMachineClient(subscriptionId, getFromBizsparkPlus subscriptionId)
let csName = "briskit1003"
let vmName = "briskit"


let storageClient = StorageClient(subscriptionId, getFromBizsparkPlus subscriptionId)
let accounts = storageClient.GetStorageAccountList()
let account = accounts |> Seq.filter (fun account -> account.Name = "azurecoder11")





let sshEndpoint = InputEndpoint(EndpointName = "ssh",
                                LocalPort = 22,
                                Port = Nullable(22),
                                Protocol = Protocol.TCP)

let properties = new LinuxVirtualMachineProperties(
                                                    VmSize = VmSize.Standard_D1,
                                                    UserName = "azurecoder",
                                                    AdministratorPassword = "P@ssword761",
                                                    HostName = "briskit",
                                                    RoleName = "briskit",
                                                    CloudServiceName = "briskit1003",
                                                    PublicEndpoints = List<InputEndpoint>([|sshEndpoint|]),
                                                    CustomTemplateName = "b39f27a8b8c64d52b05eac6a62ebad85__Ubuntu-14_10-amd64-server-20150416-en-us-30GB",
                                                    DeploymentName = "briskit1003",
                                                    StorageAccountName = "clustered")//,
                                                    //VirtualNetwork = VirtualNetworkDescriptor(
                                                     //                                         VirtualNetworkName = "fsnet",
                                                     //                                         SubnetName = "fred"))

vmClient.LinuxVirtualMachineStatusEvent.Subscribe(fun vmstatus -> printfn "from %s to %s" (vmstatus.OldStatus.ToString()) (vmstatus.NewStatus.ToString()))
try
    vmClient.CreateNewVirtualMachineDeploymentFromTemplateGallery(
                                                                  List<LinuxVirtualMachineProperties>([|properties|]),
                                                                  "briskit1003") |> ignore
with
| :? ApplicationException as fmwe -> printfn "%s" fmwe.Message |> ignore

let port23 = InputEndpoint(EndpointName = "test 23", LocalPort = 23, Port = Nullable(23), Protocol = Protocol.TCP)
let port24 = InputEndpoint(EndpointName = "test 24", LocalPort = 24, Port = Nullable(24), Protocol = Protocol.TCP)
let port22 = InputEndpoint(EndpointName = "ssh", LocalPort = 22, Port = Nullable(22), Protocol = Protocol.TCP)
let endpoints = [| port23; port24|]
let endpointsClose = [| port22 |]
vmClient.OpenPorts(csName, vmName, endpoints)
vmClient.ClosePorts(csName, vmName, endpointsClose)
let hosts = vmClient.GetHostDetails("briskit1003")
vmClient.GetCurrentUbuntuImage()
                                    

// test 1: Ensure that above contains no subnets when it's created and returns the address range + 1 ip
// test 2: Receive events on state changes and ensure readyrole
// test 3: When created delete the subnet from the vnet - should generate a subnet busy exception of some sort
let vnClient = VirtualNetworkClient(subscriptionId, (getFromBizsparkPlus subscriptionId))
let all = vnClient.GetAvailableVirtualNetworks()
let we = vnClient.GetAvailableVirtualNetworks("West Europe")
let ne = vnClient.GetAvailableVirtualNetworks("North Europe")
vnClient.AddSubnetToAddressRange("bigbadbeetleborgs", "10.0.0.0/20", "max-1")
vnClient.RemoveSubnet("skynet", "cluster")
let images = vmClient.GetCurrentUbuntuImage()
let attack = vmClient.GetHostDetails("sparkattack")
let attack1 = vmClient.GetHostDetails("isaacfliptest1")
let csnetwork = vnClient.GetCloudServiceSubnetCollection("isaacfliptest7")
attack.[0].Endpoints
// take a look at the testing of the service bus namespace create 
let sbClient = ServiceBusClient(subscriptionId, (getFromBizsparkPlus subscriptionId))
// this is available 
let bobbydavro = sbClient.CheckNamespaceExists("bobbydavro")
// this will always return false - it violates the rules but we haven't put a rules check in so should return false
let fred = sbClient.CheckNamespaceExists("fred")
// create a namespace which violates the rules
let fred2 = sbClient.CreateNamespace("fred")
// create a valid namespace - bug in the service managemet api - returns a 403 downstream service access
let toolscheck = sbClient.CheckNamespaceExists("elastatools3")
let elastacloud = sbClient.CreateNamespace("elastatools3")
let clouddelete = sbClient.DeleteNamespace("elastatools3")
let sblist = sbClient.GetServiceBusNamspaceList("West US")
let sbpolicy = sbClient.GetServiceBusConnectionString("briskuidev", "RootManageSharedAccessKey")


let manager = new SubscriptionManager(subscriptionId)
let watcher = manager.GetRoleStatusChangedWatcher("isaacfoobar", 
                                                  "isaacfoobar", 
                                                  DeploymentSlot.Production, 
                                                  (getFromBizsparkPlus subscriptionId).Thumbprint) 
watcher.RoleStatusChangeHandler.Add(fun status -> printfn "from %s to %s" (status.OldState.ToString()) (status.NewState.ToString()))

