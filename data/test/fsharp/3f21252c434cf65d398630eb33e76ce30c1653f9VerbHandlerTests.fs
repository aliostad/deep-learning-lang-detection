namespace Nomad.UnitTests

open System
open Xunit
open FsCheck
open Nomad
open Nomad.Routing
open Nomad.Verbs
open FsCheck.Xunit
open Microsoft.AspNetCore.Http
open HttpHandler

type VerbHandlerTests() =
    [<Property(MaxTest = 1)>]
    member this.``Given an HTTP GET request, the "Get"" verb handler is executed`` () =
        let context = DefaultHttpContext()
        context.Request.Method <- "GET"
        let result =
            {defaultVerbs with Get = return' 1}
            |> handleVerbs
            |> HttpHandler.Unsafe.runHandler context
        result = (Continue 1)

    [<Property(MaxTest = 1)>]
    member this.``Given an HTTP POST request, the "Post"" verb handler is executed`` () =
        let context = DefaultHttpContext()
        context.Request.Method <- "POST"
        let result =
            {defaultVerbs with Post = return' 1}
            |> handleVerbs
            |> HttpHandler.Unsafe.runHandler context
        result = (Continue 1)

    [<Property(MaxTest = 1)>]
    member this.``Given an HTTP PUT request, the "Put"" verb handler is executed`` () =
        let context = DefaultHttpContext()
        context.Request.Method <- "PUT"
        let result =
            {defaultVerbs with Put = return' 1}
            |> handleVerbs
            |> HttpHandler.Unsafe.runHandler context
        result = (Continue 1)

    [<Property(MaxTest = 1)>]
    member this.``Given an HTTP PATCH request, the "Patch"" verb handler is executed`` () =
        let context = DefaultHttpContext()
        context.Request.Method <- "PATCH"
        let result =
            {defaultVerbs with Patch = return' 1}
            |> handleVerbs
            |> HttpHandler.Unsafe.runHandler context
        result = (Continue 1)

    [<Property(MaxTest = 1)>]
    member this.``Given an HTTP DELETE request, the "Delete"" verb handler is executed`` () =
        let context = DefaultHttpContext()
        context.Request.Method <- "DELETE"
        let result =
            {defaultVerbs with Delete = return' 1}
            |> handleVerbs
            |> HttpHandler.Unsafe.runHandler context
        result = (Continue 1)


