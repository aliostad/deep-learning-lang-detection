namespace Sharpie.Tests

open FSharpx
open NUnit.Framework
open Sharpie
open Sharpie.Http

[<TestFixture>]
module ``MessageDispatcher specs`` =
    let private AssertSuccess (classUnderTest : MessageDispatcher) request path =
        Option.maybe {
            let! handler = classUnderTest.ChooseHandler path
            let! response = handler request
            do
                Assert.That(response.Body, Is.EqualTo "hello world")
                Assert.That(response.StatusCode, Is.EqualTo 200)
            return ()
        }
        |> Option.getOrElseF (fun _ -> Assert.Fail())

    [<Test>]
    let ``when routing with a singler handler``() =
        let handlers = [
            "/", fun (r : Request) -> Some { StatusCode = 200; Body = "hello world"; Headers = Map.empty }
        ]
        let request = { Url = "/"; Method = Get; Headers = Map.empty; Body = "" }
        use classUnderTest = new MessageDispatcher(handlers)

        AssertSuccess classUnderTest request "/"

    [<Test>]
    let ``when routing with two routers``() =
        let handlers = [
            "/asdf", fun (r : Request) -> Some { StatusCode = 500; Body = "nope"; Headers = Map.empty }
            "/", fun (r : Request) -> Some { StatusCode = 200; Body = "hello world"; Headers = Map.empty }
        ]
        let request = { Url = "/"; Method = Get; Headers = Map.empty; Body = "" }
        use classUnderTest = new MessageDispatcher(handlers)
        
        AssertSuccess classUnderTest request "/"

    [<Test>]
    let ``routes are case insensitive``() =
        let handlers = [
            "/foo", fun (r : Request) -> Some { StatusCode = 200; Body = "hello world"; Headers = Map.empty }
            "/bar", fun (r : Request) -> Some { StatusCode = 500; Body = "nope"; Headers = Map.empty }
        ]
        let request = { Url = "/"; Method = Get; Headers = Map.empty; Body = "" }
        use classUnderTest = new MessageDispatcher(handlers)

        AssertSuccess classUnderTest request "/Foo"

    [<Test>]
    let ``when routing a path that is not handled``() =
        let handlers = [
            "/foo", fun (r : Request) -> Some { StatusCode = 200; Body = "hello world"; Headers = Map.empty }
        ]
        let request = { Url = "/"; Method = Get; Headers = Map.empty; Body = "" }
        use classUnderTest = new MessageDispatcher(handlers)

        let handler = classUnderTest.ChooseHandler "/bar"

        match handler with
        | Some h -> 
            Assert.Fail "handler should not have been found"
        | None ->
            ()
