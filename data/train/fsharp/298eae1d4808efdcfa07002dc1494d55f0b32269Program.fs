module Totify.Web.Handler


open Mario.HttpContext
open Mario.WebServer
open Totify.Filters.Master
open Totify.Web.Helpers



let myHandler (req:HttpRequest) : HttpResponse =
    match req.Uri with 
        | "/totify.fs" when req.Method = HttpMethod.POST -> { Json = (totify req.Body) |> json }
        | "/api.fs" when req.Method = HttpMethod.POST -> { Json = (totify req.Body) |> json |> jsonp }
        | "/panel/filter2.fs" -> Totify.Web.FiltersController.filter2Action req.Body req.Method    
        | "/panel/helper1.fs" -> Totify.Web.ServicesController.helper1Action req.Body req.Method    
        | "/quote.fs?random" -> Totify.Web.ServicesController.qouteAction req.Body req.Method
        | "/labs/shannon.fs" -> Totify.Web.LabsController.Shannon2chAction req.Body req.Method
        | "/labs/parse.fs" -> Totify.Web.LabsController.Parse2chAction req.Body req.Method
        | "/labs/stats.fs" -> Totify.Web.LabsController.StatAction req.Body req.Method
        | _ -> Mario.HttpUtility.badRequest
    

Mario.Start(myHandler)