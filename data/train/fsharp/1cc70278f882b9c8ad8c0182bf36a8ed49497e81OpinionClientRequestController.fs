namespace OpinionMinerAPI.Controllers
open System
open System.Collections.Generic
open System.Linq
open System.Net
open System.Net.Http
open System.Web.Http

open OpinionMinerAPI.Models
open OpinionRequestManager

/// Retrieves values.
type OpinionClientRequestController() =
    inherit ApiController()

    member x.Put(request: OpinionClientRequest) =
        try
            AddPartlyRequests request.Term 12 request.ToDate 50 0
            x.Request.CreateResponse(HttpStatusCode.OK)
        with
            |_ -> x.Request.CreateResponse(HttpStatusCode.InternalServerError)
