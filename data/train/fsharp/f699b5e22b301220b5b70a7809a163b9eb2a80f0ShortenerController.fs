namespace Chapter10MVC5.Controllers
open System
open System.Collections.Generic
open System.Linq
open System.Net.Http
open System.Web.Http
open Chapter10MVC5.Models

[<RoutePrefix("api")>]
type ShortenerValuesController() =
    inherit ApiController()

    [<Route("add")>]
    [<HttpPost>]
    member x.Add(long : string) : IHttpActionResult = 
        let short = Shortener.Shorten(long)
        // You may need to update the port number:
        let url = sprintf "localhost:48213/api/go/%s" short
        x.Ok(url) :> _

    [<Route("go/{short}")>]
    [<HttpGet>]
    member x.Go(short : string) : IHttpActionResult =
       match Shortener.TryResolve short with
       | Some long ->
           let url = sprintf "http://%s" long
           x.Redirect(url) :> _
       | None ->
           x.NotFound() :> _
