open System
open System.Net
open System.IO

open FastCGI

let logger =
   new StreamWriter(@"C:\inetpub\bin\fcgi_" + string(DateTime.Now.Ticks) + ".log", false)
   |> TextWriter.Synchronized

let log str =
   logger.WriteLine (DateTime.Now.ToString "yyyy-MM-dd HH:mm:ss.FFFFFF: " + str)
   logger.Flush()


let options = Options(  Bind=BindMode.CreateSocket
                      , EndPoint=IPEndPoint(IPAddress.Parse("127.0.0.1"), 9000)
                      , ErrorLogger=log
//                      , TraceLogger=log
                      , ConcurrentConnections=true
                     )


let asyncHandler (request:Request) (response:Response) =
   async {
      // 1. resend content to get checked by client
      let! content = request.Stdin.AsyncGetContents()
      response.SetCookie( Cookie("contents", String( Text.Encoding.UTF8.GetChars content )) )

      // 2. resend a http request header to get checked by client
      let userAgent = match request.Headers.TryFind HttpFrom with
                      | Some v -> v
                      | None -> "empty"
      response.SetCookie( Cookie("ReceivedHeader", userAgent) )

      // 3. resend a cookie to get checked by client
      let cookieValue = match request.GetCookieValue "keks" with
                        | Some v -> v
                        | None -> "empty"
      response.SetCookie( Cookie("ReceivedCookie", cookieValue) )

      // 4. set one cookie to get checked by client by constant comparison
      response.SetCookie( Cookie("ResponseCookie", "cookie from server") )

      // 5. set one header ...
      response.SetHeader(ResponseHeader.HttpContentLanguage, "klingon")
      
      // 6. set constant response
      do! response.AsyncPutStr "reply from server"
   }


// Does the same things as the asyncHandler
let blockingHandlerImpl (request:Request) (response:Response) =
   let content = request.Stdin.GetContents()

   response.SetCookie( Cookie("contents", String( Text.Encoding.UTF8.GetChars content )) )

   let userAgent = match request.Headers.TryFind HttpFrom with
                     | Some v -> v
                     | None -> "empty"
   response.SetCookie( Cookie("ReceivedHeader", userAgent) )

   let cookieValue = match request.GetCookieValue "keks" with
                     | Some v -> v
                     | None -> "empty"
   response.SetCookie( Cookie("ReceivedCookie", cookieValue) )

   response.SetCookie( Cookie("ResponseCookie", "cookie from server") )

   response.SetHeader(ResponseHeader.HttpContentLanguage, "klingon")
      
   response.PutStr "reply from server"


let blockingHandler : Request -> Response -> Async<unit> = convertBlockingHandler blockingHandlerImpl


let startFCGIServer bindMode loop handler = 
   options.Bind <- bindMode
   loop options handler |> Async.RunSynchronously


let bindingModes = dict ["UseStdinSocket", BindMode.UseStdinSocket; "CreateSocket", BindMode.CreateSocket]
let serverLoops = dict ["simple", serverLoop; "multiplexing", multiplexingServerLoop]
let handlers = dict ["async", asyncHandler; "blocking", blockingHandler]


[<EntryPoint>]
let main args =
   log <| sprintf "Starting with arguments: %s" ((List.ofArray args).ToString())
   let bindMode = if args.Length >= 1 then args.[0] else "UseStdinSocket"
   let connectionType = if args.Length >= 2 then args.[1] else "simple"
   let handlerType = if args.Length >= 3 then args.[2] else "async"
   try
      startFCGIServer bindingModes.[bindMode] serverLoops.[connectionType] handlers.[handlerType]
   with
      | ex -> log <| sprintf "Uncaught exception: %s" (ex.ToString())
   0