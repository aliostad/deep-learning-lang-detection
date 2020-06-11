namespace Deep.Routing

open Deep
open System
open System.Net

type IRouteHandler =
    abstract InvokeAction : container : IKernel -> Async<unit>

module internal RouteHandlerResult =

    let toAsync : obj -> _ = function
    | :? Async<unit> as asyncResult -> asyncResult
    | _ -> async { () }

type FunctionRouteHandler(func : obj) =
    interface IRouteHandler with
        override h.InvokeAction(container : IKernel) =
            func
            |> Function.invoke container
            |> RouteHandlerResult.toAsync

type RouteParams = Map<string, string>
type RouteDefaults = Map<string, string>
type RouteParamFilter = RouteParams -> RouteParams

type route =
    {
        HttpMethod : string
        Pattern : string
        Handler : IRouteHandler
        Priority : int
        Filter : RouteParamFilter option
        Defaults : RouteDefaults
    }

type routes = route list

type RouteMatchResult =
    {
        Handler: IRouteHandler
        Parameters: RouteParams
    }

type IRouteBuilder =
    abstract Routes : routes

type SimpleRouteBuilder(builder : routes -> routes) =
    let routes = [] |> builder
    interface IRouteBuilder with
        override b.Routes = routes