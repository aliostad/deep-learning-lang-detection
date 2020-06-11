#light
namespace Strangelights.HttpHandlers

open System.Drawing
open System.Drawing.Imaging
open System.Web

// a class that will render a picture for a http request
type PictureHandler() =
    interface IHttpHandler with
        // tell the ASP.NET runtime if the handler can be reused
        member x.IsReusable = false
        // The method that will be called when processing a
        // HTTP request and render a picture
        member x.ProcessRequest(c: HttpContext) =
            // create a new bitmap
            let bitmap = new Bitmap(200, 200)
            // create a graphics object for the bitmap
            let graphics = Graphics.FromImage(bitmap)
            // a brush to provide the color
            let brush = new SolidBrush(Color.Red)
            // get the angle to draw
            let x = int(c.Request.QueryString.Get("angle"))
            // draw the pie to bitmap
            graphics.FillPie(brush, 10, 10, 180, 180, 0, x)
            // save the bitmap to the output stream
            bitmap.Save(c.Response.OutputStream, ImageFormat.Gif)