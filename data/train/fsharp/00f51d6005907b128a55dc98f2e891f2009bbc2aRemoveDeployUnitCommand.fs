namespace Org.Kevoree.Library

open Org.Kevoree.Core.Api.IMarshalled
open Org.Kevoree.Log.Api

type RemoveDeployUnitCommand(c:IDeployUnitMarshalled, bs:Org.Kevoree.Core.Api.BootstrapService, logger:ILogger) =
    inherit System.MarshalByRefObject()
    interface Org.Kevoree.Core.Api.Command.ICommand with
        member this.Execute() = 
            logger.Debug("Execute RemoveDeployUnit")
            false
        member this.Undo() = 
            logger.Debug("Undo DeployUnit")
            ()
        member this.Name() = sprintf "[RemoveDeployUnit]"