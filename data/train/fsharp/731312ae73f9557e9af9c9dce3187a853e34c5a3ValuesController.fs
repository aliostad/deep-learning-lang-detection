namespace FsWeb.Controllers

open System.Net
open System.Web
open System.Web.Mvc
open System.Net.Http
open System.Web.Http
open System.Linq
open FsWeb.Models

type ValuesController() =
    inherit ApiController()

    // GET /api/values
    member x.Get() = 
        let values = [| "value1"; "value2" |]
        Response(Results = values)
//        [| "value3"; "value2" |] |> Array.toSeq
    // GET /api/values/5
    member x.Get (id:int) = 
        match id with
        | 1 | 2 -> sprintf "Value is %i" id
        | _ -> raise <| HttpResponseException(HttpStatusCode.NotFound)
    // POST /api/values
    member x.Post (value:string) = ()
    // PUT /api/values/5
    member x.Put (id:int) (value:string) = ()
    // DELETE /api/values/5
    member x.Delete (id:int) = ()
