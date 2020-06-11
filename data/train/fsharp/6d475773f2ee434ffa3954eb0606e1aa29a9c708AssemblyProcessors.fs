namespace Autogen

open System
open System.Reflection

module AssemblyProcessors =

    

    let rec ProcessTypes  (types: Type list) (output: AssemblyProcessorOutput list) : AssemblyProcessorOutput list =
        if types.IsEmpty then
            output
        else
            let tailProcessOutput = ProcessTypes types.Tail output
            let headType = types.Head
            let typeProcessorAttrib = headType.GetCustomAttribute<Attribs.BaseTypeProcessorAttribute>()
            if(Util.IsNull typeProcessorAttrib) then
                tailProcessOutput
            else
                let typeProcessor = typeProcessorAttrib.ProcessorType
                let typeProcessorImpl = Activator.CreateInstance(typeProcessor) :?> TypeProcessors.IProcessType
                let newOutput = typeProcessorImpl.Process headType
                newOutput @ tailProcessOutput

    type IProcessAssembly =
        abstract member Process: Assembly -> AssemblyProcessorOutput list

    type ProcessAllTypesProcessor =
        interface IProcessAssembly with
            member this.Process (assembly : Assembly) =
                let typesArray = assembly.GetTypes()
                let types = Autogen.Util.ArrayToList typesArray
                ProcessTypes types []
                       
         


