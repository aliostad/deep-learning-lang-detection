namespace BankApp
module HttpServer =
    open System.Net
    open System.IO
    open System.Text

    type ContentType =
        | Plain
        | JavaScript
        | JSON
        | HTML
        | XSS

    type RequestHandler = HttpListenerResponse -> unit
    type RequestRouter = string -> string -> Stream -> RequestHandler

    let Listen port (router:RequestRouter) =
        let listener = new HttpListener()
        sprintf "http://localhost:%i/" port
        |> listener.Prefixes.Add
        listener.Start()
        printfn "Listening on port %i..." port

        while true do
            let ctx = listener.GetContext()
            let req, res = ctx.Request, ctx.Response
            async { router req.RawUrl req.HttpMethod req.InputStream res
                    res.Close() }
            |> Async.Start

    type SuccessData = { contentType: ContentType; content: string }
    type FailureData = { code: HttpStatusCode; reason: string }
    
    let okResponse = { contentType=ContentType.Plain; content="" }

    type ResponseOption =
        | Success of SuccessData
        | Failure of FailureData

    let Respond:ResponseOption -> HttpListenerResponse -> unit = fun config res ->
        match config with
        | Success data -> let content = Encoding.UTF8.GetBytes(data.content)
                          res.StatusCode <- int HttpStatusCode.OK
                          res.ContentType <- match data.contentType with
                                             | JavaScript -> "text/javascript"
                                             | Plain      -> "text/plain"
                                             | JSON       -> "application/json"
                                             | HTML       -> "text/html"
                                             | XSS        -> "text/css"
                                             |> sprintf "%s;charset=utf-8"
                          res.OutputStream.Write(content, 0, content.Length)
                          res.OutputStream.Close()
        | Failure data -> res.StatusCode <- int data.code
                          res.StatusDescription <- data.reason

    let private readStream (stream:Stream) =
        (new StreamReader(stream)).ReadToEnd()

    type Handler = string -> ResponseOption
    let HandlePost stream (h:Handler):RequestHandler =
        stream |> readStream |> h |> Respond

    let HandleGet jwt (h:Handler):RequestHandler =
        jwt |> h |> Respond