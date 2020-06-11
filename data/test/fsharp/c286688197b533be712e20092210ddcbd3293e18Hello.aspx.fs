

namespace HTTPTest
open System
open System.Web
open System.Web.UI.WebControls

 
// a http handler class 
//type SimpleHandler() = 
//    interface IHttpHandler with 
//        // tell the ASP.NET runtime if the handler can be reused 
//        member x.IsReusable = false 
//        // The method that will be called when processing a 
//        // HTTP request 
//        member x.ProcessRequest(c : HttpContext) = 
//            c.Response.Write("<h1>Hello World</h1>")

type HelloPage() = 
    inherit System.Web.UI.Page()
    interface IHttpHandler with
        // page load
        // tell the ASP.NET runtime if the handler can be reused 
        member x.IsReusable = false 
        // The method that will be called when processing a 
        // HTTP request 
        member x.ProcessRequest(c : HttpContext) = 
            let param = c.Request.Params.["d"]
            c.Response.Write("<h1>Hello World</h1>" + param)
            c.Response.Write(@"<a href=""1234"">click here</a>")

            