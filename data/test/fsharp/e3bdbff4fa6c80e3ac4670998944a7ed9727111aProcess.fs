namespace GitShow

module Process =

    open System.Diagnostics
    open System.Threading
 
      // outputF: string -> unit
      // errorF: string -> unit
    let runProcess outputF errorF exe args =
        use p = new Process()
        p.StartInfo.UseShellExecute <- false
        p.StartInfo.FileName <- exe;
        p.StartInfo.Arguments <- String.concat " " args
        p.StartInfo.RedirectStandardOutput <- true
        p.StartInfo.RedirectStandardError <- true
        p.StartInfo.CreateNoWindow <- true
 
        p.ErrorDataReceived.Add
            (fun d -> if  d.Data <> null then errorF d.Data)
        p.OutputDataReceived.Add
            (fun d -> if d.Data <> null then outputF d.Data)
        p.Start() |> ignore
 
        p.BeginErrorReadLine()
        p.BeginOutputReadLine()    
 
        p.WaitForExit()
 
        p.ExitCode