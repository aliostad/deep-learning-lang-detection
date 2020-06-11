module NPackage.Server.CustomRouteHandler

open System
open System.Web
open System.Web.Compilation
open System.Web.Routing
open System.Web.UI
open Microsoft.FSharp.Reflection

type CustomRouteHandler<'Route, 'Handler when 'Handler :> IHttpHandler>(makeHandler : 'Route -> 'Handler) =
    let parseRoute =
        let fieldNames = FSharpType.GetRecordFields typeof<'Route>
                         |> Array.map (fun i -> i.Name)

        let ctor = FSharpValue.PreComputeRecordConstructor typeof<'Route>
        fun (data : RouteData) -> 
            fieldNames
            |> Array.map (fun name -> data.Values.[name])
            |> ctor
            |> unbox<'Route>
            |> makeHandler

    interface IRouteHandler with
        member this.GetHttpHandler context =
            context.RouteData
            |> parseRoute
            |> unbox<IHttpHandler>

let create<'Route, 'Handler when 'Handler :> IHttpHandler> (f : 'Route -> 'Handler) =
    new CustomRouteHandler<'Route, 'Handler>(f)
