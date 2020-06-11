namespace Nomad.UnitTests

open System
open Xunit
open FsCheck
open Nomad
open Nomad.Routing
open FsCheck.Xunit
open Microsoft.AspNetCore.Http


type RoutingTests() =

    let doNothing = HttpHandler.return' ()

    let returnSingleValue x = HttpHandler.return' x

    let returnTwoValues x y = HttpHandler.return' (x, y)


    [<Property(MaxTest = 1)>]
    member this.``Given a route consisting of a fixed path, if the supplied path matches, the returned handle state is Continue`` () =
        let context = DefaultHttpContext()
        context.Request.Path <- PathString("/MyResource")
        let result = 
            constant "MyResource" ===> doNothing
            |> HttpHandler.Unsafe.runHandler context
        result = Continue()

    [<Property(MaxTest = 1)>]
    member this.``Given a route consisting of a fixed path, if the supplied path does not match due to casing, the returned handle state is Unhandled`` () =
        let context = DefaultHttpContext()
        context.Request.Path <- PathString("/myresource")
        let result = 
            constant "MyResource" ===> doNothing
            |> HttpHandler.Unsafe.runHandler context
        result = Unhandled

    [<Property>]
    member this.``Given a route using an integer path, if the supplied path is any int, the returned handle state should be Continue(int)`` (i : int) =
        let context = DefaultHttpContext()
        context.Request.Path <- PathString(sprintf "/MyResource/%d" i)
        let result = 
            constant "MyResource" </> intR  ===> returnSingleValue
            |> HttpHandler.Unsafe.runHandler context
        result = Continue (i)

    [<Property>]
    member this.``Given a route using twin integer paths, if the supplied path is any two ints, the returned handle state should be Continue(int, int)`` (i : int, i2 : int) =
        let context = DefaultHttpContext()
        context.Request.Path <- PathString(sprintf "/MyResource/%d/Splitter/%d" i i2)
        let result = 
            constant "MyResource" </> intR </> constant "Splitter" </> intR ===> returnTwoValues
            |> HttpHandler.Unsafe.runHandler context
        result = Continue (i, i2)

    [<Property>]
    member this.``Given a route using a float path, if the supplied path is any float, the returned handle state should be Continue(float)`` (flt : NormalFloat) =
        let context = DefaultHttpContext()
        context.Request.Path <- PathString(sprintf "/MyResource/%f" flt.Get)
        let result = 
            constant "MyResource" </> floatR  ===> returnSingleValue
            |> HttpHandler.Unsafe.runHandler context
        result = Continue (float <| sprintf "%f" (flt.Get))

    [<Property>]
    member this.``Given a route using an unsigned int path, if the supplied path is any uint, the returned handle state should be Continue(uint)`` (u : uint32) =
        let context = DefaultHttpContext()
        context.Request.Path <- PathString(sprintf "/MyResource/%u" u)
        let result = 
            constant "MyResource" </> uintR  ===> returnSingleValue
            |> HttpHandler.Unsafe.runHandler context
        result = Continue (u)

    [<Property>]
    member this.``Given a route using a guid path, if the supplied path is any guid, the returned handle state should be Continue(guid)`` (guid : System.Guid) =
        let context = DefaultHttpContext()
        context.Request.Path <- PathString(sprintf "/MyResource/%s" (guid.ToString()))
        let result = 
            constant "MyResource" </> guidR  ===> returnSingleValue
            |> HttpHandler.Unsafe.runHandler context
        result = Continue (guid)