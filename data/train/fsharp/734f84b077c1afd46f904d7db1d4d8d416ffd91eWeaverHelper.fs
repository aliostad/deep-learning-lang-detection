namespace global
open System
open System.IO
open System.Collections.Generic
open System.Linq
open System.Reflection
open Mono.Cecil
open NUnit.Framework
open Binding.Fody

module WeaverHelper =

    let WeaveAssembly()  =
        let projectPath = Path.GetFullPath(Path.Combine(Environment.CurrentDirectory, @"..\..\..\AssemblyToProcess\AssemblyToProcess.nproj"))
        let assemblyPath = Path.Combine(Path.GetDirectoryName(projectPath), @"bin\Debug\AssemblyToProcess.dll")
        #if DEBUG
        #else
        assemblyPath = assemblyPath.Replace("Debug", "Release")
        #endif
        let newAssembly = assemblyPath.Replace(".dll", "2.dll")
        File.Copy(assemblyPath, newAssembly, true)

        let moduleDefinition = ModuleDefinition.ReadModule(newAssembly)
        let weavingTask = new ModuleWeaver(ModuleDefinition = moduleDefinition)
        weavingTask.Execute
        moduleDefinition.Write(newAssembly)
        Assembly.LoadFile(newAssembly)

