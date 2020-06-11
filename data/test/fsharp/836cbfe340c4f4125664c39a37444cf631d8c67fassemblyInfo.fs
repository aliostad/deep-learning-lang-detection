namespace System
open System.Reflection
open System.Runtime.CompilerServices

[<assembly: AssemblyTitleAttribute("Immu.Storage")>]
[<assembly: AssemblyProductAttribute("immu-storage")>]
[<assembly: AssemblyDescriptionAttribute("Immutable Copy-On-Write Storage")>]
[<assembly: AssemblyVersionAttribute("0.0.1")>]
[<assembly: AssemblyFileVersionAttribute("0.0.1")>]
[<assembly: InternalsVisibleToAttribute("Immu.Storage.Test")>]
do ()

module internal AssemblyVersionInformation =
    let [<Literal>] Version = "0.0.1"
    let [<Literal>] InformationalVersion = "0.0.1"
