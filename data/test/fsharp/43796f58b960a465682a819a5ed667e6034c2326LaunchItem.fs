namespace LauncherFs

open Newtonsoft.Json
open Newtonsoft.Json.Converters
open System.Runtime.Serialization

[<DataContract>]
[<AllowNullLiteral>]
type LaunchItem() =
  /// <summary>Description</summary>
  [<DataMember>][<JsonProperty("description")>] member val Description: string = null with get, set
  /// <summary>Enables or Disables items</summary>
  [<JsonConverter(typeof<StringEnumConverter>)>]
  [<DataMember>][<JsonProperty("status")>] member val Status: LauncherFs.ItemStatus = Unchecked.defaultof<LauncherFs.ItemStatus> with get, set
  /// <summary>Sets how process instances will run</summary>
  [<JsonConverter(typeof<StringEnumConverter>)>]
  [<DataMember>][<JsonProperty("instanceConfig")>] member val InstanceConfig: LauncherFs.InstancesConfig = Unchecked.defaultof<LauncherFs.InstancesConfig> with get, set
  /// <summary>When instanceConfig is set to "fixed" this value sets how many instances of this process should run</summary>
  [<DataMember>][<JsonProperty("fixedInstanceAmount")>] member val FixedInstanceAmount: int = 0 with get, set
  /// <summary>Process to run</summary>
  [<DataMember>][<JsonProperty("startProcess")>] member val StartProcess: LauncherFs.ProcessLaunchArguments = null with get, set
  /// <summary>Configures how to stop and what to do when it does</summary>
  [<DataMember>][<JsonProperty("stopConfig")>] member val StopConfig: LauncherFs.StopConfig = null with get, set
  /// <summary>Processes that should execute after this one has successfully executed</summary>
  [<DataMember>][<JsonProperty("dependents")>] member val Dependents: LaunchItem list = [] with get, set
