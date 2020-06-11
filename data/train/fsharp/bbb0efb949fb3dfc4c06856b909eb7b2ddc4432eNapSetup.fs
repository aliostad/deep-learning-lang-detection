namespace Nap

open System
open System.Net
open System.Net.Http
open Nap.Plugins.Base

type INapSetup =
    abstract member Plugins : IPlugin list
    abstract member InstallPlugin<'T when 'T :> IPlugin and 'T : (new : unit -> 'T)> : unit -> INapSetup
    abstract member InstallPlugin : IPlugin -> INapSetup
    abstract member UninstallPlugin<'T when 'T :> IPlugin and 'T : (new : unit -> 'T)> : unit -> INapSetup
    abstract member UninstallPlugin : IPlugin -> INapSetup

[<Sealed>]
type NapSetup private(plugins : IPlugin list) =
    new() = NapSetup([])
    member val ClientCreator =
        fun (request:NapRequest) ->
            let handler = new HttpClientHandler()
            match request.Config.Advanced.Proxy with
            | Some(proxy) -> () // TODO: Add proxy
            | None -> ()
            for (uri,cookie) in request.Cookies do
                handler.CookieContainer.Add(uri, cookie)
            new HttpClient(handler)
        with get, set
    static member val internal Empty = new NapSetup()
    interface INapSetup with
        member val Plugins = plugins
        member x.InstallPlugin<'T when 'T :> IPlugin and 'T : (new : unit -> 'T)> () =
            new 'T() :> IPlugin |> (x :> INapSetup).InstallPlugin
        member x.InstallPlugin plugin =
            upcast new NapSetup ((x :> INapSetup).Plugins |> List.append [plugin])
        member x.UninstallPlugin<'T when 'T :> IPlugin and 'T : (new : unit -> 'T)> () =
            let pluginToRemove = (x :> INapSetup).Plugins |> Seq.tryFind (fun p -> p :? 'T)
            match pluginToRemove with
            | Some(p) -> (x :> INapSetup).UninstallPlugin(p)
            | None -> upcast x
        member x.UninstallPlugin plugin =
            upcast new NapSetup ((x :> INapSetup).Plugins |> List.filter (fun p -> p <> plugin))

