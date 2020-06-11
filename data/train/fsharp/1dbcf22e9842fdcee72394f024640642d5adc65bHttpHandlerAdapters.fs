namespace Lemon

open System
open System.Web
open Lemon
  
module HttpHandlerAdapters =
  let httpHandler (handler : #IHttpHandler) (_:Response) = 
    handler.ProcessRequest(HttpContext.Current)
    HttpResponseWrapper(HttpContext.Current.Response) :> Response

  let httpHandlerFactory (handlerFactory : #IHttpHandlerFactory) (_:Response) = 
    let ctx = HttpContext.Current
    let handler = handlerFactory.GetHandler(ctx, ctx.Request.RequestType, ctx.Request.RawUrl, ctx.Request.PhysicalApplicationPath)
    handler.ProcessRequest(HttpContext.Current)
    HttpResponseWrapper(HttpContext.Current.Response) :> Response

  let staticFile resp = 
    let handlerType = (typeof<HttpApplication>).Assembly.GetType("System.Web.StaticFileHandler", true) 
    let handler = Activator.CreateInstance(handlerType, true) :?> IHttpHandler
    httpHandler handler resp

  let pageFile resp = 
    let handlerFactoryType = (typeof<HttpApplication>).Assembly.GetType("System.Web.UI.PageHandlerFactory", true) 
    let handlerFactory = Activator.CreateInstance(handlerFactoryType, true) :?> IHttpHandlerFactory
    httpHandlerFactory handlerFactory resp