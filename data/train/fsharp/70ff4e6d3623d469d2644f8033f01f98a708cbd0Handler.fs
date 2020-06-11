namespace au.id.cxd.Math.Http

open System
open System.Web
open AsyncHelper

module Handler =

    type HandlerInstance(processFn:HttpContext -> unit) = 
        interface IHttpAsyncHandler with
        
            // is reusable.
            member m.IsReusable with get() = true
            
            /// this is unused
            member m.ProcessRequest(context) = ()
            
            member m.BeginProcessRequest(context:HttpContext, callback, state) = beginAction((context, processFn), callback, state)
            
            member m.EndProcessRequest(result) = endAction(result)
            
            