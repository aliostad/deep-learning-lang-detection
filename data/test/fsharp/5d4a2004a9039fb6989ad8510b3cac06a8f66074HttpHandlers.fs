module Juraff.HttpHandlers

open System
open System.Text
open System.Collections.Generic
open System.Threading.Tasks
open Microsoft.AspNetCore.Http
open Microsoft.AspNetCore.Hosting
open Microsoft.Extensions.Primitives
open Microsoft.Extensions.Logging
open Microsoft.Extensions.DependencyInjection
open FSharp.Core.Printf
open Juraff.Common
open System.Text.RegularExpressions
open Newtonsoft.Json.Linq
open Juraff.Tasks

type HttpFuncResult = Task<HttpContext option>
type HttpFunc       = HttpContext -> HttpFuncResult
type HttpHandler    = HttpFunc  -> HttpFunc
type ErrorHandler   = exn -> ILogger -> HttpHandler

/// ---------------------------
/// Globally useful functions
/// ---------------------------

let inline warbler f a = f a a

let shortCircuit : HttpFuncResult = Task.FromResult None

/// ---------------------------
/// Default HttpHandlers
/// ---------------------------

/// Combines two HttpHandler functions into one.
let compose (handler1 : HttpHandler) (handler2 : HttpHandler) : HttpHandler =
    fun (next : HttpFunc) ->
        let func = next |> handler2 |> handler1
        fun (ctx : HttpContext) ->
            match ctx.Response.HasStarted with
            | true  -> next ctx
            | false -> func ctx

/// Combines two HttpHandler functions into one.
/// See compose for more information.
let (>=>) = compose

// Allows a pre-complied list of HttpFuncs to be tested,
// by pre-applying next to handler list passed from choose
let rec private chooseHttpFunc (funcs : HttpFunc list) : HttpFunc =
    fun (ctx : HttpContext) ->
        task {
            match funcs with
            | [] -> return None
            | func :: tail ->
                let! result = func ctx
                match result with
                | Some c -> return Some c
                | None   -> return! chooseHttpFunc tail ctx
        }

/// Iterates through a list of HttpHandler functions and returns the
/// result of the first HttpHandler which outcome is Some HttpContext
let choose (handlers : HttpHandler list) : HttpHandler =
    fun (next : HttpFunc) ->
        let funcs = handlers |> List.map (fun h -> h next)
        fun (ctx : HttpContext) ->
            chooseHttpFunc funcs ctx

/// Filters an incoming HTTP request based on the HTTP verb
let httpVerb (verb : string) : HttpHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        if ctx.Request.Method.Equals verb
        then next ctx
        else shortCircuit

let GET    : HttpHandler = httpVerb "GET"
let POST   : HttpHandler = httpVerb "POST"


/// Sets the HTTP response status code.
let setStatusCode (statusCode : int) : HttpHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        ctx.Response.StatusCode <- statusCode
        next ctx

/// Sets a HTTP header in the HTTP response.
let setHttpHeader (key : string) (value : obj) : HttpHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        ctx.Response.Headers.[key] <- StringValues(value.ToString())
        next ctx

/// Writes to the body of the HTTP response and sets the HTTP header Content-Length accordingly.
let setBody (bytes : byte array) : HttpHandler =
    fun (next : HttpFunc) (ctx : HttpContext) ->
        task {
            ctx.Response.Headers.["Content-Length"] <- StringValues(bytes.Length.ToString())
            do! ctx.Response.Body.WriteAsync(bytes, 0, bytes.Length)
            return! next ctx
        }

/// Writes a string to the body of the HTTP response and sets the HTTP header Content-Length accordingly.
let setBodyAsString (str : string) : HttpHandler =
    Encoding.UTF8.GetBytes str
    |> setBody