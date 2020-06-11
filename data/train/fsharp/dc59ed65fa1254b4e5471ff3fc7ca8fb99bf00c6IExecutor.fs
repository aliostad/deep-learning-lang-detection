namespace MsbuildUtilityHelpers

open System
open System.IO
open System.Threading
open System.Diagnostics
open System.Management
open Microsoft.FSharp.Collections
open Microsoft.Build.Utilities
open System.Runtime.InteropServices

type ReturnCode =
   | Ok = 0
   | Timeout = 1
   | NokAppSpecific = 2

[<AllowNullLiteral>]
type ICommandExecutor = 
  abstract member GetStdOut : list<string>
  abstract member GetStdError : list<string>
  abstract member GetErrorCode : ReturnCode
  abstract member CancelExecution : ReturnCode
  abstract member CancelExecutionAndSpanProcess : string [] -> ReturnCode
  abstract member ResetData : unit -> unit
  abstract member GetProcessIdsRunning : string -> Process []


  // no redirection of output
  abstract member ExecuteCommand : string * string * Map<string, string> * string -> int
  abstract member ExecuteCommandWait : string * string * Map<string, string> * string -> int

  // with redirection of output
  abstract member ExecuteCommand : string * string * Map<string, string> * (DataReceivedEventArgs -> unit) * (DataReceivedEventArgs -> unit) * string -> int


type CommandExecutor(logger : TaskLoggingHelper, timeout : int64) =
    let addEnvironmentVariable (startInfo:ProcessStartInfo) a b =
        if not(startInfo.EnvironmentVariables.ContainsKey(a)) then
            startInfo.EnvironmentVariables.Add(a, b)

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

    member val Logger = logger
    member val stopWatch = Stopwatch.StartNew()
    member val proc : Process  = new Process() with get, set
    member val output : string list = [] with get, set
    member val error : string list = [] with get, set
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

                    if not(obj.ReferenceEquals(logger, null)) then
                        logger.LogError(sprintf "Expired Timer: %x " this.stopWatch.ElapsedMilliseconds)

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
            this.error <- this.error @ [e.Data]
            System.Diagnostics.Debug.WriteLine("ERROR:" + e.Data)
        ()

    member this.ProcessOutputDataReceived(e : DataReceivedEventArgs) =
        this.stopWatch.Restart()
        if not(String.IsNullOrWhiteSpace(e.Data)) then
            this.output <- this.output @ [e.Data]
            System.Diagnostics.Debug.WriteLine(e.Data)
        ()

        member this.GetParentProcess(Id : int32) = 
            let mutable parentPid = 0
            use mo = new ManagementObject("win32_process.handle='" + Id.ToString() + "'")
            let tmp = mo.Get()
            Convert.ToInt32(mo.["ParentProcessId"])


    interface ICommandExecutor with

        member this.GetProcessIdsRunning(processName : string) =
            System.Diagnostics.Process.GetProcessesByName(processName)


            
        member this.GetStdOut =
            this.output

        member this.GetStdError =
            this.error

        member this.GetErrorCode =
            this.returncode

        member this.CancelExecution =            
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
            this.error <- []
            this.output <- []
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
            env |> Map.iter (addEnvironmentVariable startInfo)

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


        member this.ExecuteCommand(program, args, env, outputHandler, errorHandler, workingDir) =        
            this.Program <- program       
            let startInfo = ProcessStartInfo(FileName = program,
                                             Arguments = args,
                                             WindowStyle = ProcessWindowStyle.Normal,
                                             UseShellExecute = false,
                                             RedirectStandardOutput = true,
                                             RedirectStandardError = true,
                                             RedirectStandardInput = true,
                                             CreateNoWindow = true,
                                             WorkingDirectory = workingDir)
            env |> Map.iter (addEnvironmentVariable startInfo)

            this.proc <- new Process(StartInfo = startInfo,
                                     EnableRaisingEvents = true)
            this.proc.OutputDataReceived.Add(outputHandler)
            this.proc.ErrorDataReceived.Add(errorHandler)
            let ret = this.proc.Start()

            this.stopWatch.Restart()
            Async.Start(this.TimerControl());

            this.proc.BeginOutputReadLine()
            this.proc.BeginErrorReadLine()
            this.proc.WaitForExit()
            this.proc.Id
            this.cancelSignal <- true
            this.proc.ExitCode

        member this.ExecuteCommandWait(program, args, env, wd) =
            this.Program <- program
            let startInfo = ProcessStartInfo(FileName = program,
                                             Arguments = args,
                                             CreateNoWindow = true,
                                             WindowStyle = ProcessWindowStyle.Hidden,
                                             WorkingDirectory = wd)

            env |> Map.iter (addEnvironmentVariable startInfo)

            this.proc <- new Process(StartInfo = startInfo)
            let ret = this.proc.Start()
            this.stopWatch.Restart()
            Async.Start(this.TimerControl());
            this.proc.WaitForExit()
            this.cancelSignal <- true
            this.proc.ExitCode


