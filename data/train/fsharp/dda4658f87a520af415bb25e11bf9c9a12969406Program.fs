open System
open Cronix
open Chessie.ErrorHandling
open System.Threading
open Cronix.Web

let sampleJob (token : CancellationToken) = 
      printf "callback executed at (UTC) %s\n" <| DateTime.UtcNow.ToString()
      Thread.Sleep(10000)
 
[<EntryPoint>]
let main argv = 
 
    let startupHandler = 
        new StartupHandler(
            fun(scheduler) ->

                        WebPlugin.InitPlugin(scheduler) |> ignore

                        scheduler.ScheduleJob "scheduled job" <| "* * * * *" <| JobCallback( sampleJob ) |> ignore
                        scheduler.ScheduleJob "second name" <| frequency Hourly <| JobCallback( sampleJob ) |> ignore
            )

    let result = BootStrapper.InitService(argv, startupHandler)
    match result with
    | Ok (state, msgs) -> printfn "%s" state
    | Fail msgs -> msgs |> List.iter(fun(s) ->  printfn "%s" s)
    | _ -> ()
    0 // return an integer exit code
