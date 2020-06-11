namespace FRest.Server

open System.Net
open System.Threading.Tasks
open System.Web.Http
open System.Net.Http

open FRest.Contracts

type MyApiController (handler : Handler.T) =
    inherit ApiController ()

    [<HttpGet()>]
    member this.Echo (msg : string) : Task<HttpResponseMessage> =
        async {
            try
                let! reply = Handler.onEcho handler msg

                return 
                    this.Request.CreateResponse (
                        HttpStatusCode.OK, 
                        { Messages.message = reply })
            with
            | _ as err ->
                return 
                    this.Request.CreateErrorResponse (
                        HttpStatusCode.InternalServerError, 
                        err)
        } |> Async.StartAsTask