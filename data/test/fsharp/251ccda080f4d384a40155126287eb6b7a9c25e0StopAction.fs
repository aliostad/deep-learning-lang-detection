namespace LauncherFs

open Newtonsoft.Json
open Newtonsoft.Json.Converters
open System.Runtime.Serialization
[<DataContract>]
type StopAction =
      // Do nothing. This process is supposed to run and exit
    | [<EnumMember>][<JsonProperty("nothing")>] Nothing = 0
      // Relaunch. This process is supposed to be always running. In the event of a stop then try to relaunch it
    | [<EnumMember>][<JsonProperty("relaunch")>] Relaunch = 1
      // Halt. If this process fails then fail the whole application along with other processes
    | [<EnumMember>][<JsonProperty("halt")>] Halt = 2
    