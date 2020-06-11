namespace DotNetMon

module IoUtils = 
    open System.IO
    open System.Diagnostics
    open System
    open System.Reflection
    
    type Result<'TSuccess,'TFailure> = 
    | Success of 'TSuccess
    | Failure of 'TFailure
        
    let startProcess (processInfo : ProcessStartInfo) = 
        use proc = Process.Start processInfo
        proc.ErrorDataReceived.Add(fun err -> printfn "%s" err.Data)
        proc.OutputDataReceived.Add(fun data -> printfn "%s" data.Data)
        proc.BeginOutputReadLine()
        proc.BeginErrorReadLine()
        ()
    
    let processStartWrapper (program : string) (args : string) = 
        let prcss = new ProcessStartInfo()
        prcss.Arguments <- args
        prcss.FileName <- program
        prcss.CreateNoWindow <- true
        prcss.RedirectStandardInput <- false
        prcss.RedirectStandardOutput <- true
        prcss.RedirectStandardError <- true
        prcss.UseShellExecute <- false
        prcss
    
    let cleanStringArgs (splitBy : char array) (args : string) = 
        args.Split(splitBy, StringSplitOptions.RemoveEmptyEntries)
        |> Array.filter (fun s -> not (String.IsNullOrWhiteSpace s))
        |> Array.map (fun s -> s.Trim())
    
    let strEquals (equalsTo : string) (str : string) = str.Equals(equalsTo, StringComparison.OrdinalIgnoreCase)
    
    let buildDefaults (currentDir : string) (args : string array) = 
        let checkServerparam arr = 
            if not (arr |> Array.exists (fun s -> s |> strEquals Constants.Lserver)) then 
                if File.Exists(Path.Combine(currentDir, "project.json")) then 
                    arr |> Array.append [| " --server kestrel ." |]
                else arr
            else arr
        
        let checkWatchParam arr = 
            if not (arr |> Array.exists (fun s -> s
                                                  |> strEquals Constants.Lwatch
                                                  || s |> strEquals Constants.Swatch)) then 
                arr |> Array.append [| Constants.Lwatch + " " + currentDir |]
            else 
                for i in 0..arr.Length - 1 do
                    if arr.[i]
                       |> strEquals Constants.Lwatch
                       || arr.[i] |> strEquals Constants.Swatch then 
                        arr.[i + 1] <- Path.Combine(currentDir, arr.[i + 1])
                arr
        
        let curateIgnores (arr : string array) = 
            for i in 0..arr.Length - 1 do
                if arr.[i]
                   |> strEquals Constants.Signore
                   || arr.[i] |> strEquals Constants.Lignore then arr.[i + 1] <- Path.Combine(currentDir, arr.[i + 1])
            arr
        
        args
        |> checkServerparam
        |> checkWatchParam
        |> curateIgnores
        |> String.concat " "
        |> cleanStringArgs [| ' ' |]
    
    let isFile path = 
        if Directory.Exists path || File.Exists path then 
            Success (Path.HasExtension path)
        else 
            Failure(sprintf "file or directory not found:\r\n%s" path)
            
    
    let runActions fileName (filters : (string -> bool) list) (commands : ProcessStartInfo list) 
        (sideActions : (unit -> unit) list) = 
        let all = 
            filters
            |> List.map (fun apply -> apply fileName)
            |> List.forall (fun success -> success)
        if all then 
            sideActions |> List.iter (fun act -> act())
            commands |> List.iter (fun proc -> startProcess proc)

    let getAssemblyVersion() =
        let assembly = Assembly.GetExecutingAssembly()
        let fileVersionInfo = FileVersionInfo.GetVersionInfo(assembly.Location)
        fileVersionInfo.ProductVersion
