namespace Autogen

open System
open System.Reflection

module TypeProcessors =


    type IProcessType =
        abstract member Process: Type -> AssemblyProcessorOutput list

    let processType (typ:  Type) (processors: IProcessType list) (output: AssemblyProcessorOutput list) =
        if processors.IsEmpty then
            output
        else
            let headProcessor = processors.Head
            let processed = headProcessor.Process typ
            processed @ output
    
    type TypeMultipleProcessor(processors: IProcessType list) =
        interface IProcessType with
            member this.Process(typ: Type) =
                processType typ processors []

    
    let CreateTypeRepresentation (typ: Type) : ClassifiedType =
        if typ.IsInterface then
            let interf = InterfaceInfoEx typ
            Interface (interf) 
        else
            let typeInfoEx = TypeInfoEx typ
            Class (typeInfoEx)

    
        


    type TypescriptProcessor =
        interface IProcessType with
            member this.Process(typ: Type) =
                let classifiedType = CreateTypeRepresentation typ
                []
//                match classifiedType with
//                    |Interface (interfaceEx) -> 
//                        
    
        