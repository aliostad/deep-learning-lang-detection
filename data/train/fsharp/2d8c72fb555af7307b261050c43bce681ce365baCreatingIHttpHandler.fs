module CreatingIHttpHandler

// what will be covered in this chapter incldue the following 
//  1. Creating an IHttpHandler

(*

how to configure the IIS or the Visual Studio to start the the debuggin the pages. 

1. How to: Open IIS Manager:  http://msdn.microsoft.com/en-us/library/bb763170(v=vs.100).ASPX
2. How to: Create and Configure Virtual Directories in IIS 7.0: http://msdn.microsoft.com/en-us/library/bb763173(v=vs.100).ASPX

*)




(*
you will need to add the reference to System.Web.dll
*)

//namespace Strangelights.HttpHandler

open System.Web
// a http handler class
type SimpleHandler() =
    interface IHttpHandler with 
        // tells the ASP.NET runtime if the handler can be reused
        member x.IsReusable  = false
        // the method that will be called when processing a 
        // HTTP request
        member x.ProcessRequest (c: HttpContext)  = 
            c.Response.Write("<h1>Hello world</h1>")


(*
the following configuration will be used to configure the handler with the page 
*)
(*

<configuration>
    <system.web>
        <httpHandlers   >
            <add path="hello.aspx"
                verb="*"
                type="Strangelights.HttpHandlers.SimpleHandler"
                validate="true"/>
        </httpHandlers>
    </system.web>
</configuration>

*)