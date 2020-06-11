namespace Autogen

open System
open System.Reflection
open System.Collections.Generic



module EntryPoint =
    
//public static List<AssemblyProcessorOutput>

    let ProcessAssembly(assembly:  Assembly) (output: AssemblyProcessorOutput list) =
         let processor = assembly.GetCustomAttribute<Attribs.BaseAssemblyProcessorAttribute>()

         if Autogen.Util.IsNull( processor)  then
            output
         else
         //Activation. processor.ProcessorType
             let baseProcessor = Activator.CreateInstance(processor.ProcessorType) :?> AssemblyProcessors.IProcessAssembly;
             let newOutput = baseProcessor.Process assembly
             newOutput @ output

    
        
        

    let ProcessAssemblies (assemblies: Assembly list) (output: AssemblyProcessorOutput list) = 
        if assemblies.IsEmpty then 
            output
        else
            let headAssembly = assemblies.Head
            let newOutput = ProcessAssembly headAssembly output
            //output
            newOutput
//            match processor with
//                |null ->
           // ProcessAssemblies assemblies.Tail newOutput
//         
//    let ProcessAssemblies  (assemblies : Assembly list) =
        
        //let returnObj = new List<AssemblyProcessorOutput>()
        //for assembly in Assemblies do
            //let processor = assembly.GetCustomAttribute<BaseAssemblyProcessorAttribute>
//            match processor with
//                |null -> 
//            if (processor != null)
//            {
//                var processed = processor.Processor.Process(assembly);
//                returnObj.AddRange(processed);
//            }
//        return returnObj;

