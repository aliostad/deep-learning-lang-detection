namespace Org.Kevoree.Library

open Org.Kevoree.Core.Api.IMarshalled
open Org.Kevoree.Log.Api

type UpdateDictionaryCommand(c:IInstanceMarshalled, dicValue:IValueMarshalled, nodeName:string, registryManager:Org.Kevoree.Library.AdaptationType.RegistryManager, bs:Org.Kevoree.Core.Api.BootstrapService, modelService:Org.Kevoree.Core.Api.ModelService, logger:ILogger) =
    inherit System.MarshalByRefObject()
    interface Org.Kevoree.Core.Api.Command.ICommand with
        member this.Execute() =
            logger.Debug("Execute UpdateDictionary")
            let path = c.path()
            let lookup = registryManager.Lookup(path)
            if lookup then
                let attributeDefinition = dicValue.eContainer().eContainer().CastToInstance().GetTypeDefinition().getDictionaryType().findAttributesByID(dicValue.getName())
                if typedefof<Org.Kevoree.Core.Api.IRunner>.IsAssignableFrom(registryManager.QueryRegistry(path).GetType()) then
                    let componentz = registryManager.QueryRegistry(path) :?> Org.Kevoree.Core.Api.IRunner
                    let _ = componentz.updateDictionary(attributeDefinition, dicValue)
                    ()
                else
                    let componentz:Org.Kevoree.Core.Api.NodeType = registryManager.QueryRegistry(path) :?> Org.Kevoree.Core.Api.NodeType
                    let injector:Org.Kevoree.Library.Annotation.KevoreeInjector<Org.Kevoree.Annotation.Param> = new Org.Kevoree.Library.Annotation.KevoreeInjector<Org.Kevoree.Annotation.Param>();
                    let _ = injector.smartInject(componentz, attributeDefinition.getName(), attributeDefinition.getDatatype(), dicValue.getValue())
                    ()
                    
                true
            else true
        member this.Undo() = 
            logger.Debug("Undo UpdateDictionay")
            ()
        member this.Name() = sprintf "[UpdateDictionnary nodeName=%s]" nodeName