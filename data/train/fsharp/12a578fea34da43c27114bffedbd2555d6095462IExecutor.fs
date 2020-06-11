namespace VSSonarQubeCmdExecutor

open System
open System.IO
open System.Threading
open System.Diagnostics
open System.Management
open Microsoft.FSharp.Collections
open Microsoft.Build.Utilities
open System.Runtime.InteropServices
open VSSonarPlugins

type VSSonarQubeCmdExecutor(timeout : int64) =
    let addEnvironmentVariable (startInfo:ProcessStartInfo) a b = 
        if not(startInfo.EnvironmentVariables.ContainsKey(a)) then startInfo.EnvironmentVariables.Add(a, b)

    let output : System.Collections.Generic.List<string> = new System.Collections.Generic.List<string>()
    let error : System.Collections.Generic.List<string> = new System.Collections.Generic.List<string>()

    let KillPrograms(currentProcessName : string) =
        if not(String.IsNullOrEmpty(currentProcessName)) then
            try
                let processId = Process.GetCurrentProcess().Id
                let processes = System.Diagnostics.Process.GetProcessesByName(currentProcessName)

                for proc in processes do
                    if processId <> proc.Id then
                        try
                            Process.GetProcessById(proc.Id).Kill()
                        with
                        | ex -> ()
            with
            | ex -> ()

    let toMap dictionary = 
        (dictionary :> seq<_>)
        |> Seq.map (|KeyValue|)
        |> Map.ofSeq

    member val stopWatch = Stopwatch.StartNew()
    member val proc : Process  = new Process() with get, set
    member val returncode : ReturnCode = ReturnCode.Ok with get, set
    member val cancelSignal : bool = false with get, set

    member val Program : string = "" with get, set

    member this.killProcess(pid : int32) : bool =
        let mutable didIkillAnybody = false
        try
            let procs = Process.GetProcesses()
            for proc in procs do
                if this.GetParentProcess(proc.Id) = pid then
                    if this.killProcess(proc.Id) = true then
                        didIkillAnybody <- true

            try
                let myProc = Process.GetProcessById(pid)
                myProc.Kill()
                didIkillAnybody <- true
            with
             | ex -> ()
        with
         | ex -> ()

        didIkillAnybody

    member this.TimerControl() =
        async {
            while not this.cancelSignal do
                if this.stopWatch.ElapsedMilliseconds > timeout then

                    try
                        if this.killProcess(this.proc.Id) then
                            this.returncode <- ReturnCode.Ok
                        else
                            this.returncode <- ReturnCode.NokAppSpecific
                            //this.proc.Kill()
                    with
                     | ex -> ()

                Thread.Sleep(1000)

            if this.stopWatch.ElapsedMilliseconds > timeout then
                this.returncode <- ReturnCode.Timeout
        }

    member this.ProcessErrorDataReceived(e : DataReceivedEventArgs) =
        this.stopWatch.Restart()
        if not(String.IsNullOrWhiteSpace(e.Data)) then
            error.Add(e.Data)
            System.Diagnostics.Debug.WriteLine("ERROR:" + e.Data)
        ()

    member this.ProcessOutputDataReceived(e : DataReceivedEventArgs) =
        this.stopWatch.Restart()
        if not(String.IsNullOrWhiteSpace(e.Data)) then
            output.Add(e.Data)
            System.Diagnostics.Debug.WriteLine(e.Data)
        ()



        member this.GetParentProcess(Id : int32) = 
            let mutable parentPid = 0
            use mo = new ManagementObject("win32_process.handle='" + Id.ToString() + "'")
            let tmp = mo.Get()
            Convert.ToInt32(mo.["ParentProcessId"])

    interface IVSSonarQubeCmdExecutor with
        member this.GetStdOut() =
            output

        member this.GetStdError() =
            error

        member this.GetErrorCode() =
            this.returncode

        member this.CancelExecution() =            
            if this.proc.HasExited = false then
                this.proc.Kill()
            this.cancelSignal <- true
            ReturnCode.Ok

        member this.CancelExecutionAndSpanProcess(processNames : string []) =
            
            if this.proc.HasExited = false then
                processNames |> Array.iter (fun name -> KillPrograms(name))
                if this.proc.HasExited = false then
                    this.proc.Kill()

            this.cancelSignal <- true
            ReturnCode.Ok

        member this.ResetData() =
            error.Clear()
            output.Clear()
            ()

        member this.ExecuteCommand(program, args, env, wd) =
            this.Program <- program
            let startInfo = ProcessStartInfo(FileName = program,
                                             Arguments = args,
                                             WindowStyle = ProcessWindowStyle.Normal,
                                             UseShellExecute = false,
                                             RedirectStandardOutput = true,
                                             RedirectStandardError = true,
                                             RedirectStandardInput = true,
                                             CreateNoWindow = true,
                                             WorkingDirectory = wd)
            toMap env |> Map.iter (addEnvironmentVariable startInfo)

            this.proc <- new Process(StartInfo = startInfo)
            this.proc.ErrorDataReceived.Add(this.ProcessErrorDataReceived)
            this.proc.OutputDataReceived.Add(this.ProcessOutputDataReceived)

            this.proc.EnableRaisingEvents <- true
            let ret = this.proc.Start()

            this.stopWatch.Restart()
            Async.Start(this.TimerControl());

            this.proc.BeginOutputReadLine()
            this.proc.BeginErrorReadLine()
            this.proc.WaitForExit()
            this.cancelSignal <- true
            this.proc.ExitCode

        member this.ExecuteCommand(program, args) =
            let data = new System.Collections.Generic.List<string>()
            let startInfo = ProcessStartInfo(FileName = program,
                                             Arguments = args,
                                             WindowStyle = ProcessWindowStyle.Normal,
                                             UseShellExecute = false,
                                             RedirectStandardOutput = true,
                                             RedirectStandardError = true,
                                             RedirectStandardInput = true,
                                             CreateNoWindow = true)
            let proc = new Process(StartInfo = startInfo)
            let processData(e : DataReceivedEventArgs) =
                if not(String.IsNullOrWhiteSpace(e.Data)) then
                    data.Add(e.Data)
                    System.Diagnostics.Debug.WriteLine("Data Cmd:" + e.Data)
                ()

            proc.ErrorDataReceived.Add(processData)
            proc.OutputDataReceived.Add(processData)
            proc.EnableRaisingEvents <- true
            let ret = proc.Start()
            proc.BeginOutputReadLine()
            proc.BeginErrorReadLine()
            proc.WaitForExit()
            data



        member this.ExecuteCommandWait(program, args, env, wd) =
            this.Program <- program
            let startInfo = ProcessStartInfo(FileName = program,
                                             Arguments = args,
                                             CreateNoWindow = true,
                                             WindowStyle = ProcessWindowStyle.Hidden,
                                             WorkingDirectory = wd)

            toMap env |> Map.iter (addEnvironmentVariable startInfo)

            this.proc <- new Process(StartInfo = startInfo)
            let ret = this.proc.Start()
            this.stopWatch.Restart()
            Async.Start(this.TimerControl());
            this.proc.WaitForExit()
            this.cancelSignal <- true
            this.proc.ExitCode


