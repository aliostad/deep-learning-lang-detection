namespace Org.Kevoree.Library

open Org.Kevoree.Core.Api.IMarshalled
open Org.Kevoree.Log.Api

(*
    La version java possède un wrapper factory
    On va essayer de faire sans en profitant des paradigme fonctionels de F#
*)
type RemoveInstanceCommand(c:IInstanceMarshalled, nodeName:string, registryManager:Org.Kevoree.Library.AdaptationType.RegistryManager, bs:Org.Kevoree.Core.Api.BootstrapService, modelService:Org.Kevoree.Core.Api.ModelService, logger:ILogger) =
    inherit System.MarshalByRefObject()
    interface Org.Kevoree.Core.Api.Command.ICommand with
        member this.Execute() = 
            logger.Debug("Execute RemoveInstance")
            let path = c.path()
            if registryManager.Lookup path
            then
                registryManager.RemoveFromRegistry path
                true
            else false
        member this.Undo() = 
            logger.Debug("Undo RemoveInstance")
            let path = c.path()
            if registryManager.Lookup path
            then ()
            else
                let _ = (new AddInstanceCommand(c, nodeName, registryManager, bs, modelService, logger) :> Org.Kevoree.Core.Api.Command.ICommand ).Execute()
                ()
        member this.Name() = sprintf "[RemoveInstance nodeName=%s]" nodeName