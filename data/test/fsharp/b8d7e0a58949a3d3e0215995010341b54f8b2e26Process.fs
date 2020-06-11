module Nightwatch.Tests.Core.Process

open System

open FSharp.Control.Tasks
open Xunit

open Nightwatch.Core

let executableName =
    match Environment.OSVersion.Platform with
    | PlatformID.Win32NT -> "dotnet.exe"
    | PlatformID.Unix | PlatformID.MacOSX -> "dotnet"
    | other -> failwithf "Platform %A is not supported for current test" other

let controller = Process.system

[<Fact>]
let ``Process.start should start a new process``() =
    task {
        let! code = controller.execute executableName [| "--help" |]
        Assert.Equal(0, code)
    }
