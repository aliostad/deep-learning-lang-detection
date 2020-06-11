namespace prismic.tests
open prismic
open System
open NUnit.Framework
open Api

module QueryTest =

    let await a = a |> Async.RunSynchronously
    let apiGetNoCache = Api.get (ApiInfra.NoCache() :> ApiInfra.ICache<Api.Response>) (ApiInfra.Logger.NoLogger)
    let expectException statement matchesException = 
        try
            statement() |> ignore
            Assert.Fail("expected exception was not raised")
        with | e -> match matchesException(e) with
                    | true -> Assert.That(true)
                    | _ -> Assert.Fail(sprintf "unexpected type of exception happened: %s %s" (e.GetType().Name) e.Message)

    [<TestFixture>]
    type ``Query The Api``() = 
        
        [<Test>]
        member x.``Without a ref Should Throw``() = 
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            expectException 
                (fun () -> await (api.Forms.["everything"].Query("""[[:id = at(my.job-offer.pouet, "ABCDEF12345")]]""").Submit()))
                (function
                    | Api.UnexpectedError(_) -> true
                    | _ -> false)

        [<Test>]
        member x.``With an invalid key Should Throw``() = 
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            expectException 
                (fun () -> await (api.Forms.["everything"].Ref(api.Master).Query("""[[:id = at(my.job-offer.pouet, "ABCDEF12345")]]""").Submit()))
                (function
                    | Api.UnexpectedError(_) -> true
                    | _ -> false)

                   