namespace au.id.cxd.Math.Http

open System
open System.IO
open System.Web
open Handler
open AsyncHelper
open Json
open CookieHelper
open Filesystem
open DataState
open Newtonsoft.Json.Linq


module AssignData =

    /// assign the data to the project
    let processRequest(context:HttpContext) =
        let projectName = context.Request.["projectName"]
        let project = ProjectState.load projectName
        let save project = let (flag, path) = ProjectState.saveProject project
                           flag 
        let saveResult = DataState.assignWorkingFileToProject project save 
        match saveResult with
        | true ->
            Json.makeSuccess "Assigned data to project" |> Json.toString |> AsyncHelper.writeJsonToContext context
        | _ ->
            Json.makeError "Cannot assign to project" |> Json.toString |> AsyncHelper.writeJsonToContext context
        ()
        
            
/// list projects
type AssignDataHandler() =
    inherit HandlerInstance(AssignData.processRequest)

