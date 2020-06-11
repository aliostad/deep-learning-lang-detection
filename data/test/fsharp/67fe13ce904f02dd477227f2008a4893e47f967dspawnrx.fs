
module Spawn

  open System
  open System.Diagnostics

  type SpawnProgress =
    {StdOut: string option
     StdErr: string option
     ExitCode: int option}

  let private setEnvironmentVariables (startInfo : ProcessStartInfo) environmentSettings =
    for key, value in environmentSettings do
      if startInfo.EnvironmentVariables.ContainsKey key
      then startInfo.EnvironmentVariables.[key] <- value
      else startInfo.EnvironmentVariables.Add(key, value)

  let private waitForExit (p:Process) =
    try
      p.WaitForExit()
      Some p.ExitCode
    with
    |_ -> None

  let private forProcess fileName arguments environmentSettings =
    let ofObj value = match value with null -> None | _ -> Some value
    {new IObservable<_> with
      member x.Subscribe(o) =
        let psi = match arguments with
                  |Some args -> ProcessStartInfo(fileName, args)
                  |None -> ProcessStartInfo(fileName)
        do setEnvironmentVariables psi (defaultArg environmentSettings Seq.empty)
        psi.UseShellExecute <- false
        psi.RedirectStandardOutput <- true
        psi.RedirectStandardError <- true
        psi.RedirectStandardInput <- true
        let p = Process.Start(psi)
        p.EnableRaisingEvents <- true
        p.Exited.Add
          (fun _ -> o.OnNext({StdOut=None;StdErr=None;ExitCode=waitForExit p})
                    o.OnCompleted())
        p.OutputDataReceived.Add (fun t -> o.OnNext({StdOut=ofObj t.Data;StdErr=None;ExitCode=None}))
        p.ErrorDataReceived.Add (fun t -> o.OnNext({StdOut=None;StdErr=ofObj t.Data;ExitCode=None}))
        p.BeginOutputReadLine()
        p.BeginErrorReadLine()
        p.StandardInput.Close()
        {new IDisposable with
          member x.Dispose () =
            if not p.HasExited then
              try p.Kill() with |_ -> ()
            p.Dispose() }}

  type Observable =
    static member ForProcess(fileName, ?arguments, ?environmentSettings) =
      forProcess fileName arguments environmentSettings