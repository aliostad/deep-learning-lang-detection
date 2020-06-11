namespace LauncherFs

open Newtonsoft.Json
open Newtonsoft.Json.Converters
open System.Runtime.Serialization

[<DataContract>]
[<AllowNullLiteral>]
type StopConfig() =
  /// <summary>How to stop the process</summary>
  [<JsonConverter(typeof<StringEnumConverter>)>]
  [<DataMember>][<JsonProperty("stopMethod")>] member val StopMethod: LauncherFs.StopMethod = Unchecked.defaultof<LauncherFs.StopMethod> with get, set
  /// <summary>Process to run if stopMethod is "command"</summary>
  [<DataMember>][<JsonProperty("stopProcess")>] member val StopProcess: LauncherFs.ProcessLaunchArguments = null with get, set
  /// <summary>What to do if the process stops</summary>
  [<JsonConverter(typeof<StringEnumConverter>)>]
  [<DataMember>][<JsonProperty("onStopAction")>] member val OnStopAction: LauncherFs.StopAction = Unchecked.defaultof<LauncherFs.StopAction> with get, set
  /// <summary>Relaunch time threshold. If the process halts before this amount of milliseconds then halt the application, otherwise relaunch</summary>
  [<DataMember>][<JsonProperty("relaunchTimeThreshold")>] member val RelaunchTimeThreshold: int = 0 with get, set
