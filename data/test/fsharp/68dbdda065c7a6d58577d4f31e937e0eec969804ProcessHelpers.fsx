open System
open System.Diagnostics
open System.IO
open System.Text
open Fake

module ProcessHelpers =
    let Spawn (processName:string, arguments:string) =
        let startInfo = new System.Diagnostics.ProcessStartInfo(processName)
        startInfo.Arguments <- arguments
        startInfo.RedirectStandardInput <- true
        startInfo.RedirectStandardOutput <- true
        startInfo.RedirectStandardError <- true
        startInfo.UseShellExecute <- false
        startInfo.CreateNoWindow <- true
        startInfo.StandardOutputEncoding <- Encoding.UTF8
        startInfo.StandardErrorEncoding <- Encoding.UTF8

        let result = new StringBuilder()

        let resultHandler (_sender:obj) (args:DataReceivedEventArgs) = result.AppendLine args.Data |> ignore
        let outputHandler (_sender:obj) (args:DataReceivedEventArgs) = Console.WriteLine args.Data

        use proc = new System.Diagnostics.Process(StartInfo = startInfo)
        proc.EnableRaisingEvents <- true
        
        proc.OutputDataReceived.AddHandler(DataReceivedEventHandler (resultHandler))
        proc.ErrorDataReceived.AddHandler(DataReceivedEventHandler (resultHandler))

        proc.OutputDataReceived.AddHandler(DataReceivedEventHandler (outputHandler))
        proc.ErrorDataReceived.AddHandler(DataReceivedEventHandler (outputHandler))
        
        proc.Start() |> ignore
        proc.BeginOutputReadLine()
        proc.BeginErrorReadLine()
        proc.WaitForExit()
        if proc.ExitCode <> 0 then 
            failwith ("Problems spawning ("+processName+") with arguments ("+arguments+"): \r\n" +  proc.StandardError.ReadToEnd())

        proc.Close()
        
        result.ToString()
