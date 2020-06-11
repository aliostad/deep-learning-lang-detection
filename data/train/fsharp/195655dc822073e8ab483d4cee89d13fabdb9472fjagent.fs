//how to use fsprogram: http://fsharp.org/use/windows/

open System

module jdaemon =
  open System
  open System.Threading
  open System.IO
  open System.Diagnostics

  let execute_command_in_process (cmd : string) = 
    let executor = "cmd"
    let command  = sprintf """/c "%s" """ cmd
    let start_info = 
      ProcessStartInfo
        ( FileName               = executor
        , Arguments              = command
        , RedirectStandardOutput = true
        , RedirectStandardError  = true
        , UseShellExecute        = false
        , CreateNoWindow         = true)
    new Process( StartInfo = start_info )

  type Process with
    member this.ReadErrorLines  () = seq { while not this.HasExited do yield this.StandardError. ReadLine() }
    member this.ReadOutputLines () = seq { while not this.HasExited do yield this.StandardOutput.ReadLine() }

  let create_task (cmd : string) (check_function : (string -> 'a option)) =
      let  proc : Process = execute_command_in_process cmd
  //    proc.Exited.Add (fun e -> printfn "exited with code: %A" proc.ExitCode; )

      let on_read_error (line : string) = 
        printfn "stderr: %A" line
        check_function line |> function 
        | Some e -> printfn "error: %A in %A" e line; proc.Kill()
        | None   -> ()
    
      let on_read_output (line : string) = printfn "stdout: %A" line

      let stderr_output = async { proc.ReadErrorLines()  |> Seq.filter (not << isNull) |> Seq.iter on_read_error  }
      let stdout_output = async { proc.ReadOutputLines() |> Seq.filter (not << isNull) |> Seq.iter on_read_output }

      proc.Start() |>ignore
      [ stderr_output; stdout_output ]
      |> Async.Parallel
      |> Async.RunSynchronously
      |> ignore

      proc.WaitForExit()
      proc.ExitCode

  let start_jdaemon (cmd : string) =
    let error_ids = 
      [ "2"
        "55"
        "7" ]
    let check_function (line : string) = error_ids |> Seq.tryFind line.Contains
    let delay_time = 10;
    let on_command_finished exit_code = printfn "process exit code: %A\nwaiting for %Asec\n" exit_code delay_time; Thread.Sleep (delay_time*1000)

    Seq.initInfinite (fun _ -> create_task cmd check_function) |> Seq.iter on_command_finished


let main argv = 
  match argv with
  | [| cmd |] -> jdaemon.start_jdaemon cmd
  | otherwise -> ()
  0

#if INTERACTIVE
fsi.CommandLineArgs |> Array.skip 1 |> main
#else
[<EntryPoint; STAThread>]
let entryPoint args = main args
#endif