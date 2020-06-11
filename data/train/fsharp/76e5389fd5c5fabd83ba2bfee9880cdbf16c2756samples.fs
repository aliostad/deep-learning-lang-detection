#light
namespace Strangelights.HttpHandlers
open System.Drawing
open System.Drawing.Imaging
open System.Web
type PictureHandler() = class
    interface IHttpHandler with
        member x.IsReusable = false
        member x.ProcessRequest(c : HttpContext) =
            let bitmap = new Bitmap(200, 200)
            let graphics = Graphics.FromImage(bitmap)
            let brush = new SolidBrush(Color.Red)
            let x = int_of_string(c.Request.QueryString.Get("angle"))
            graphics.FillPie(brush, 10, 10, 180, 180, 0, x)
            bitmap.Save(c.Response.OutputStream, ImageFormat.Gif)
    end
end
