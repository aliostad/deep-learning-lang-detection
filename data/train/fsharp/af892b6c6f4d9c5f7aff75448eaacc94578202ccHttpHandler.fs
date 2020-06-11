namespace Lemon

open System
open System.Linq
open System.Web

type HttpHandler (server:Server) =
  interface IHttpHandler with
    member x.IsReusable = true
    member x.ProcessRequest (ctx:HttpContext) = 
      let wrapper = HttpContextWrapper ctx
      server wrapper.Request wrapper.Response |> ignore


type AsyncHttpHandler (server:Server) =
  let handler  = (HttpHandler server) :> IHttpHandler
  let action = Action<HttpContext>(handler.ProcessRequest)

  interface IHttpAsyncHandler with
    member x.IsReusable = handler.IsReusable
    member x.ProcessRequest (ctx:HttpContext) =
      raise(InvalidOperationException())

    member x.BeginProcessRequest (context:HttpContext, cb : AsyncCallback, extraData : obj) =
      action.BeginInvoke(context, cb, extraData)

    member x.EndProcessRequest (result : IAsyncResult) =
      action.EndInvoke(result)