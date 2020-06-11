namespace Deep.Routing

open Deep
open System
open System.Net
open Microsoft.FSharp.Reflection

type Routes() =

    static let objToHandler : obj -> _ = function
    | :? IRouteHandler as h -> h
    | h when FSharpType.IsFunction <| h.GetType() -> FunctionRouteHandler(h) :> IRouteHandler
    | :? MvcDefaults -> MvcRouteHandler() :> IRouteHandler
    | _ -> failwith "Invalid route handler"

    static let objToDefaults : obj -> _ = function
    | :? MvcDefaults as d ->
        Map [
            MvcKeys.Controller, d.Controller
            MvcKeys.Action, d.Action
            MvcKeys.Id, d.Id
        ]
    | _ -> Map.empty

    static member AddRoute (route : route) (routes : routes) =
        routes @ [route]

    static member private AddBase(routes, httpMethod, pattern, handler, priority, filter) =
        routes
        |> Routes.AddRoute
            {
                HttpMethod = httpMethod
                Pattern = pattern
                Handler = handler |> objToHandler
                Priority = defaultArg priority 0
                Filter = filter
                Defaults = handler |> objToDefaults
            }

    static member Add(routes, httpMethod, pattern, handler, ?priority, ?filter) =
        Routes.AddBase(routes, httpMethod, pattern, handler, priority, filter)

    static member Any(routes, pattern, handler, ?priority, ?filter) =
        Routes.AddBase(routes, HttpMethods.Any, pattern, handler, priority, filter)

    static member Get(routes, pattern, handler, ?priority, ?filter) =
        Routes.AddBase(routes, HttpMethods.Get, pattern, handler, priority, filter)

    static member Post(routes, pattern, handler, ?priority, ?filter) =
        Routes.AddBase(routes, HttpMethods.Post, pattern, handler, priority, filter)

    static member Put(routes, pattern, handler, ?priority, ?filter) =
        Routes.AddBase(routes, HttpMethods.Put, pattern, handler, priority, filter)

    static member Delete(routes, pattern, handler, ?priority, ?filter) =
        Routes.AddBase(routes, HttpMethods.Delete, pattern, handler, priority, filter)