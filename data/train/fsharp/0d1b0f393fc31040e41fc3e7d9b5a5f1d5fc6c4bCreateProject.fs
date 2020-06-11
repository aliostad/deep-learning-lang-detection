namespace au.id.cxd.Math.Http

open System
open System.Web

open Handler
open Json
open AsyncHelper
open ProjectState

module CreateProject =

    /// list the names of existing projects
    let processRequest(context:HttpContext) =
        let respond = AsyncHelper.writeJsonToContext context
        let name = context.Request.["project"]
        match name with
        | null -> Json.makeError("Project name not provided") |> Json.toString |> respond
        | _ -> 
            let names = ProjectState.retrieveNames () |> Array.toList
            match (List.exists (fun (item:string) -> item.ToLower().Equals(name.ToLower())) names) with
            | true -> Json.makeError(String.Format("Project {0} already exists.", name)) |> Json.toString |> respond
            | _ -> 
                let result = ProjectState.create name
                Json.makeSuccess(String.Format("Created Project {0}", name)) |> Json.toString |> respond
                
        
/// list projects
type CreateProjectHandler() =
    inherit HandlerInstance(CreateProject.processRequest)
