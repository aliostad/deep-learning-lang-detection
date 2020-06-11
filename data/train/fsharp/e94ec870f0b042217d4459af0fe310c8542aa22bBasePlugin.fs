namespace Nap.Plugins.Base
open Nap

[<AbstractClass>]
type BasePlugin() =
    abstract member Configure : NapConfig -> NapConfig
    default x.Configure config = (x :> IPlugin).Configure config
    abstract member Prepare : NapRequest -> NapRequest
    default x.Prepare request = (x :> IPlugin).Prepare request
    abstract member Execute<'T when 'T : not struct> : NapRequest -> 'T
    default x.Execute<'T when 'T : not struct> request = (x :> IPlugin).Execute<'T> request
    abstract member Process : NapResponse -> NapResponse
    default x.Process response = (x :> IPlugin).Process response
    interface IPlugin with
        member x.Configure config = config
        member x.Prepare request = request
        member x.Execute<'T when 'T : not struct> request = Unchecked.defaultof<'T>
        member x.Process response = response