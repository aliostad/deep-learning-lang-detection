namespace Tododo.Managing.Api

open System
open System.Net
open System.Net.Http
open System.Web.Http
open Tododo.Managing.Errors
open Tododo.Shared.ROP

[<RoutePrefix("api/employees")>]
type EmployeesController
    (
        insertEmployeeImp : EmployeeModel -> Result<unit, Error>
    ) = 
    inherit ApiController()
    
    [<Route("")>]
    member x.Get() = 
        x.Request.CreateResponse(HttpStatusCode.OK, "test all employees")

    [<Route("{id:guid}")>]
    member x.Get(id: Guid) = 
        x.Request.CreateResponse(HttpStatusCode.OK, "test employee")

    [<Route("")>]
    member x.Put(appointment: EmployeeModel) =
        match insertEmployeeImp appointment with 
        | Failure(ValidationError msg) -> x.BadRequest msg :> IHttpActionResult
        | _ -> x.StatusCode HttpStatusCode.Accepted :> IHttpActionResult 

