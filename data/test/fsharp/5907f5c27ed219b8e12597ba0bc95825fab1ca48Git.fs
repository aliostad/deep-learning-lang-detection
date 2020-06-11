module Spig.Git

open System.Collections.Generic
open System.Diagnostics

let private executeProcess name commandLineArgs workingDirectory = 
    let psi = new ProcessStartInfo(name, commandLineArgs) 
    psi.UseShellExecute <- false
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true
    psi.CreateNoWindow <- true
    psi.WorkingDirectory <- workingDirectory
    
    let p = Process.Start(psi) 
    let output = new List<string>()
    let error = new List<string>()
    p.OutputDataReceived.Add(fun args -> output.Add(args.Data) |> ignore)
    p.ErrorDataReceived.Add(fun args -> error.Add(args.Data) |> ignore)
    p.BeginErrorReadLine()
    p.BeginOutputReadLine()
    p.WaitForExit()
    
    (output, error)

let readCommitsBy author workingDirectory =
    let command = sprintf "log --author=%s --no-merges --oneline --pretty=%%h" author
    let output, _ = executeProcess "git" command workingDirectory 
    output |> List.ofSeq

let readCommitChanges hash workingDirectory =
    let command = sprintf "diff %s^!" hash
    let output, _ = executeProcess "git" command workingDirectory 
    output |> List.ofSeq


