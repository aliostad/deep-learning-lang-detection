namespace Nomad.UnitTests

#nowarn "0025"

open System
open FsCheck
open Nomad
open FsCheck.Xunit
open Microsoft.AspNetCore.Http

module HttpHandlerTests =
    [<Property>]
    let ``Given a value, running a return' handler will return the supplied value`` (value : obj) =
        let context = DefaultHttpContext()
        let (Continue retValue) = 
            HttpHandler.return' value
            |> HttpHandler.Unsafe.runHandler context
        retValue = value

    [<Property>]
    let ``Given a Content Type, setContentType sets the content type of the context's response to the supplied content type`` (mimeType : MimeType) =
        let context = DefaultHttpContext()
        HttpHandler.setContentType mimeType
        |> HttpHandler.Unsafe.runHandler context
        |> ignore
        context.Response.ContentType = ContentType.asString mimeType

    [<Property>]
    let ``Given a Http Response Status, setStatus sets the status code of the context's response to the code associated with the supplied response status`` (code : PositiveInt) =
        match Http.tryCreateStatusFromCode code.Get with
        |Some (status) ->
            let context = DefaultHttpContext()
            HttpHandler.setStatus status
            |> HttpHandler.Unsafe.runHandler context
            |> ignore
            context.Response.StatusCode = Http.responseCode status
        |None -> true

    [<Property>]
    let ``Given an Http Context containing a request with some bytes, readToEnd returns all of the bytes`` (bytes : byte[]) =
        let context = DefaultHttpContext()
        context.Request.Body <- new System.IO.MemoryStream(bytes)
        let (Continue readBytes) = 
            HttpHandler.readToEnd
            |> HttpHandler.Unsafe.runHandler context
        readBytes = bytes

    [<Property>]
    let ``Given some bytes, writeBytes writes all of the supplied bytes to the Http Context's response`` (bytes : byte[]) =
        let context = DefaultHttpContext()
        use stream = new System.IO.MemoryStream()
        context.Response.Body <- stream
        HttpHandler.writeBytes bytes
        |> HttpHandler.Unsafe.runHandler context
        |> ignore
        Array.forall2 (=) (stream.ToArray()) bytes

    [<Property>]
    let ``Given some text, writeText writes the supplied string to the Http Context's response in UTF8`` (text : NonNull<string>) =
        let context = DefaultHttpContext()
        use stream = new System.IO.MemoryStream()
        context.Response.Body <- stream
        HttpHandler.writeText (text.Get)
        |> HttpHandler.Unsafe.runHandler context
        |> ignore
        Array.forall2 (=) (stream.ToArray()) (System.Text.Encoding.UTF8.GetBytes(text.Get))



