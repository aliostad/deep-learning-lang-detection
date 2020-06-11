namespace Tfs.Build.Paket

module Utils =
    let ensureDir dir =
        if System.IO.Directory.Exists(dir) |> not 
        then System.IO.Directory.CreateDirectory(dir) |> ignore
        
    let isNullOrEmpty (s :string) =
        s = null || s = ""
    
    let getFilesRec source pattern =
        System.IO.Directory.GetFiles(source, pattern, System.IO.SearchOption.AllDirectories) |> List.ofArray        
     
    let runexe exeName errFunc outputFunc =
        let mutable processInfo = new System.Diagnostics.ProcessStartInfo(exeName)
        processInfo.CreateNoWindow <- true
        processInfo.RedirectStandardError <- true
        processInfo.RedirectStandardOutput <- true
        processInfo.UseShellExecute <- false
        let mutable proc = new System.Diagnostics.Process()
        proc.StartInfo <- processInfo
        proc.ErrorDataReceived.Add(errFunc)   
        proc.OutputDataReceived.Add(outputFunc)
        proc.Start() |> ignore
        proc.WaitForExit()        
        proc.ExitCode