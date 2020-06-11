#r "packages/Suave/lib/net40/Suave.dll"
open Suave
open Suave.Operators
open Suave.Filters
open Suave.Successful
open System
open System.Diagnostics
open System.Text

type ProcessResult = { exitCode : int; stdout : string; stderr : string }

let executeProcess exe cmdline =
    let psi = new System.Diagnostics.ProcessStartInfo(exe,cmdline)
    psi.UseShellExecute <- false
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true
    psi.CreateNoWindow <- true
    let p = Process.Start(psi)
    let output = new StringBuilder()
    let error = new StringBuilder()
    p.OutputDataReceived.Add(fun args -> output.Append(args.Data) |> ignore)
    p.ErrorDataReceived.Add(fun args -> error.Append(args.Data) |> ignore)
    p.BeginErrorReadLine()
    p.BeginOutputReadLine()
    p.WaitForExit()
    { exitCode = p.ExitCode; stdout = output.ToString(); stderr = error.ToString() }

let handle: WebPart =
  fun ctx ->
    async {
      let input = ctx.request.formData "to-say"
      match input with
      | Choice1Of2 input ->
        // note; vulnerable to command injection
        let out = executeProcess "say" input
        return! Redirection.FOUND "/" ctx
      | Choice2Of2 err ->
        return! RequestErrors.BAD_REQUEST err ctx
    }

let app: WebPart =
  choose [
    POST >=> handle
    Files.browseFileHome "index.html"
  ]

let config =
  { defaultConfig with bindings = [ HttpBinding.createSimple HTTP "127.0.0.1" 8001 ]
                       homeFolder = Some Environment.CurrentDirectory }

startWebServer config app
