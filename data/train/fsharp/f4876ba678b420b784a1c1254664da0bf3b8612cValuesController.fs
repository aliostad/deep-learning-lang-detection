namespace FsWeb.Controllers

open System.Net
open System.Web
open System.Web.Mvc
open System.Net.Http
open System.Web.Http
open System.Linq

type ValuesController() =
    inherit ApiController()

    // GET /api/values
    member x.Get() = [| "value1"; "value2" |] |> Array.toSeq
    // GET /api/values/5
    member x.Get (id:int) = 
        match id with
        | 1 | 2 -> sprintf "Value is %i" id
        | _ -> raise <| HttpResponseException(new HttpResponseMessage(HttpStatusCode.NotFound))   
    // POST /api/values
    member x.Post ([<FromBody>] value:string) = ()
    // PUT /api/values/5
    member x.Put (id:int) ([<FromBody>] value:string) = ()
    // DELETE /api/values/5
    member x.Delete (id:int) = ()