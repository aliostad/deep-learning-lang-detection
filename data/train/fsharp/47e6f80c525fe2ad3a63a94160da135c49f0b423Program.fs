module Program
  
open System.Threading
open Suave
open Suave.Http
open Suave.Web
open Suave.Logging

open Topshelf



[<EntryPoint>]
let main _ =     
  let cts = new CancellationTokenSource()
  
  let config =
    { defaultConfig with
        bindings = [HttpBinding.mkSimple Protocol.HTTP "127.0.0.1" 8081];
        cancellationToken = cts.Token;
        logger = SuaveAdapter(Logging.getLogger "Api"); }

  let start _ =
    startWebServerAsync config Routes.routes
    |> snd
    |> Async.StartAsTask
    |> ignore
    true

  let stop _ =
    cts.Cancel()
    true

  Service.Default
  |> display_name "BlueZeus Api"
  |> instance_name "BlueZeusApi"
  |> with_start start
  |> with_stop stop
  |> run