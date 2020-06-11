module Nightwatch.Tests.Resources.Shell

open System.Threading.Tasks

open FSharp.Control.Tasks
open Xunit

open Nightwatch.Core.Process
open Nightwatch.Resources

let private getChecker controller processName =
    let factory = Shell.factory controller

    let param = [| "cmd", processName |] |> Map.ofArray
    factory.create.Invoke param

[<Fact>]
let ``Shell Resource starts a process``() =
    let processName = "any.exe"

    let mutable startedCommand = None
    let mutable startedArgs = None
    let controller = { execute = fun name _ ->
        startedCommand <- Some name
        Task.FromResult 0 }
    let checker = getChecker controller processName
    task {
        let! result = checker.Invoke()
        Assert.Equal(processName, Option.get startedCommand)
    }

[<Fact>]
let ``Shell Resource returns success if process returns zero exit code``() =
    let controller = { execute = fun _ _ -> Task.FromResult 0 }
    let checker = getChecker controller ""
    task {
        let! result = checker.Invoke()
        Assert.True result
    }

[<Fact>]
let ``Shell Resource returns success if process returns nonzero exit code``() =
    let controller = { execute = fun _ _ -> Task.FromResult 1 }
    let checker = getChecker controller ""
    task {
        let! result = checker.Invoke()
        Assert.False result
    }
