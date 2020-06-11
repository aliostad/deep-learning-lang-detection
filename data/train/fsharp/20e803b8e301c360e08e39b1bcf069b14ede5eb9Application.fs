namespace NPackage.Server

open System.Web
open System.Web.Routing
open Microsoft.FSharp.Reflection

module Application =
    let addRoute<'Route, 'Handler when 'Handler :> IHttpHandler> url (makeHandler : 'Route -> 'Handler) (defaults : 'Route) (routes : RouteCollection) =
        routes.Add(new Route(url, new RouteValueDictionary(defaults), CustomRouteHandler.create makeHandler))
        routes

    let registerRoutes =
        addRoute "admin/{Action}"                   (fun route -> new AdminHandler(route))   { Action = "" } >>
        addRoute "packages"                         (fun route -> new PackageHandler(route)) { PackageName = ""; Action = "list" } >>
        addRoute "packages/{PackageName}/{Action}"  (fun route -> new PackageHandler(route)) { PackageName = ""; Action = "get" }

type ApplicationType() =
    inherit HttpApplication()

    member this.Application_Start() =
        ignore (Application.registerRoutes RouteTable.Routes)
