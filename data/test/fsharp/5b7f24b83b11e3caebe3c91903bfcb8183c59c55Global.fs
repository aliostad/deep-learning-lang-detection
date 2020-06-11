namespace api

open System
open System.Web.Http
open System.Net
open System.Net.Http
 
//Ripped off from Mark Seemann http://blog.ploeh.dk/2013/08/23/how-to-create-a-pure-f-aspnet-web-api-project/

type HttpRouteDefaults = { Controller : string; Id : obj }
 
 type ValuesController() =
    inherit ApiController()
    member this.Get() = 
        this.Request.CreateResponse(
            HttpStatusCode.OK,
            "{ \"response\" : \"Hello\" }")

type Global() =
    inherit System.Web.HttpApplication()
    member this.Application_Start (sender : obj) (e : EventArgs) =
        (GlobalConfiguration.Configuration.Routes.MapHttpRoute(
            "DefaultAPI",
            "{controller}/{id}",
            { Controller = "Home"; Id = RouteParameter.Optional }) |> ignore
            )