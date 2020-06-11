open System
open System.IO
open System.Diagnostics

module LiveScript =

    let toJs (source : string) =
        let processInfo =
            new ProcessStartInfo
                ("cmd", "/C livescript -c -s -b",
                    CreateNoWindow = true,
                    UseShellExecute = false,
                    RedirectStandardInput = true,
                    RedirectStandardOutput = true)
        let proc = Process.Start(processInfo)
        let streamWriter = proc.StandardInput
        streamWriter.Write(source)
        streamWriter.Close()
        proc.WaitForExit()
        let output = proc.StandardOutput;
        let result = output.ReadToEnd()
        output.Close()
        proc.Close() |> ignore
        result

@"[1, 2, 3] |> map (*2)" |> LiveScript.toJs