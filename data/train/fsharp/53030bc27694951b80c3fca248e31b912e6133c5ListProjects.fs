namespace au.id.cxd.Math.Http

open System
open System.Web
open Newtonsoft.Json.Linq

open Handler
open Json
open AsyncHelper
open ProjectState

module ListProjects =

    /// list the names of existing projects
    let processRequest(context:HttpContext) =
        let names = ProjectState.retrieveNames () |> Array.toList
        let json = Json.stringListToJson names
        json :> JToken |> Json.makeSuccessObject "projects" |> toString |> AsyncHelper.writeJsonToContext context 
        
/// list projects
type ListProjectHandler() =
    inherit HandlerInstance(ListProjects.processRequest)