namespace SemVer.FromAssembly
open System.Diagnostics
open System.Text
open System
module Process=
    let executeDotnetExe exe args : Result<string,string>=
        use p = new Process()
        let isRunningMono = Type.GetType ("Mono.Runtime") <> null
        let fileName = if isRunningMono then "mono" else exe
        let arguments = if isRunningMono then sprintf "'%s' %s" exe args else args
        let st = ProcessStartInfo()
        st.CreateNoWindow <- true
        st.UseShellExecute <- false
        st.RedirectStandardOutput <- true
        st.RedirectStandardError <-true
        st.FileName <- fileName
        st.WorkingDirectory <- Environment.CurrentDirectory
        st.Arguments <- arguments
        let output = new StringBuilder()
        let error = new StringBuilder()
        let createDataReceivedHandler (b:StringBuilder) =
                new DataReceivedEventHandler(fun sender e->
                    if e.Data <> null then
                        b.Append(e.Data) |> ignore
                    else
                        ()
                )

        p.OutputDataReceived.AddHandler(createDataReceivedHandler output)
        p.ErrorDataReceived.AddHandler(createDataReceivedHandler error)
        p.StartInfo <- st
        if p.Start() then
            p.BeginOutputReadLine()
            p.BeginErrorReadLine()
            p.WaitForExit()
            match p.ExitCode with
            | 0-> Ok (output.ToString())
            | _-> Error (error.ToString())
        else
            Error "Couldn't start process"
