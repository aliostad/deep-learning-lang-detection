//module CreatingIHttpHandler_Pic

// what wil be covered in this chapter include the following
//   1. how to create a ASP.NET page that draws a pie image to the asp.net page 


(*

run this program with the following code : 


http://localhost:2889/pic.aspx?angle=240
*)
namespace Strangelights.HttpHandlers
//namespace Strangelights.HttpHandlers

open System.Drawing
open System.Drawing.Imaging
open System.Web

// a  class that will render a pictures for a http request
type PictureHandler() = 
    interface IHttpHandler with 
    // tell the ASP.NET runtime if the handler can bve reused 
    member x.IsReusable = false
    // this method that will be called when processing a 
    // HTTP request and render a picture 
    member x.ProcessRequest (c : HttpContext) = 
        // create a new bitmap 
        let bitmap = new Bitmap(200, 200)
        // create a graphics object for the bitmap
        let graphics = Graphics.FromImage(bitmap)
        // a brush to provide the color 
        let brush = new SolidBrush(Color.Red)
        // get the angle to draw  (you will need to pass in some request parameter such as angle=240, which is seperated by the parameter placeholder '?')
        let x = int(c.Request.QueryString.Get("angle"))
        /// draw the pie to the bitmap 
        graphics.FillPie(brush, 10, 10, 180, 180, 0 , x)
        // save the bitmap to the output stream (* the key here is to write the image out as a ImgaeFormt. with Gif *)
        bitmap.Save(c.Response.OutputStream, ImageFormat.Gif)

(*

to execute the request you will need the following web.config 


*)

(*

<configuration>
    <system.web>
        <httpHandlers>
            <add path="pic.aspx"
                verb="*"
                type="Strangelights.HttpHandlers.PictureHandler"
                validate="true"/>
        </httpHandlers>
    </system.web>
</configuration>

*)