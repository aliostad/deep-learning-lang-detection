module Nightwatch.Resources.Shell

open System
open System.Collections.Generic

open FSharp.Control.Tasks

open Nightwatch.Core
open Nightwatch.Core.Resources

let private create (processController : Process.Controller)
                   (param : IDictionary<string, string>) =
    let command = param.["cmd"]
    fun () -> task {
        let! code = processController.execute command [| |]
        return code = 0
    }

let factory(processController : Process.Controller) : ResourceFactory =
    Factory.create "shell" (create processController)
