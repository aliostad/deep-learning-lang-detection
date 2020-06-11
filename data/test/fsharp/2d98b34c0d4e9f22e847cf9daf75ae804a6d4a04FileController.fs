namespace FsWebApiSample.Controllers

open System
open System.Web
open System.Collections.Generic
open System.Linq
open System.Net
open System.Net.Http
open System.Web.Http


[<RoutePrefix("Api/Files")>]
type FileController() =
    inherit ApiController()

    let root = HttpContext.Current.Server.MapPath("~/App_Data")

    [<Route("Upload"); HttpPost>]
    member this.Upload() =
        async {
            if not <| this.Request.Content.IsMimeMultipartContent() then
                HttpResponseException(HttpStatusCode.UnsupportedMediaType)
                |> raise

            let provider = MultipartFormDataStreamProvider(root)
            do!
                this.Request.Content.ReadAsMultipartAsync(provider)
                |> Async.AwaitTask
                |> Async.Ignore

            return new HttpResponseMessage(ReasonPhrase = "Uploaded!")
        }
        |> Async.StartAsTask