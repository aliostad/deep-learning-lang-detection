#r "D:\\Projects\\Elastacloud\\fluent-management\\Elastacloud.AzureManagement.Fluent\\bin\\Release\\Elastacloud.AzureManagement.Fluent.dll"
#r "D:\\Projects\\Elastacloud\\fluent-management\\Elastacloud.AzureManagement.Fluent\\bin\\Release\\Elastacloud.AzureManagement.Fluent.Types.dll"
#r "D:\\Projects\\Elastacloud\\fluent-management\\Elastacloud.AzureManagement.Fluent.Utils\\bin\\Release\\Elastacloud.AzureManagement.Fluent.Utils.dll"
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
open Elastacloud.AzureManagement.Fluent.Utils
open Elastacloud.AzureManagement.Fluent.Services

let xml = """<?xml version="1.0" encoding="utf-8"?>
<ServiceConfiguration serviceName="WindowsAzure1" xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceConfiguration" osFamily="3" osVersion="*" schemaVersion="2012-10.1.8">
  <Role name="WebRole1">
    <Instances count="2" />
    <ConfigurationSettings>
      <Setting name="Microsoft.WindowsAzure.Plugins.Diagnostics.ConnectionString" value="UseDevelopmentStorage=true" />
      <Setting name="Microsoft.WindowsAzure.Plugins.Caching.NamedCaches" value="{&quot;caches&quot;:[{&quot;name&quot;:&quot;default&quot;,&quot;policy&quot;:{&quot;eviction&quot;:{&quot;type&quot;:0},&quot;expiration&quot;:{&quot;defaultTTL&quot;:10,&quot;isExpirable&quot;:true,&quot;type&quot;:1},&quot;serverNotification&quot;:{&quot;isEnabled&quot;:false}},&quot;secondaries&quot;:0},{&quot;name&quot;:&quot;NamedCache1&quot;,&quot;policy&quot;:{&quot;eviction&quot;:{&quot;type&quot;:-1},&quot;expiration&quot;:{&quot;defaultTTL&quot;:20,&quot;isExpirable&quot;:true,&quot;type&quot;:2},&quot;serverNotification&quot;:{&quot;isEnabled&quot;:true}},&quot;secondaries&quot;:1}]}" />
      <Setting name="Microsoft.WindowsAzure.Plugins.Caching.ClientDiagnosticLevel" value="1" />
      <Setting name="Microsoft.WindowsAzure.Plugins.Caching.DiagnosticLevel" value="1" />
      <Setting name="Microsoft.WindowsAzure.Plugins.Caching.CacheSizePercentage" value="30" />
      <Setting name="Microsoft.WindowsAzure.Plugins.Caching.ConfigStoreConnectionString" value="UseDevelopmentStorage=true" />
    </ConfigurationSettings>
  </Role>
</ServiceConfiguration>
"""

//let configTracker = PaaSUtils.Cscfg(xml)
//let config = configTracker.AmmendConfigForVNets("vnet", "subnet", "role")


/// Start Fuctions 
let settingCert fileName subscriptionId =
    let settings = PublishSettingsExtractor fileName
    settings.AddAllPublishSettingsCertificatesToPersonalMachineStore(subscriptionId).[0] 
let getFromBizsparkPlus = settingCert "D:\\Projects\\BizSpark Plus-7-8-2014-credentials.publishsettings"

let csconfig = """<ServiceConfiguration serviceName="azurecodermbrace" xmlns="http://schemas.microsoft.com/ServiceHosting/2008/10/ServiceConfiguration" osFamily="4" osVersion="*" schemaVersion="2014-06.2.4">
  <Role name="MBraceWorkerRole">
    <Instances count="1" />
    <ConfigurationSettings>
      <Setting name="StorageConnection" value="DefaultEndpointsProtocol=https;AccountName=clustered;AccountKey=3xsSRETv0iTPQfoIjeoTqyJ7v0UR74FS0XFJCCzJAy3q5QEElSUOimSo5cONnQPI/TeO5WZ8hDgSWFk8SW6uKQ==" />
      <Setting name="ServiceBusConnection" value="Endpoint=sb://isaactest.servicebus.windows.net/;SharedAccessKeyName=RootManageSharedAccessKey;SharedAccessKey=tXcgGrZMU5G1xGBcVgO2V3s+FJc2NN8tu+edRyX4ZLo=" />
    </ConfigurationSettings>
  </Role>
</ServiceConfiguration>"""
let subscriptionId = "84bf11d2-7751-4ce7-b22d-ac44bf33cbe9"
let submanager = new SubscriptionManager(subscriptionId)
let manager = submanager.GetDeploymentManager()

open System.Xml
open System.Xml.Linq

let xdoc = XDocument.Parse(csconfig)
let deployer = manager
                    .AddPublishSettingsFromFile("D:\\Projects\\BizSpark Plus-7-8-2014-credentials.publishsettings")
                    .ForNewDeployment("azurecodermbrace")
                    .SetCspkgEndpoint(new Uri("https://neelasta84bf11d277514ce7.blob.core.windows.net/packages/mbrace.cspkg"), xdoc)
                    .WithNewHostedService("azurecodermbrace")
                    .WithStorageAccount("clustered")
                    .AddEnvironment(DeploymentSlot.Production)
                    .AddLocation("North Europe")
                    .AddParams(Nullable DeploymentParams.StartImmediately)
                    .Go()
                    .Commit()
let client = new ServiceClient(subscriptionId, (getFromBizsparkPlus subscriptionId), "azurecodermbrace", DeploymentSlot.Production)
let status = client.GetRoleInstances()
                |> Seq.map(fun status -> status.Status)
let checker = submanager.GetRoleStatusChangedWatcher("azurecodermbrace", 
                                                     "MBraceWorkerRole", 
                                                     DeploymentSlot.Production, 
                                                     (getFromBizsparkPlus subscriptionId).Thumbprint)
checker.RoleStatusChangeHandler.Add(fun status -> printfn "from %s to %s" (status.OldState.ToString()) (status.NewState.ToString()))