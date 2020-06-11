
module NBlast.Api.Console

open System
open Microsoft.Owin.Hosting
open NBlast.Storage.Core
open Topshelf
open Topshelf.HostConfigurators
open Topshelf.ServiceConfigurators

type BackgroundJob() =
    static let configReader = new ConfigReader() :> IConfigReader
    let _url = "NBlast.api.url" |> configReader.Read
    let _context = lazy(WebApp.Start<WebApiStarter>(_url))
    static let logger = NLog.LogManager.GetCurrentClassLogger()

    do
        "Job initialization finished" |> logger.Debug

    interface ServiceControl with
        member this.Start hc = _context.Value |> ignore; true
        member this.Stop hc  = _context.Value.Dispose(); true
        

//let logger = NLog.LogManager.GetCurrentClassLogger()

[<EntryPoint>]
let main args =

    let service (conf : HostConfigurator) (fac : (unit -> 'a)) =
        let service' = conf.Service : Func<_> -> HostConfigurator
        service' (new Func<_>(fac)) |> ignore
    
    HostFactory.Run(
        fun conf -> 
            conf.Service<_>(new Func<_>(fun sv -> new BackgroundJob())) |> ignore
            conf.SetDisplayName("NBlast Web Api hoster")
            conf.SetServiceName("NBlast.WebApi.Hoster")
            conf.RunAsLocalService() |> ignore

    ) |> ignore
    0