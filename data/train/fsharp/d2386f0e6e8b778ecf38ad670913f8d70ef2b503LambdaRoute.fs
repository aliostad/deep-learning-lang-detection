namespace FSharpMVC

open System.Text.RegularExpressions
open System.Web
open System.Web.Mvc
open System.Web.Routing

type LambdaControllerFactory() = 
    interface IControllerFactory with
        member x.CreateController (requestContext: RequestContext, controllerName: string) = null
        member x.ReleaseController controller = ()        
    
type LambdaHttpHandler(controller: ControllerBase, context: RequestContext) = 
    interface IHttpHandler with
        member x.IsReusable = false
        member x.ProcessRequest(ctx: HttpContext) =
            (controller :> IController).Execute(context)

type LambdaRouteHandler(controller: ControllerBase) = 
    interface IRouteHandler with
        member x.GetHttpHandler(requestContext: RequestContext) = 
            LambdaHttpHandler(controller, requestContext) :> IHttpHandler

type LambdaRoute<'a when 'a :> ActionResult> = 
    inherit RouteBase
    
    val private url: Regex
    val private controller: ControllerBase
    
    new(url: string, f: RequestContext -> 'a option) = 
        let c = { new ControllerBase() with
                    override x.ExecuteCore() = 
                        match f x.ControllerContext.RequestContext with
                        | Some z -> z.ExecuteResult x.ControllerContext
                        | _ -> () }
        { url = Regex(url, RegexOptions.Compiled); controller = c }
    
    override x.GetRouteData(httpContext: HttpContextBase) =
        match x.url.IsMatch httpContext.Request.RawUrl with
        | false -> null
        | true -> 
            let data = RouteData(x, LambdaRouteHandler(x.controller))
            data.Values.["controller"] <- (x.url.ToString() :> obj)
            data
        
    override x.GetVirtualPath(requestContext: RequestContext, values: RouteValueDictionary) = null