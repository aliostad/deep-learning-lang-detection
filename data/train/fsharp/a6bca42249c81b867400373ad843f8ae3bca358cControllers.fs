namespace Tododo.Scheduling.Api

open System
open System.Net
open System.Net.Http
open System.Web.Http
open Tododo.Scheduling.Domain
open Tododo.Scheduling.Errors
open Tododo.Shared.ROP

[<RoutePrefix("api/appointments")>]
type AppointmentsController
    (
        makeAppointmentImp : MakeAppointmentModel -> Result<unit, Error>
    ) = 
    inherit ApiController()
    
    [<Route("")>]
    member x.Get() = 
        x.Request.CreateResponse(HttpStatusCode.OK, "test all appointments")

    [<Route("{id:guid}")>]
    member x.Get(id: Guid) = 
        x.Request.CreateResponse(HttpStatusCode.OK, "test appointment")

    [<Route("")>]
    member x.Post(appointment: MakeAppointmentModel) =
        match makeAppointmentImp appointment with 
        | Failure(ValidationError msg) -> x.BadRequest msg :> IHttpActionResult
        | _ -> x.StatusCode HttpStatusCode.Accepted :> IHttpActionResult 

