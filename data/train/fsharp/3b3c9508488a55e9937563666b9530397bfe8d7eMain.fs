module Dale.Server

open System
open System.Net.Http
open System.Web.Http
open System.Web.Http.SelfHost
open Dale.Middleware
open Dale

// This adapter pinched from github.com/frank-fs/frank
type AsyncAdapter =
  inherit DelegatingHandler
  val AsyncSend : HttpRequestMessage -> Async<HttpResponseMessage>
  new (f, inner) = { inherit DelegatingHandler(inner); AsyncSend = f }
  new (f) = { inherit DelegatingHandler(); AsyncSend = f }
  override x.SendAsync(request, cancellationToken) =
    Async.StartAsTask(x.AsyncSend request, cancellationToken = cancellationToken)


let listener (handler :HttpRequestMessage -> Async<HttpResponseMessage>) =
  let adapter = new AsyncAdapter(handler)
  let route = new Routing.HttpRoute("notify", null, null, null, adapter)
  let host = "http://localhost:" + Environment.GetEnvironmentVariable("Port")
  let mutable conf = new HttpSelfHostConfiguration(host)
  conf.Routes.Add("Notify", route) |> ignore
  conf.IncludeErrorDetailPolicy = IncludeErrorDetailPolicy.Always |> ignore
  conf.EnableSystemDiagnosticsTracing() |> ignore
  new HttpSelfHostServer(conf)

let varNotFound name  =
  printfn "%s %s %s" "Required env var" name "not set!"
  Environment.Exit(1)

let ensureEnvVar name =
  let res = Environment.GetEnvironmentVariable(name)
  match res with
    | "" -> varNotFound name
    | null -> varNotFound name
    | _ -> ()

[<EntryPoint>]
let main argv =
  ensureEnvVar "Tenant"
  ensureEnvVar "ClientId"
  ensureEnvVar "ClientSecret"
  ensureEnvVar "AzureConnectionString"
  ensureEnvVar "Port"
  let conf =
    { Tenant = Environment.GetEnvironmentVariable("Tenant");
      ClientId = Environment.GetEnvironmentVariable("ClientId");
      ClientSecret = Environment.GetEnvironmentVariable("ClientSecret");
      AzureConnectionString = Environment.GetEnvironmentVariable("AzureConnectionString");
      AzureQueueName = "dale-auditeventqueue";
      RedactedFields = Set.ofArray [||];
      PartiallyRedactedFields = Set.ofArray [||]; }

  let exporter = new Dale.Exporter(conf)
  let server = listener exporter.AsyncHandler
  server.OpenAsync().Wait()
  System.Console.ReadKey() |> ignore
  0
