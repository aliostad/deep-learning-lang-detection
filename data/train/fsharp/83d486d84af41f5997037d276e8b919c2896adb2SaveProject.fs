namespace au.id.cxd.Math.Http

open System
open System.Web

open Handler
open Json
open AsyncHelper
open ProjectState

module SaveProject =

    /// save the current project that is in the state
    let processRequest(context:HttpContext) =
        let respond = AsyncHelper.writeJsonToContext context
        let project = ProjectState.currentProject ()
        match project with 
        | None ->
            Json.makeError("There is no current project loaded.") |> Json.toString |> respond
        | Some item ->
            let project = ProjectState.saveCurrentProject ()
            match project with
            | None -> Json.makeError("Could not save the current project.") |> Json.toString |> respond
            | Some item ->
                let name = item.ProjectName
                Json.makeSuccess(String.Format("Created Project {0}", name)) |> Json.toString |> respond
                
        
/// save current projects
type SaveProjectHandler() =
    inherit HandlerInstance(SaveProject.processRequest)

