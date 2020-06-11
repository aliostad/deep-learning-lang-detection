namespace Automated.API.Test

module CanCreateRequest = 
    open System
    open Xunit
    open FsUnit.Xunit

    [<Theory>]
    [<InlineData("GET", "JustQueryRequest")>]
    [<InlineData("POST", "WithPayloadRequest")>]
    [<InlineData("PUT", "WithPayloadRequest")>]
    [<InlineData("DELETE", "JustQueryRequest")>]
    let ``Request is crated for every HTTP word`` (httpWord: string, resultType: string) =
        let request = 
            Automated
                .Api
                .ApiCall
                .WithString("https://testwebhooks.com/c/Automated.ApiCheck")
                .WithMethod(httpWord)
                .WithPayload("{property:'test'}")

        request.GetType().Name |> should equal resultType