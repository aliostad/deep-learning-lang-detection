// Learn more about F# at http://fsharp.org

open System
open Suave
open TodoApi.Controllers
open TodoApi.Controllers.Controller
open TodoApi.Models
open TodoApi.Models.TodoRepositoryDb
open TodoApi.Utils

[<EntryPoint>]
let main argv =

    let item = {
        Key=""
        Name="My Item 1"
        IsComplete = false
    }
    let result = todoRepositoryDb.Add item

    let item2 = {
        Key=""
        Name = "My Item 2"
        IsComplete = false
    }
    let result = todoRepositoryDb.Add item2

    // Change the http binding to be the IIS setting if
    // hosting behind IIS otherwise just use the defaults
    let config = defaultConfig
    let config =
        match IISHelpers.httpPlatformPort with
        | Some port ->
            { config with
                bindings = [ HttpBinding.createSimple  HTTP "127.0.0.1" port ] }
        | None -> config

    startWebServer config ( TodoController.todoController todoRepositoryDb )
    0 // return an integer exit code
