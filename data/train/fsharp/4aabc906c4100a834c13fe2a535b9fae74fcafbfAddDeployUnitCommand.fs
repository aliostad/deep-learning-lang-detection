namespace Org.Kevoree.Library

open Org.Kevoree.Core.Api.IMarshalled
open Org.Kevoree.Log.Api

type AddDeployUnitCommand(c:IDeployUnitMarshalled, bs:Org.Kevoree.Core.Api.BootstrapService, logger:ILogger)  =
    inherit System.MarshalByRefObject()
    interface Org.Kevoree.Core.Api.Command.ICommand with
        member this.Execute() = 
            logger.Debug("Execute AddDeployUnit")
            false
        member this.Undo() = 
            logger.Debug("Undo AddDeployUnit")
            ()
        member this.Name() = sprintf "[AddDeployUnit]"