namespace Automated.API.Test

module SimpleQueryReturnsResults = 
    open System
    open System.Net
    open Xunit
    open FsUnit.Xunit

    [<Fact>]
    let ``When execute get request the response code is 200`` () =
        let response = 
            Automated
                .Api
                .ApiCall
                .WithString("https://testwebhooks.com/c/Automated.ApiCheck")
                .WithMethod("GET")
                .WithPayload("{property:'test'}")
                .Execute()
                |> Async.AwaitTask
                |> Async.RunSynchronously

        response.HttpStatusCode |> should equal HttpStatusCode.OK