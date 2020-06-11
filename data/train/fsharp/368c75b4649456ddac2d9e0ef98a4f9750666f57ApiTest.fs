namespace prismic.tests
open prismic
open System
open NUnit.Framework

module ApiTest =

    let await a = a |> Async.RunSynchronously
    let expectException statement matchesException = 
        try
            statement() |> ignore
            Assert.Fail("expected exception was not raised")
        with | e -> match matchesException(e) with
                    | true -> Assert.That(true)
                    | _ -> reraise()//Assert.Fail(sprintf "unexpected type of exception happened: %s %s" (e.GetType().Name) e.Message)
    
    let apiGetNoCache = Api.get (ApiInfra.NoCache() :> ApiInfra.ICache<Api.Response>) (ApiInfra.Logger.NoLogger)

    [<TestFixture>]
    type ``Get Private Api``() = 

        [<Test>]
        member x.``Without Authorization Token Should Throw``() =
            let url = "https://private-test.prismic.io/api"
            expectException 
                (fun () -> await (apiGetNoCache (Option.None) url))
                (function
                    | Api.AuthorizationNeeded(_, url) -> url = "https://private-test.prismic.io/auth"
                    | e -> false)

        [<Test>]
        member x.``With Invalid Token Should Throw``() =
            let url = "https://private-test.prismic.io/api"
            expectException 
                (fun () -> await (apiGetNoCache (Option.Some("dummy-token")) url))
                (function
                    | Api.InvalidToken(_, url) -> url = "https://private-test.prismic.io/auth"
                    | e -> false)


        [<Test>]
        member x.``Should Return a response When the token is given``() = 
            let url = "https://kit-private-test.prismic.io/api"
            let token = Option.None // Provide a token, else the test will be inconclusive
            if token.IsNone then
                Assert.Ignore("Provide a token, else the test will be inconclusive")
            else
                let api = await (apiGetNoCache token url)
                let response = await (api.Forms.["everything"].Ref("U0LvJAEAAN8FetQw").PageSize(10).Page(1).Submit())
                Assert.AreEqual(1, response.page)

        [<Test>]
        member x.``Should Return linked documents``() = 
            let url = "https://micro.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Query("""[[:d = at(document.type, "docchapter")]]""")
            let document = await(form.Submit()).results |> List.head 

            let linkedDocuments = document.linkedDocuments
            Assert.AreEqual(2, Seq.length linkedDocuments)

            let linked1 = linkedDocuments |> Seq.tryFind (fun l -> l.id = "UrDofwEAALAdpbNH")
            Assert.IsTrue(linked1.IsSome)
            Assert.AreEqual("with-jquery",linked1.Value.slug.Value)
            Assert.AreEqual("doc",linked1.Value.typ)

            let linked2 = linkedDocuments |> Seq.tryFind (fun l -> l.id = "UrDp8AEAAPUdpbNL")
            Assert.IsTrue(linked2.IsSome)
            Assert.AreEqual("with-bootstrap",linked2.Value.slug.Value)
            Assert.AreEqual("doc",linked2.Value.typ)
