namespace au.id.cxd.Math.Http

open System
open System.Web
open Newtonsoft.Json.Linq

open Handler
open Json
open AsyncHelper
open ProjectState

module DeleteProject =

    /// delete existing projects
    let processRequest(context:HttpContext) =
        let name = context.Request.["project"]
        match String.IsNullOrEmpty(name) with 
        | true -> Json.makeError "Project name was not supplied" |> toString |> AsyncHelper.writeJsonToContext context
        | _ ->
            try 
                ProjectState.delete name
                Json.makeSuccess (String.Format("Deleted project {0}", name))
                |> toString
                |> AsyncHelper.writeJsonToContext context
            with 
            | e -> 
                Json.makeError (String.Format("Failed to delete project. {0}", e.Message)) 
                |> toString
                |> AsyncHelper.writeJsonToContext context
                
/// delete projects
type DeleteProjectHandler() =
    inherit HandlerInstance(DeleteProject.processRequest)
