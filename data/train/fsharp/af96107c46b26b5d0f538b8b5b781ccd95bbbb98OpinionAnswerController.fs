namespace OpinionMinerAPI.Controllers
open System
open System.Collections.Generic
open System.Linq
open System.Net
open System.Net.Http
open System.Web.Http
open OpinionMinerAPI.Models
open OpinionMinerData

/// Retrieves values.
type OpinionAnswerController() =
    inherit ApiController()

//    member x.Get() =
//        x.Request.CreateResponse(HttpStatusCode.OK) |> ignore
//        let context = new OpinionMinerDBEntities()
//        context.Opinion
//        [|{Id = 1;
//           OpinionRequestId = 1;
//           Result = 0.25;
//           Created = DateTime.Now;
//           Term = "Accenture"; 
//           FromDate = new DateTime(2015,1,1);
//           ToDate = new DateTime(2015,2,1);
//           PageCount = 10}|]


       