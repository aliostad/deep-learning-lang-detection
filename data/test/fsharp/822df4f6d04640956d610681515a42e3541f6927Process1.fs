module Process1

open System.Diagnostics

let startProcess fileName arguments = 
    use p = Process.Start(fileName, arguments)
    p.Start() |> ignore
    p.WaitForExit()

let startProcess2 fileName (arguments : string option) = 
    let psi = 
        match arguments with
        | Some args -> ProcessStartInfo(fileName, args)
        | None -> ProcessStartInfo(fileName)
    psi.CreateNoWindow <- true
    psi.UseShellExecute <- false
    psi.WindowStyle <- ProcessWindowStyle.Hidden
    psi.RedirectStandardInput <- true
    psi.RedirectStandardOutput <- true
    psi.RedirectStandardError <- true
    let p = Process.Start(psi)
    p.WaitForExit()
    if p.ExitCode <> 0 then failwithf "%A" (p.StandardError.ReadToEnd())
    p.StandardOutput.ReadToEnd()