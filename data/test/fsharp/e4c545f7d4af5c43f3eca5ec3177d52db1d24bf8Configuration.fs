﻿namespace MBrace.Thespian.Runtime

open System
open System.IO
open System.Diagnostics

open Argu
open MBrace.FsPickler

open Nessos.Thespian
open Nessos.Thespian.Remote

open MBrace.Core.Internals
open MBrace.Runtime
open MBrace.Runtime.Utils

[<AutoOpen>]
module internal WorkerConfiguration =

    /// CLI command line paramaters
    type Arguments =
        | [<NoAppSettings>][<Hidden>] Parent_Actor of byte []
        | [<AltCommandLine("-w")>] Working_Directory of path:string
        | [<AltCommandLine("-H")>] Hostname of uri:string
        | [<AltCommandLine("-p")>] Port of tcp_port:int
        | [<AltCommandLine("-q")>] Quiet
        | [<AltCommandLine("-l")>] Log_Level of level:int
        | [<AltCommandLine("-j")>] Max_Concurrent_Work_Items of num:int
        | [<AltCommandLine("-i")>] Use_AppDomain_Isolation of enable:bool
        | [<AltCommandLine("-li")>] Max_Log_Write_Interval of seconds:float
        | [<AltCommandLine("-L")>] Log_File of path:string
        | [<AltCommandLine("-b")>] Heartbeat_Interval of seconds:float
        | [<AltCommandLine("-t")>] Heartbeat_Threshold of seconds:float

        interface IArgParserTemplate with
            member a.Usage =
                match a with
                | Working_Directory _ -> "Sets a working directory for worker caching. Defaults to system temp folder."
                | Parent_Actor _ -> "Parent actor to reply with node manager."
                | Port _ -> "Port for thespian to listen to. Defaults to self-assigned."
                | Quiet -> "Suppress logging to stdout."
                | Hostname _ -> "Hostname or IP address to listen to. Defaults to domain name."
                | Log_Level _ -> "Specify the log level: 0 none, 1 critical, 2 error, 3 warning, 4 info, 5 debug."
                | Max_Concurrent_Work_Items _ -> "Maximum number of concurrent MBrace work items. Defaults to 20."
                | Max_Log_Write_Interval _ -> "Interval in seconds in which log entries are to be persisted in global store."
                | Use_AppDomain_Isolation _ -> "Enables or disables AppDomain isolation in worker node. Defaults to true."
                | Heartbeat_Interval _ -> "Specify the heartbeat interval for the worker in seconds. Defaults to 0.5 seconds."
                | Heartbeat_Threshold _ -> "Specify the maximum heartbeat threshold after which the worker should be declared dead. Defaults to 10 seconds."
                | Log_File _ -> "Specify a log file for node logging purposes."

    /// Argument parser instance object
    let argParser = ArgumentParser.Create<Arguments>(errorHandler = new ProcessExiter())

    /// Worker startup result; submitted to process that is spawning a child worker process.
    type WorkerStartupResult =
        | Success of ActorRef<WorkerControllerMsg>
        | ProcessExit of int
        | ProcessError of exn

    /// Worker configuration object
    type WorkerConfiguration =
        {
            WorkingDirectory : string option
            Hostname : string option
            Port : int option
            LogLevel : LogLevel option
            LogFiles : string list
            Quiet : bool
            MaxLogWriteInterval : TimeSpan option
            MaxConcurrentWorkItems : int option
            UseAppDomainIsolation : bool option
            HeartbeatInterval : TimeSpan option
            HeartbeatThreshold : TimeSpan option
            // Deserializing ActorRefs in uninitialized thespian states has strange side-effects; 
            // use pickle wrapping for delayed deserialization
            /// ActorRef to parent process that has spawned this process, if applicable.
            Parent : Pickle<ActorRef<WorkerStartupResult>> option
        }

        /// Parse configuration object from command line
        static member Parse(?argv : string[]) =
            let results = argParser.Parse(?inputs = argv)
            {
                WorkingDirectory = results.TryGetResult <@ Working_Directory @>
                Hostname = results.TryGetResult <@ Hostname @>
                Port = results.TryPostProcessResult(<@ Port @>, fun p -> if p <= 0 || p >= int UInt16.MaxValue then failwithf "port number out of range" else p)
                LogFiles = results.GetResults <@ Log_File @>
                LogLevel = results.TryPostProcessResult(<@ Log_Level @>, fun l -> if l < 0 || l > 5 then failwith "invalid log level" else enum l)
                Quiet = results.Contains <@ Quiet @>
                MaxConcurrentWorkItems = results.TryPostProcessResult(<@ Max_Concurrent_Work_Items @>, fun j -> if j <= 0 || j > 1000 then failwith "max concurrent work items out of range" else j)
                MaxLogWriteInterval = results.TryPostProcessResult(<@ Max_Log_Write_Interval @>, TimeSpan.FromSeconds)
                UseAppDomainIsolation = results.TryGetResult(<@ Use_AppDomain_Isolation @>)
                HeartbeatInterval = results.TryPostProcessResult(<@ Heartbeat_Interval @>, fun s -> if s > 0. then TimeSpan.FromSeconds s else failwith "must be positive.")
                HeartbeatThreshold = results.TryPostProcessResult(<@ Heartbeat_Threshold @>, fun s -> if s > 0. then TimeSpan.FromSeconds s else failwith "must be positive.")
                Parent = results.TryPostProcessResult(<@ Parent_Actor @>, fun bytes -> new Pickle<_>(bytes))
            }

        /// Print configuration object as CLI parameter string
        static member ToCommandLineArgs(config : WorkerConfiguration) =
            [
                match config.WorkingDirectory with Some w -> yield Working_Directory w | None -> ()
                match config.Hostname with Some h -> yield Hostname h | None -> ()
                match config.Port with Some p -> yield Port p | None -> ()
                for l in config.LogFiles -> Log_File l
                if config.Quiet then yield Quiet
                match config.LogLevel with Some l -> yield Log_Level(int l) | None -> ()
                match config.MaxConcurrentWorkItems with Some j -> yield Max_Concurrent_Work_Items j | None -> ()
                match config.MaxLogWriteInterval with Some lwi -> yield Max_Log_Write_Interval lwi.TotalSeconds | None -> ()
                match config.UseAppDomainIsolation with Some i -> yield Use_AppDomain_Isolation i | None -> ()
                match config.Parent with Some p -> yield Parent_Actor p.Bytes | None -> ()
                match config.HeartbeatInterval with Some i -> yield Heartbeat_Interval i.TotalSeconds | None -> ()
                match config.HeartbeatThreshold with Some i -> yield Heartbeat_Threshold i.TotalSeconds | None -> ()
            ] |> argParser.PrintCommandLineArgumentsFlat

    /// Asynchronously spawns a worker process with supplied configuration
    let spawnAsync (nodeExecutable : string) (runAsBackground : bool) (config : WorkerConfiguration) = async {
        use receiver =
            Receiver.create<WorkerStartupResult>()
            |> Receiver.rename (mkUUID())
            |> Receiver.publish [| Protocols.utcp() |]
            |> Receiver.start

        let config = { config with Parent = Some (Config.Serializer.PickleTyped receiver.Ref) }
        let args = WorkerConfiguration.ToCommandLineArgs config
        let cloudProcess = new Process()
        let psi = cloudProcess.StartInfo
        psi.FileName <- nodeExecutable
        psi.Arguments <- args
        psi.WorkingDirectory <- Path.GetDirectoryName nodeExecutable
        if runAsBackground then
            psi.UseShellExecute <- false
            psi.CreateNoWindow <- true
        else
            psi.UseShellExecute <- true

        cloudProcess.EnableRaisingEvents <- true

        let awaiter =
            receiver 
            |> Receiver.toObservable
            |> Observable.merge (cloudProcess.Exited |> Observable.map (fun _ -> ProcessExit cloudProcess.ExitCode))
            |> Async.AwaitObservable

        let _ = cloudProcess.Start()
        let! result = awaiter
        cloudProcess.EnableRaisingEvents <- false

        match result with
        | ProcessExit code -> return failwithf "Child process exited with error code %d." code
        | ProcessError e -> return raise <| new Exception("Child process responded with exception.", e)
        | Success aref -> return aref
    }
    
    /// Reply to spawning process with provided result
    let replyToParent (logger : ISystemLogger) (config : WorkerConfiguration) (result : WorkerStartupResult) =
        match config.Parent with
        | Some p ->
            logger.LogInfo "Responding to spawning process."
            try
                let aref = Config.Serializer.UnPickleTyped p
                aref <-- result 
            with e -> logger.LogWithException LogLevel.Warning e "Error responding to parent."
        | None -> ()