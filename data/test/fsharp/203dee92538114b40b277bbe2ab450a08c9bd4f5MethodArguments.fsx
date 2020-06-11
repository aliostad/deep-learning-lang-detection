#light

#r "..\Build\Debug\Pencil.dll"

open System
open System.IO
open Pencil.Core

type CustomHandler(threshold:int) =
    inherit DefaultHandler()

    member x.InUserMethod =
        let m = x.Method
        let ignore = x.Type.IsGenerated || m.IsSpecialName || m.IsGenerated
        not ignore && m.DeclaringType = x.Type

    override x.BeginMethodCore() =
        let m = x.Method;
        if x.InUserMethod && m.Arguments.Count > threshold then
            Console.WriteLine("{1}.{2}({3}) found in {0}", x.Assembly.Name.Name, x.Type.Name, m.Name, m.Arguments.Count)

let IsAssembly fileName =
    let ext = Path.GetExtension(fileName)
    ext = ".dll" || ext = ".exe"

let read = AssemblyLoader.LoadFrom >> AssemblyReader(CustomHandler(4)).Read

Directory.GetFiles(".", "Cint.*.dll")
|> Seq.filter (fun x -> not(x.Contains("Test")))
|> Seq.filter IsAssembly
|> Seq.filter (fun x -> not (x.Contains("Test")))
|> Seq.iter read