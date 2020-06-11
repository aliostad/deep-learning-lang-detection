namespace Figment

open System
open System.Web
open System.Web.Mvc
open System.Web.Mvc.Async
open System.Web.Routing
open Figment.Helpers

open System.Diagnostics
open Extensions

type IHttpHandlerBase =
    abstract ProcessRequest: HttpContextBase -> unit

type IControllerProvider =
    abstract CreateController: unit -> IController

type FigmentHandler(context: RequestContext, action: FAction) =
    let proc (ctx: HttpContextBase) =
        let controller = buildControllerFromAction action
        ctx.Request.DisableValidation() |> ignore
        controller.ValidateRequest <- false
        (controller :> IController).Execute context

    interface IControllerProvider with
        member this.CreateController() = upcast buildControllerFromAction action

    interface IHttpHandlerBase with
        member this.ProcessRequest(ctx: HttpContextBase) = proc ctx

    interface System.Web.SessionState.IRequiresSessionState
    interface IHttpHandler with
        member this.IsReusable = false
        member this.ProcessRequest ctx = HttpContextWrapper(ctx) |> proc

type FigmentAsyncHandler(context: RequestContext, action: FAsyncAction) = 
    let proc (ctx: HttpContextBase) =
        let controller = buildControllerFromAsyncAction action
        ctx.Request.DisableValidation() |> ignore
        controller.ValidateRequest <- false
        (controller :> IController).Execute context

    interface IControllerProvider with
        member this.CreateController() = upcast buildControllerFromAsyncAction action

    interface IHttpHandlerBase with
        member this.ProcessRequest(ctx: HttpContextBase) = proc ctx

    interface System.Web.SessionState.IRequiresSessionState
    interface IHttpAsyncHandler with
        member this.IsReusable = false
        member this.ProcessRequest ctx = HttpContextWrapper(ctx) |> proc
        member this.BeginProcessRequest(ctx, cb, state) = 
            Debug.WriteLine "BeginProcessRequest"
            let controller = buildControllerFromAsyncAction action :> IAsyncController
            controller.BeginExecute(context, cb, state)

        member this.EndProcessRequest r =
            Debug.WriteLine "EndProcessRequest"

module RouteHandlerHelpers =
    let inline buildActionRouteHandler (action: FAction) = 
        buildRouteHandler (fun ctx -> upcast FigmentHandler(ctx, action))

    let inline buildAsyncActionRouteHandler (action: FAsyncAction) =
        buildRouteHandler (fun ctx -> upcast FigmentAsyncHandler(ctx, action))
