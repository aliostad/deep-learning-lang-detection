namespace AiLib

open System
open System.Net
open System.IO

module Net =
    type HttpHandler = HttpListenerRequest -> HttpListenerResponse -> Async<unit>

    type ServerConfig = 
        {   host: string;
            handler: HttpHandler;
        }

    type HttpServer(config:ServerConfig) =

        member this.Start() =
            let handle = new HttpListener()
            handle.Prefixes.Add this.Host
            handle.Start()
            
            let task = Async.FromBeginEnd(handle.BeginGetContext, handle.EndGetContext)
            async {
                while true do
                    let! ctx = task
                    Async.Start(this.Handler ctx.Request ctx.Response)
            } |> Async.Start

        member this.Host = config.host
        member this.Handler = config.handler

    module Request =
        let AcceptContentType contentType (req:HttpListenerRequest) =
            req.ContentType = contentType

        let AcceptHttpMethod httpMethod (req:HttpListenerRequest) =
            req.HttpMethod = httpMethod

        let Path path (req:HttpListenerRequest) =
            req.Url.AbsolutePath = path

        let PathEndsWith (path:string) (req: HttpListenerRequest) =
            req.Url.AbsolutePath.EndsWith(path)

        let (|Params|_|) (key:string) (req:HttpListenerRequest) =
            match req.QueryString.GetValues(key) |> Array.toList with
            | [] -> None
            | ls -> Some ls

        let (|Accepts|_|) rules (req:HttpListenerRequest) =
            if List.forall (fun f -> f req) rules then
                Some req
            else None
            

    module Response =
        let RespMorph f (resp:HttpListenerResponse) = 
            f (resp) |> ignore

        let RespContentType contentType =
            RespMorph (fun r -> r.ContentType <- contentType)

        let RespContentLength contentLength =
            RespMorph (fun r -> r.ContentLength64 <- contentLength)

        let RespBytes (bytes: byte array) =
            RespMorph (fun r -> 
                RespContentLength bytes.LongLength r
                use out = r.OutputStream
                out.Write(bytes, 0, bytes.Length)
            )

        let RespContentEncoding encoding =
            RespMorph (fun r -> 
                r.ContentEncoding <- encoding
            )
        
        let RespStatusCode code =
            RespMorph (fun r -> 
                r.StatusCode <- code
            )

        let RespExn (e:exn) =
            RespMorph (fun r -> 
                r.StatusDescription <- "Bad request!"
                [   RespStatusCode 400;
                    RespContentType "text/plain";
                    RespBytes (r.ContentEncoding.GetBytes(e.Message));
                ] |> List.iter (fun f -> f r)
            )

        let Respond resp =
            List.iter (fun f -> f resp) 