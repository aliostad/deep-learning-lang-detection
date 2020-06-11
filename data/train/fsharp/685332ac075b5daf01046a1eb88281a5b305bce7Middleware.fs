module Juraff.Middleware

open System
open System.Threading.Tasks
open Microsoft.AspNetCore.Builder
open Microsoft.AspNetCore.Http
open Microsoft.AspNetCore.Hosting
open Microsoft.Extensions.Logging
open Microsoft.Extensions.DependencyInjection
open Microsoft.Extensions.FileProviders
open Juraff.HttpHandlers

/// ---------------------------
/// Default middleware
/// ---------------------------

type GiraffeMiddleware (next          : RequestDelegate,
                        handler       : HttpHandler,
                        loggerFactory : ILoggerFactory) =

    // pre-compile the handler pipeline
    let func : HttpFunc = handler (Some >> Task.FromResult)

    member __.Invoke (ctx : HttpContext) =
        task {
            let! result = func ctx
            if (result.IsNone) then
                return! next.Invoke ctx
        } :> Task

/// ---------------------------
/// Extension methods for convenience
/// ---------------------------

type IApplicationBuilder with
    member this.UseGiraffe (handler : HttpHandler) =
        this.UseMiddleware<GiraffeMiddleware> handler
        |> ignore