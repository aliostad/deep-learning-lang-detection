open System
open System.IO
open System.Net

type Handler = HttpListenerRequest -> HttpListenerResponse -> unit Async

do
use listener = new HttpListener()

let host = "http://+:8080/"
do
  listener.Prefixes.Add host
  listener.Start()


let contentType = function
  | ".js" -> "text/javascript"
  | ".html" -> "text/html"
  | ".css" -> "text/css"
  | any -> ""

let fileResponse filepath (resp:HttpListenerResponse) = async {
  use resp = resp
  use reader = File.OpenRead filepath
  let ext = Path.GetExtension(filepath)
  do
    resp.AppendHeader("Content-Type", contentType ext)
  do! reader.CopyToAsync resp.OutputStream |> Async.AwaitTask
}

let workingDir = Path.Combine(__SOURCE_DIRECTORY__, "static")

let (|StaticHandler|_|) (req:HttpListenerRequest) =
  let path = Path.Combine(workingDir, req.Url.LocalPath.Replace('/', '\\').Substring 1)
  if File.Exists path then Some (fileResponse path)
  else None

let mainHandler: Handler = function
  | StaticHandler handler -> handler
  | req -> fun resp -> async {
    use resp = resp

    resp.StatusCode <- 404
    resp.StatusDescription <- "Not found"
    ()
  }

async {
  printfn "Running"
  while listener.IsListening do
    let! ctx = listener.GetContextAsync() |> Async.AwaitTask
    try
      do! mainHandler ctx.Request ctx.Response
    with e ->
      printfn "Error: %A" e
}
|> Async.RunSynchronously