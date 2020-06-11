namespace Sharpie

open System
open System.Net
open System.Net.Http
open System.Threading
open FSharpx
open Sharpie.Http

type MessageDispatcher(handlers : (string * Http.RequestHandler) list) =
    inherit HttpMessageHandler()

    override this.SendAsync(request : HttpRequestMessage, cancellationToken : CancellationToken) =
        async {
            return Option.maybe {
                let path = request.RequestUri.AbsolutePath
                let! handler = this.ChooseHandler path
                let! response = handler { Url = path; Method = Get; Headers = Map.empty; Body = ""}
                return new HttpResponseMessage(StatusCode = enum<HttpStatusCode>(response.StatusCode), Content = new StringContent(response.Body))
            }
            |> Option.getOrElseF (fun _ -> new HttpResponseMessage(HttpStatusCode.NotFound))
        }
        |> Async.StartAsTask
    
    member this.ChooseHandler (path : string) : Http.RequestHandler option =
        handlers
        |> List.tryPick (fun (prefix, handler) -> 
            if path.StartsWith(prefix, StringComparison.InvariantCultureIgnoreCase)
                then Some handler
                else None)