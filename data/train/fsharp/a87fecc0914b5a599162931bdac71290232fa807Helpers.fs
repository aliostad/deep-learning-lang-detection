namespace FSharpApp.Api.Helpers

open FSharpApp.Core
open System.Runtime.CompilerServices
open System.Web.Http.Results
open System.Net.Http
open System.Web.Http

module ApiControllerExtensions =
  type ApiController with
    member x.OkResult (content: 'a) =
      new OkNegotiatedContentResult<'a> (content, x) :> IHttpActionResult

    member x.BadRequestResult (failure: Failure) =
      new BadRequestErrorMessageResult (failure.Message, x) :> IHttpActionResult

    member x.InternalServerErrorResult (failure: Failure) =
      let requestMessage = x.Request
      requestMessage.Content <- new StringContent(failure.Message)
      new InternalServerErrorResult(requestMessage) :> IHttpActionResult