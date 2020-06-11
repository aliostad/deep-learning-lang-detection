// purpose: call the installmacros.bat, capturing outputs and info
//WIP: not working yet, timed out
// consider: switching the process helpers to use ProcessMacros with observable output messages

// dogfooding, if the script we are going to call is going to use the dlls present here, use them, or will that lock the assemblies?
[<Literal>]
let TargetDir = @"C:\projects\fsinteractive"
#I @"C:\projects\fsinteractive"
#r "BReusable"
open System
open BReusable
Environment.CurrentDirectory <- @"C:\projects\fsinteractive"
// from https://github.com/fsharp/FAKE/blob/master/src/app/FakeLib/ProcessHelper.fs#L68
module ProcessHelper = 
    open System.Diagnostics
    open System.IO
    open System.Text
    open System.Collections.Concurrent
    type ConcurrentBag<'T> with
        member this.Clear() = 
            while not (this.IsEmpty) do
                this.TryTake() |> ignore
    let startedProcesses = ConcurrentBag()
    /// A record type which captures console messages
    type ConsoleMessage = 
        { IsError : bool
          Message : string
          Timestamp : DateTimeOffset }
    type ExitType = 
        |Code of int
        |Exception of exn
    /// A process result including error code, message log and errors.
    type ProcessResult = 
        { Exit : ExitType
          Messages : ResizeArray<string>
          Errors : ResizeArray<string> }
        member x.OK = match x.Exit with | Code x -> x = 0 | Exception _ -> false
        static member New exitType messages errors = 
            { Exit = exitType
              Messages = messages
              Errors = errors }
    type ExternalDependencies = {
        IsMono: bool
        EnableProcessTracing: bool
        PlatformInfoAction: System.Diagnostics.ProcessStartInfo -> unit
        Tracefn: string -> string -> string -> unit
        TraceError: string -> unit
        Logfn: string -> string -> unit
        MonoPath: string
        Warn: string -> unit
        Trace: string -> unit}
    let defaultExternals = {IsMono = false; EnableProcessTracing = false; PlatformInfoAction = (fun _ -> ()); Tracefn = (fun _ _ _ -> ());TraceError = (fun _ -> ()); Logfn = (fun _ _ -> ()); MonoPath = null; Warn = (fun _ -> ()); Trace = fun _ -> ()}
    let start logfn isMono monoPath (proc : Process) = 
        try
            System.Console.OutputEncoding <- System.Text.Encoding.UTF8
        with exn ->
            logfn "Failed setting UTF8 console encoding, ignoring error... %s." exn.Message

        if isMono && proc.StartInfo.FileName.ToLowerInvariant().EndsWith(".exe") then
            proc.StartInfo.Arguments <- "--debug \"" + proc.StartInfo.FileName + "\" " + proc.StartInfo.Arguments
            proc.StartInfo.FileName <- monoPath
        proc.Start() |> ignore
        startedProcesses.Add(proc.Id, proc.StartTime) |> ignore

    let ExecProcessWithLambdas externalDependencies configProcessStartInfoF (timeOut : TimeSpan) silent errorF messageF = 
        use proc = new Process()
        proc.StartInfo.UseShellExecute <- false
        configProcessStartInfoF proc.StartInfo
        externalDependencies.PlatformInfoAction proc.StartInfo
        if String.IsNullOrEmpty proc.StartInfo.WorkingDirectory |> not then 
            if Directory.Exists proc.StartInfo.WorkingDirectory |> not then 
                failwithf "Start of process %s failed. WorkingDir %s does not exist." proc.StartInfo.FileName 
                    proc.StartInfo.WorkingDirectory
        if silent then 
            proc.StartInfo.RedirectStandardOutput <- true
            proc.StartInfo.RedirectStandardError <- true
            if externalDependencies.IsMono then
                proc.StartInfo.StandardOutputEncoding <- Encoding.UTF8
                proc.StartInfo.StandardErrorEncoding  <- Encoding.UTF8
            proc.ErrorDataReceived.Add(fun d -> 
                if d.Data <> null then errorF d.Data)
            proc.OutputDataReceived.Add(fun d -> 
                if d.Data <> null then messageF d.Data)
        try 
            if externalDependencies.EnableProcessTracing && (not <| proc.StartInfo.FileName.EndsWith "fsi.exe") then 
                externalDependencies.Tracefn "%s %s" proc.StartInfo.FileName proc.StartInfo.Arguments
            start externalDependencies.Logfn externalDependencies.IsMono externalDependencies.MonoPath proc
        with exn -> failwithf "Start of process %s failed. %s" proc.StartInfo.FileName exn.Message
        if silent then 
            proc.BeginErrorReadLine()
            proc.BeginOutputReadLine()
        if timeOut = TimeSpan.MaxValue then proc.WaitForExit()
        else 
            if not <| proc.WaitForExit(int timeOut.TotalMilliseconds) then 
                try 
                    proc.Kill()
                with exn -> 
                    externalDependencies.TraceError 
                    <| sprintf "Could not kill process %s  %s after timeout." proc.StartInfo.FileName 
                           proc.StartInfo.Arguments
                failwithf "Process %s %s timed out." proc.StartInfo.FileName proc.StartInfo.Arguments
        // See http://stackoverflow.com/a/16095658/1149924 why WaitForExit must be called twice.
        proc.WaitForExit()
        proc.ExitCode
    let ExecProcessAndReturnMessages externalDependencies configProcessStartInfoF timeOut = 
        let errors = ResizeArray<_>()
        let messages = ResizeArray<_>()
        try
            let exitCode = ExecProcessWithLambdas externalDependencies configProcessStartInfoF timeOut true (errors.Add) (messages.Add)
            ProcessResult.New (ExitType.Code exitCode) messages errors
        with ex ->
            ProcessResult.New (ExitType.Exception ex) messages errors
    let execProcessAndReturnMessages = ExecProcessAndReturnMessages defaultExternals

    /// Runs the given process and returns the process result.
    /// ## Parameters
    ///
    ///  - `configProcessStartInfoF` - A function which overwrites the default ProcessStartInfo.
    ///  - `timeOut` - The timeout for the process.
    let ExecProcessRedirected externalDependencies configProcessStartInfoF timeOut = 
        let messages = ref []
        
        let appendMessage isError msg = 
            messages := { IsError = isError
                          Message = msg
                          Timestamp = DateTimeOffset.UtcNow } :: !messages
        
        let exitCode = 
            ExecProcessWithLambdas externalDependencies configProcessStartInfoF timeOut true (appendMessage true) (appendMessage false)
        exitCode = 0, 
        (!messages
         |> List.rev
         |> Seq.ofList)
    let execProcessesWithLambdas configProcessStartInfoF (timeOut : TimeSpan) silent errorF messageF = 
        ExecProcessWithLambdas defaultExternals configProcessStartInfoF timeOut silent errorF messageF

    let execProcessRedirected = ExecProcessRedirected defaultExternals
    /// Adds quotes around the string (also escaping the inner quotes)
    /// [omit]
    let quote (str:string) = "\"" + str.Replace("\"","\\\"") + "\""
    /// Adds quotes around the string if needed
    /// [omit]
    let quoteIfNeeded str = 
        if String.IsNullOrEmpty str then ""
        elif str.Contains " " then quote str
        else str
    let findCmd cmd = 
        let externalDependencies = defaultExternals
        let processResult = 
            ExecProcessAndReturnMessages externalDependencies (fun psi ->
                psi.FileName <- "where"
                psi.Arguments <- quoteIfNeeded cmd
            ) (TimeSpan.FromSeconds 2.)
        if processResult.OK then
            // require the result not be a directory
            let cmdPath = 
                processResult.Messages
                |> Seq.filter (Directory.Exists >> not)
                |> Seq.filter (File.Exists)
                |> Seq.filter (fun x -> x.EndsWith ".bat" || x.EndsWith ".exe" || x.EndsWith ".cmd")
                |> Seq.tryHead
            if processResult.Messages.Count > 1 then
                externalDependencies.Warn (sprintf "found multiple items matching '%s'" cmd)
                externalDependencies.Trace (processResult.Messages |> delimit ";")
            match cmdPath with
            | Some path ->
                externalDependencies.Trace (sprintf "found %s at %s" cmd path)
                Some path
            | None ->
                externalDependencies.Warn "where didn't return a valid file"
                None
        else None
    let runWithOutput cmd args timeOut = 
        let cmd = 
            // consider: what if the cmd is in the current dir? where may find one elsewhere first?
            if Path.IsPathRooted cmd then
                cmd
            else
                match findCmd cmd with
                | Some x -> x
                | None ->
                    defaultExternals.Warn (sprintf "findCmd didn't find %s" cmd)
                    cmd
        let result = 
            execProcessAndReturnMessages (fun f ->
                f.FileName <- cmd
                f.Arguments <- args
            ) timeOut
        result,cmd
TimeSpan.FromMinutes 2.0
|> ProcessHelper.runWithOutput "installMacros.bat" null 
