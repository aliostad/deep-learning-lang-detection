module BigQueryProvider.ProcessHelper
open System.Diagnostics

type ProcessResult = { exitCode : int; stdout : string; stderr : string }
let executeProcess exec cmdLine = 
    let psi = ProcessStartInfo(exec, cmdLine)
    psi.UseShellExecute <- false
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true
    psi.CreateNoWindow <- true        
    let p = System.Diagnostics.Process.Start(psi) 
    let output = System.Text.StringBuilder()
    let error = System.Text.StringBuilder()
    p.OutputDataReceived.Add(fun args -> output.Append(args.Data) |> ignore)
    p.ErrorDataReceived.Add(fun args -> error.Append(args.Data) |> ignore)
    p.BeginErrorReadLine()
    p.BeginOutputReadLine()
    p.WaitForExit()
    { exitCode = p.ExitCode; stdout = output.ToString(); stderr = error.ToString() }
