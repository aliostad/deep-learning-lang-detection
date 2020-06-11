namespace NPackage.Core

open System
open System.Collections.Generic

type Package() =
    let mutable name = String.Empty
    let mutable version = String.Empty
    let mutable description = String.Empty
    let mutable author = String.Empty
    let mutable maintainer = String.Empty
    let mutable copyLocal = false
    let masterSites = new ResizeArray<string>()
    let requires = new ResizeArray<string>()
    let libraries = new SortedDictionary<string, Library>(StringComparer.InvariantCultureIgnoreCase)

    member this.Name
        with get() = name
        and set(value) = name <- value

    member this.Version
        with get() = version
        and set(value) = version <- value

    member this.Description
        with get() = description
        and set(value) = description <- value

    member this.Author
        with get() = author
        and set(value) = author <- value

    member this.Maintainer
        with get() = maintainer
        and set(value) = maintainer <- value

    member this.CopyLocal
        with get() = copyLocal
        and set(value) = copyLocal <- value

    member this.MasterSites = masterSites :> IList<string>
    member this.Requires = requires :> IList<string>
    member this.Libraries = libraries :> IDictionary<string, Library>