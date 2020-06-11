namespace FsharpNancyService

open Nancy.ErrorHandling
open Microsoft.Extensions.Logging
open Nancy
open System

type GlobalErrorHandler (factory : ILoggerFactory) =
    let logger = factory.CreateLogger<GlobalErrorHandler>()
    interface IStatusCodeHandler with
        member this.HandlesStatusCode(statusCode: HttpStatusCode, context:NancyContext) =
            statusCode = HttpStatusCode.InternalServerError
        member this.Handle(statusCode: HttpStatusCode, context:NancyContext) =
            let res, errorObject = context.Items.TryGetValue(NancyEngine.ERROR_EXCEPTION)
            let error = errorObject :?> Exception
            logger.LogError("{error}", error)