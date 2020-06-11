namespace Org.Kevoree.Library

open Org.Kevoree.Core.Api.IMarshalled
open Org.Kevoree.Log.Api

type StartStopInstanceCommand(c:IInstanceMarshalled, nodeName:string, start:bool,  registryManager:Org.Kevoree.Library.AdaptationType.RegistryManager, bs:Org.Kevoree.Core.Api.BootstrapService, logger:ILogger) =
    inherit System.MarshalByRefObject()
    interface Org.Kevoree.Core.Api.Command.ICommand with
        member this.Execute() = 
            if registryManager.Lookup(c.path()) then
                logger.Debug(sprintf "Execute StartStopInstance start=%b %s" start (c.path()))
                let target = registryManager.QueryRegistry(c.path()) :?> Org.Kevoree.Core.Api.IComponentRunner
                if target <> null then
                    if start then target.Run() else target.Stop();
                else false
            else true
            
        member this.Undo() =
            logger.Debug(sprintf "Undo StartStop start=%b" start)
            ()
        member this.Name() = sprintf "[StartStopInstance start=%b nodeName=%s]" start nodeName