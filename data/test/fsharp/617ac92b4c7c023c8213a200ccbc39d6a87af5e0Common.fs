[<AutoOpen>]
module CsTasks.Common

open System
open System.ComponentModel
open System.Diagnostics
open System.IO
open System.Threading
open System.Collections.Generic

let MaxTimeSpan() = TimeSpan.MaxValue
let CsTasksToolPathFromFileName fileName = FindInExecutingAssemglyLocation fileName 

//Hacked this trace in when removing fake
let trace (message:string) = System.Console.WriteLine(message)

//Hacked this out of FAKE while removing dependency on it.
let ExecProcessWithLambdas infoAction (timeOut:TimeSpan) silent errorF messageF =
    use p = new Process()
    p.StartInfo.UseShellExecute <- false
    infoAction p.StartInfo
    if silent then
        p.StartInfo.RedirectStandardOutput <- true
        p.StartInfo.RedirectStandardError <- true
        p.ErrorDataReceived.Add (fun d -> if d.Data <> null then errorF d.Data)
        p.OutputDataReceived.Add (fun d -> if d.Data <> null then messageF d.Data)
    try
        //TODO put some tracing back?
        p.Start() |> ignore
    with
    | exn -> failwithf "Start of process %s failed. %s" p.StartInfo.FileName exn.Message

    if silent then
        p.BeginErrorReadLine()
        p.BeginOutputReadLine()     
  
    if timeOut = TimeSpan.MaxValue then
        p.WaitForExit()
    else
        if not <| p.WaitForExit(int timeOut.TotalMilliseconds) then
            try
                p.Kill()
            with _ -> ()  
            failwithf "Process %s %s timed out." p.StartInfo.FileName p.StartInfo.Arguments
    
    p.ExitCode

let ExecProcess infoAction (timeOut:TimeSpan) =
    let nullFunc = fun s -> ()
    ExecProcessWithLambdas infoAction timeOut false nullFunc nullFunc 
