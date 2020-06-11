namespace Pario

open System
open System.IO
open System.Net
open System.Text
open System.Text.RegularExpressions
open System.Diagnostics
open System.Security.Authentication
open System.Threading
open System.Threading.Tasks

open System.Reflection

open System.Diagnostics
open Zrpg.Commons
open Zrpg.Commons.Bundle

module WebServer =
  type Handler = HttpListenerRequest -> HttpListenerResponse -> Async<bool>
  type WsHandler = HttpListenerContext -> bool Async

  type ServerModule = {
    handler: Handler
    priority: int
  }

  type Msg =
    | AddHandler of Handler * priority:int
    | AddWsHandler of WsHandler
    | Listen of host:string * port:uint16

  type Reply =
    | ListenReply of Choice<unit, exn>

  module FileLoader =
    let serveStatic rootDirectory defaultFile =
      let handler: Handler = fun req resp -> async {
        // First, grab the path from the Uri.
        let uri = req.Url

        let pathName = 
          let path = uri.LocalPath
          if path.StartsWith("/") then
            path.Substring(1)
          else
            path

        let filePath = Path.Combine(
          rootDirectory,
          pathName
        )

        printfn "Loading file %s" filePath

        let fileStream = match IO.File.openRead filePath with
        | Success stream -> Some stream
        | _ ->
          match defaultFile with
          | Some filePath ->
            let filePath = Path.Combine(rootDirectory, filePath)

            match IO.File.openRead filePath with
            | Success stream -> Some stream
            | _ -> None
          | _ -> None

        if fileStream.IsNone then
          return false
        else

        use fileStream = fileStream.Value
        use respStream = resp.OutputStream

        do! fileStream.CopyToAsync respStream |> Async.AwaitVoidTask
        return true
      }

      { handler = handler
        priority = 0
      }

  type Work =
    | Handle of HttpListenerRequest * HttpListenerResponse
    | SetModules of ServerModule list
    | KillWork

  type private ServerState () =
    let mutable modules = List.empty<ServerModule>
    let mutable workers = List.empty<MailboxProcessor<Work>>
    let mutable socketHandlers = List.empty<HttpListenerContext -> Async<bool>>

    member this.addModule serverModule =
      modules <- 
        fun m -> m.priority
        |> List.sortBy
        <| serverModule::modules
      modules

    member this.addSocketHandler handler =
      socketHandlers <- handler::socketHandlers

    member this.setWorkers newWorkers =
      workers <- newWorkers

    member this.getWorkers () =
      workers

    member this.getSocketHandlers () =
      socketHandlers

    member this.getModules () =
      modules

  type private RouterMsg =
    | AddModule of ServerModule
    | AddSocketHandler of (HttpListenerContext -> bool Async)
    | SetWorkers of List<MailboxProcessor<Work>>
    | RouteWork of Work
    | HandleSocket of HttpListenerContext
    | Kill

  type Server (log:LogBundle.Log) =
    let rand = new Random()
    let tokenSource = new CancellationTokenSource()
    let token = tokenSource.Token

    let agent = MailboxProcessor.Start(fun inbox ->
      let rec tryHandleSocketUpgrade (context:HttpListenerContext) handlers = async {
        match handlers with
        | [] -> return false
        | handler::handlers ->
          let! res = handler context
          if res then
            return true
          else
            return! tryHandleSocketUpgrade context handlers
      }

      let rec loop (state:ServerState): Async<unit> = async {
        let! msg = inbox.Receive()

        match msg with
        | AddModule serverModule ->
          let modules = state.addModule serverModule
          let workers = state.getWorkers()

          for worker in workers do
            worker.Post <| SetModules modules

        | AddSocketHandler handler ->
          state.addSocketHandler handler

        | RouteWork work ->
          let workers = state.getWorkers()
          if workers.IsEmpty |> not then
            log.Debug <| sprintf "Routing http work to workers..."
            let workers = workers |> List.sortBy (fun worker -> worker.CurrentQueueLength)
            let worker = workers.[0]
            worker.Post work

        | HandleSocket(context) ->
          let handlers = state.getSocketHandlers()
          async {
            let! handled = tryHandleSocketUpgrade context handlers
            if not handled then
              use resp = context.Response
              resp.StatusCode <- 400
          } |> Async.Start
          ()

        | SetWorkers workers ->
          state.setWorkers workers

        | Kill ->
          let workers = state.getWorkers()
          for worker in workers do
            worker.Post KillWork
          return ()

        return! loop state
      }

      loop <| new ServerState()
    )

    do 
      [ 0 .. 3 ]
      |> List.map (fun i ->
        let worker = MailboxProcessor.Start(fun inbox ->
          let rec loop handlers = async {
            let! work = inbox.Receive()

            match work with
            | SetModules handlers ->
              return! loop handlers

            | Handle (req, resp) ->
              use resp = resp
              let url = req.Url

              let rec iter handlers = async {
                match handlers with
                | [] -> return false
                | handler::handlers ->
                  let! res = handler.handler req resp
                  if res then
                    return res
                  else
                    return! iter handlers
              }

              let! res = iter handlers
              if not res then
                Debug.WriteLine("Setting status code to 404")
                resp.StatusCode <- 404
              else () // The response was handled.

              // Will close the response.
            | KillWork ->
              return ()

            return! loop handlers
          }

          loop <| List.empty<ServerModule>
        )

        worker
      )
      |> SetWorkers
      |> agent.Post

    member this.listen host (port:uint16) = async {
      let listener = new HttpListener()

      listener.Prefixes.Add <| sprintf "http://%s:%i/" host port
      listener.Prefixes.Add <| sprintf "https://%s:%i/" host (port + 1us)
      listener.Start()

      let task = Async.FromBeginEnd(
        listener.BeginGetContext,
        listener.EndGetContext
      )

      return! async {
        while not <| token.IsCancellationRequested do
          let! context = task

          let headers =
            [
              for pair in context.Request.Headers do
                yield (pair, context.Request.Headers.[pair])
            ]
            |> fun ls -> String.Join("; ", ls)

          log.Debug <| sprintf "Received headers %A" headers

          if context.Request.Headers.["Connection"] = "Upgrade" then
            log.Debug("Got websocket upgrade request!")
            HandleSocket(context) |> agent.Post
          else
            RouteWork <| Handle(context.Request, context.Response) |> agent.Post

        // Token is cancelled.
        listener.Stop()
      }
    }

    member this.stop () =
      tokenSource.Cancel()
      agent.Post Kill

    member this.handleSocket handler =
      agent.Post <| AddSocketHandler handler

    member this.handle serverModule =
      agent.Post <| AddModule serverModule

    member this.get serverModule =
      // We need to only handle this on HTTP 
      let _serverModule = {
        handler = fun req resp -> async {
          if req.HttpMethod = "GET" then
            return! serverModule.handler req resp
          else
            return false
        }
        priority = serverModule.priority
      }
      agent.Post <| AddModule _serverModule

  type private WebServerBundle (log, id) =
    inherit IBundle()
    let server = Server(log)

    let mutable listenTasks = Map.empty<string, Task>

    let startListening host port =
      try
        let endPoint = sprintf "http://%s:%i" host port

        server.listen host port
        |> Async.StartAsTask
        |> fun task -> listenTasks <- listenTasks.Add(endPoint, task)
        |> fun () -> Choice1Of2 ()
      with e -> Choice2Of2 e

    override this.Id = id

    override this.PreRestart (e, context) =
      log.Warn <| sprintf "Error: %A" e

    override this.Receive (msg, sender) =
      match msg with
      | :? Msg as msg ->
        match msg with
        | AddHandler(handler, priority) ->
          do server.handle {
            handler = handler
            priority = priority
          }

        | AddWsHandler (handler) ->
          do server.handleSocket handler

        | Listen (host, port) ->
          let reply = startListening host port |> ListenReply
          sender |> Option.iter (fun sender -> sender.Send reply)

  let create (platform:IPlatform) id =
    match platform.Lookup id with
    | Some bundleRef -> bundleRef
    | None ->
      let log = LogBundle.log platform (id + ":log")
      let bundle = WebServerBundle (log, id)
      platform.Register bundle
      match platform.Lookup id with
      | Some bundleRef -> bundleRef
      | None -> failwith "Unable to link bundle"

