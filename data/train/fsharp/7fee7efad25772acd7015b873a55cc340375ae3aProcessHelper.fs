namespace ProFSharp.Process

open System
open System.Diagnostics

type ProcessHelper =
    static member ExecuteProcess filename arguments =
        let FormatError filename arguments error =
            String.Format("Error occured executing process: [{0}]\r\n"
                + " with arguments: [{1}]\r\n" 
                + " message: [{2}]", 
                    filename, arguments, error)
        let startInfo = new ProcessStartInfo(
                            filename, 
                            arguments, 
                            UseShellExecute = false, 
                            RedirectStandardOutput = true, 
                            RedirectStandardError = true)
        try
            
            use proc = Process.Start(startInfo)
            let out = proc.StandardOutput.ReadToEnd()
            let error = proc.StandardError.ReadToEnd()
            proc.WaitForExit()
            if (error.Length = 0) then
                out
            else
                FormatError filename arguments error
        with
            _ as ex  
                -> FormatError filename arguments ex
