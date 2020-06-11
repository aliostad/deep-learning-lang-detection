namespace TinyRest.IIS

open System
open System.Web
open System.Configuration

open TinyRestServerPCL
open Routing
open Http

type TinyRestConfigurationSection() =
    inherit ConfigurationSection()
        [<ConfigurationProperty("bootstrapper", IsRequired = true)>]
        member x.Bootstrapper
            with get () =
                base.Item "bootstrapper" :?> string
            and set (value:string) = 
                let p = base.Properties.Item "bootstrapper"
                base.SetPropertyValue(p, value, true)
        static member Current() =
            let section = ConfigurationManager.GetSection "tinyRest/startup"
            section :?> TinyRestConfigurationSection

type TinyRestHandler() =
    let routes:HttpRoute list ref = ref List.empty

    let mustLoadRoutes() =
        !routes |> List.isEmpty

    let loadRoutes () =
        let name = TinyRestConfigurationSection.Current().Bootstrapper
        let ty = Type.GetType name
        let bootstrapper = Activator.CreateInstance ty :?> IAppBootstrapper
        routes := bootstrapper.Routes() |> Seq.toList

    interface IHttpHandler with
        member x.ProcessRequest(context:HttpContext) = 
            if mustLoadRoutes()
            then loadRoutes ()
            let rq = HttpMapings.HttpRequest(context.Request)
            let rs = new HttpMapings.HttpResponse(context.Response)
            let conf = { Schema=Http; Port=context.Request.Url.Port; BasePath=None; Routes=(!routes); Logger=None }
            handler rq rs conf |> Async.RunSynchronously
        member x.IsReusable with get () = false

type TinyRestHandlerFactory() = 
    interface IHttpHandlerFactory with
        member x.GetHandler(context:HttpContext, requestType:string, url:string, pathTranslated:string) =
            TinyRestHandler() :> IHttpHandler
        member x.ReleaseHandler(handler:IHttpHandler) =
            ()
