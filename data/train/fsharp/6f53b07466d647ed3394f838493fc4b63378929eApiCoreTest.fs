namespace prismic.tests
open prismic
open System
open NUnit.Framework

[<TestFixture>]
type ApiCoreTest() = 

    [<Test>]
    member x.``Can Build Url With params And existing parameters``() =
        let parameters = Map.empty
                            .Add("param2", Seq.singleton "b")
                            .Add("param3", Seq.singleton "c")
        let r = ApiCore.buildUrl "http://test.com/test?param1=a" parameters
        Assert.AreEqual("http://test.com/test?param1=a&param2=b&param3=c", r.ToString())

    [<Test>]
    member x.``Can Build Url With multi values parameters``() =
        let parameters = Map.empty
                            .Add("param1", Seq.ofList ["a"; "b"])
                            .Add("param2", Seq.singleton "c")
        let r = ApiCore.buildUrl "http://test.com/test" parameters
        Assert.AreEqual("http://test.com/test?param1=a,b&param2=c", r.ToString())
    