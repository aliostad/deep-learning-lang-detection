namespace MessageIt.Controllers

open System
open System.Web.Http
open System.Net.Http
open System.Net
open MessageIt
open MessageIt.Domain
open MessageIt.Dtos

// ============================== 
// Helpers
// ============================== 
module ApiControllerHelper = 
  let OK (x : ApiController) content = x.Request.CreateResponse(HttpStatusCode.OK, content)

// ============================== 
// api/Message
// ============================== 
[<RoutePrefix("api/message")>]
type MessageController(formatMessage : Message -> Person -> FormattedMessage, sendMessage : FormattedMessage -> FormattedMessage) as this = 
  inherit ApiController()
  
  /// simple helper to make code more readable.  Using partial application.
  let OK msg = ApiControllerHelper.OK this msg.Content
  
  [<Route("")>]
  [<HttpPost>]
  member this.Send messageRequest = 
    formatMessage { Text = messageRequest.Message } { Name = messageRequest.Name }
    |> sendMessage
    |> OK
