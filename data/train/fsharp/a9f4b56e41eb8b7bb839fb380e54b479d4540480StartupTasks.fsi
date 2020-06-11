namespace Archient.Web.Http

/// F# Web API application startup tasks library
module StartupTasks = 
    (*
        ASP.NET has evolved quite substantially to the current 4.5.2 framework along with versions 
        5.1.2 of MVC and Web API.
        
        As a result, there are a variety of methods to get things done, including "the old way" 
        and "the new way" and everything in between.  The influence of many open-source libraries 
        has also 'pulled' the API in different directions.

        The next version "vNext" is set to clean things up a bit.
        
        One of the goals for the Archient libraries and guidance is to isolate you and your 
        applications from this change.  It's a lofty goal with a moving foundation, but we're 
        aiming high.
    *)

    open System
    open System.Web.Http
    
    /// Route defaults for a Web API route
    type ApiRouteDefaults = 
        { id : RouteParameter }
    
    /// <summary>Registers the default HTTP Routes</summary>
    /// <param name="controllerNamespaces">The controller namespaces.</param>
    val registerDefaultHttpRoutes : controllerNamespaces:seq<string> -> unit