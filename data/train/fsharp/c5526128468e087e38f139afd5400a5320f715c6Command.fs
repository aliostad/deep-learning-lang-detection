module Command

open System.Diagnostics

let ENCODING_GERMAN = System.Text.Encoding.GetEncoding(437)

let Exec command options update = 
    let psi = new ProcessStartInfo(command, options)
    let proc = new Process(StartInfo = psi, EnableRaisingEvents = true)

    psi.UseShellExecute <- false 
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true 
    psi.CreateNoWindow <- true
    psi.StandardOutputEncoding <- ENCODING_GERMAN
    
    proc.OutputDataReceived.Add update
    proc.Start() |> ignore
    proc.BeginOutputReadLine()
    proc.BeginErrorReadLine()
    proc.WaitForExit()

let ExecString command update = Exec "cmd" ("/C " + command) update