namespace prismic.tests
open System
open prismic
open NUnit.Framework

module PaginationTest =

    [<TestFixture>]
    type ``Query The Api With Pagination``() = 

        let await a = a |> Async.RunSynchronously
        let apiGetNoCache = Api.get (ApiInfra.NoCache() :> ApiInfra.ICache<Api.Response>) (ApiInfra.Logger.NoLogger)

        [<Test>]
        member x.``Can Return first page``() =
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Page(1).PageSize(20).Orderings("[my.docchapter.priority]")
            let r = await(form.Submit())
            Assert.AreEqual(1, r.page)
            Assert.AreEqual(2, r.totalPages)
            Assert.AreEqual(20, r.resultsPerPage)
            Assert.AreEqual(20, r.resultsSize)
            Assert.AreEqual(Some("https://lesbonneschoses.prismic.io/api/documents/search?ref=UlfoxUnM08QWYXdl&orderings=%5Bmy.docchapter.priority%5D&page=2&pageSize=20"), r.nextPage)
            Assert.AreEqual(None, r.prevPage)
            Assert.AreEqual("UlfoxUnM0wkXYXbV", (r.results|> List.head).id)
            Assert.AreEqual(20, (r.results.Length))

        [<Test>]
        member x.``Can Return second page``() =
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Page(2).PageSize(20).Orderings("[my.docchapter.priority]")
            let r = await(form.Submit())
            Assert.AreEqual(2, r.page)
            Assert.AreEqual(2, r.totalPages)
            Assert.AreEqual(20, r.resultsPerPage)
            Assert.AreEqual(20, r.resultsSize)
            Assert.AreEqual(None, r.nextPage)
            Assert.AreEqual(Some("https://lesbonneschoses.prismic.io/api/documents/search?ref=UlfoxUnM08QWYXdl&orderings=%5Bmy.docchapter.priority%5D&page=1&pageSize=20"), r.prevPage)
            Assert.AreEqual(20, (r.results.Length))

        [<Test>]
        member x.``Can set page size``() =
            let url = "https://lesbonneschoses.prismic.io/api"
            let api = await (apiGetNoCache (Option.None) url)
            let form = api.Forms.["everything"].Ref(api.Master).Page(1).PageSize(7).Orderings("[my.docchapter.priority]")
            let r = await(form.Submit())
            Assert.AreEqual(1, r.page)
            Assert.AreEqual(6, r.totalPages)
            Assert.AreEqual(7, r.resultsPerPage)
            Assert.AreEqual(7, r.resultsSize)
            Assert.AreEqual(Some("https://lesbonneschoses.prismic.io/api/documents/search?ref=UlfoxUnM08QWYXdl&orderings=%5Bmy.docchapter.priority%5D&page=2&pageSize=7"), r.nextPage)
            Assert.AreEqual(None, r.prevPage)
            Assert.AreEqual(7, (r.results.Length))
