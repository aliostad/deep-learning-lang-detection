namespace Nessos.MBrace.Client

    open System
    open System.Reflection
    open System.Runtime.Serialization
    open System.Text

    open Nessos.Thespian

    open Nessos.Vagrant

    open Nessos.MBrace
    open Nessos.MBrace.Core
    open Nessos.MBrace.Utils
    open Nessos.MBrace.Utils.String
    open Nessos.MBrace.Runtime
    open Nessos.MBrace.Runtime.Utils
    open Nessos.MBrace.Client.QuotationAnalysis
    
    open Microsoft.FSharp.Quotations

    type internal RuntimeMsg = Runtime
    type internal ProcessManagerMsg = ProcessManager
    type internal OSProcess = System.Diagnostics.Process

    [<CompilationRepresentationAttribute(CompilationRepresentationFlags.ModuleSuffix)>]
    module ProcessResult = 
        type ProcessResult<'T> =
            | Pending
            | CompilerError of exn
            | Value of 'T
            | Exception of exn
            | Fault of exn
            | Killed
        and ProcessResult = ProcessResult<obj>
    
    open ProcessResult

    module internal ProcessInfo =

        let getResult<'T> (info : ProcessInfo) =
            match info.Result with
            | None -> Pending
            | Some(ProcessSuccess bytes) ->
                match Serializer.Deserialize<Result<'T>> bytes with
                | ValueResult v -> Value v
                | ExceptionResult (e, ctx) -> Exception e
            | Some(ProcessFault e) -> Fault e
            | Some(ProcessInitError e) -> CompilerError e
            | Some(ProcessKilled) -> Killed

        let getReturnType (info : ProcessInfo) = Serializer.Deserialize<Type> info.Type

        let prettyPrint =

            let template : Field<ProcessInfo> list =
                [
                    Field.create "Name" Left (fun p -> p.Name)
                    Field.create "Process Id" Right (fun p -> p.ProcessId)
                    Field.create "Status" Left (fun p -> p.ProcessState)
                    Field.create "#Workers" Right (fun p -> p.Workers)
                    Field.create "#Tasks" Right (fun p -> p.Workers)
                    Field.create "Start Time" Left (fun p -> p.InitTime)
                    Field.create "Execution Time" Left (fun p -> p.ExecutionTime)
                    Field.create "Result Type" Left (fun p -> p.TypeName)
                ]

            prettyPrintTable3 template None

    
    type Process internal (info : ProcessInfo, processManager : ActorRef<ProcessManagerMsg>) =
        let processId = info.ProcessId
        let returnType = ProcessInfo.getReturnType info

        let getProcessInfo () =
            async {
                try
                    return! processManager <!- fun ch -> GetProcessInfo(ch, processId)
                with
                | MBraceExn e -> return raise e
                | MessageHandlingException (_,_,_,e) ->
                    return mfailwithInner e "Client process manager has replied with exception."
                | :? ActorInactiveException as e ->
                    return raise <| ObjectDisposedException("Client process manager has been disposed.", e)
            }

        let processInfo = CacheAtom.Create(fun () -> getProcessInfo () |> Async.RunSynchronously)

        member p.AwaitResultBoxedAsync ?pollingInterval =
            let pollingInterval = defaultArg pollingInterval 200

            let rec retriable () =
                async {
                    let! processInfo = getProcessInfo ()

                    match ProcessInfo.getResult<obj> processInfo with
                    | Pending ->
                        do! Async.Sleep pollingInterval 
                        return! retriable ()
                    | Value v -> return v
                    | Exception e -> return raise e
                    | Fault e -> return raise e
                    | CompilerError (MBraceExn e) -> return raise e
                    | CompilerError e -> return mfailwithfInner e "Cloud compiler raised an exception. Process not started."
                    | Killed -> return raise (new ProcessKilledException("Process has been killed.") :> exn)
                }

            retriable () |> Error.handleAsync

        member p.AwaitResultBoxed () = p.AwaitResultBoxedAsync () |> Error.handleAsync2

        member p.Name = info.Name
        member p.ProcessId = processId
        member p.ReturnType = returnType
        member internal p.ProcessInfo =  try processInfo.Value with e -> Error.handle e
        member p.Result : ProcessResult = try ProcessInfo.getResult<obj> processInfo.Value with e -> Error.handle e
        member p.ExecutionTime = p.ProcessInfo.ExecutionTime
        member p.Complete = p.ProcessInfo.Result.IsSome
        member p.InitTime = p.ProcessInfo.InitTime
        member p.Workers = p.ProcessInfo.Workers
        member p.Tasks = p.ProcessInfo.Tasks
        member p.ClientId = p.ProcessInfo.ClientId
        // TODO : only printable in shell mode
        member p.ShowInfo (?useBorders) =
            let useBorders = defaultArg useBorders false
            [p.ProcessInfo] |> ProcessInfo.prettyPrint useBorders |> printfn "%s"
        
        member p.TryGetResultBoxed () =
            try
                match p.Result with
                | Pending -> None
                | Exception e -> raise e
                | Value v -> Some v
                | CompilerError (MBraceExn e) -> raise e
                | CompilerError e -> mfailwithInner e "Cloud Compiler error. Process not started."
                | Killed -> mfailwith "Process has been killed by the user."
                | Fault e -> raise e
            with e -> Error.handle e

        member p.Cast<'T> () =
            try
                if typeof<'T>.IsAssignableFrom returnType then
                    new Process<'T> (info, processManager)
                else
                    mfailwithf "Unable to cast type '%A' to type '%A'." returnType typeof<'T>
            with e -> Error.handle e

        member p.Kill () = 
            try
                processManager <!- fun ch -> KillProcess(ch, processId)
                |> Async.RunSynchronously
            with e -> Error.handle e

        static member Cast<'T> (p : Process) = p.Cast<'T> ()

    and [<Sealed>] Process<'T> internal (info : ProcessInfo, processManager : ActorRef<ProcessManagerMsg>) as self =
        inherit Process(info, processManager)

        let pBase = self :> Process

        member p.AwaitResultAsync<'T>(?pollingInterval) =
            async {
                let! result = pBase.AwaitResultBoxedAsync(?pollingInterval = pollingInterval)

                return result :?> 'T
            } |> Error.handleAsync

        member p.AwaitResult<'T> () = p.AwaitResultAsync<'T> () |> Error.handleAsync2
        member p.TryGetResult<'T>() = try pBase.TryGetResultBoxed () |> Option.map (fun o -> o :?> 'T) with e -> Error.handle e


    [<Sealed>]
    type ProcessManager internal (runtime: ActorRef<ClientRuntimeProxy>) =

        let failoverActor =
            let rec behaviour (state : (DeploymentId * ActorRef<ProcessManagerMsg>) option) (msg : ProcessManagerMsg) =
                async {
                    let reply = match msg with ProcessManagerReply r -> r.ReplyUntyped | _ -> ignore

                    try
                        match state with
                        | None ->
                            let! pm = runtime <!- (RemoteMsg << GetProcessManager)
                            let! id = runtime <!- (RemoteMsg << GetDeploymentId)

                            return! behaviour (Some (id,pm)) msg
                        | Some (id,pm) ->  
                            let! currentId = runtime <!- (RemoteMsg << GetDeploymentId)

                            if id = currentId then
                                // temporary store sanity check
                                match msg with
                                // messages that involve sending/receiving computation data to the runtime
                                | CreateDynamicProcess _ | GetProcessInfo _ | GetAllProcessInfo _ ->
                                    if runtimeUsesCompatibleStore runtime then pm <-- msg
                                    else reply <| Reply.exn (mkMBraceExn None "incompatible store configuration.")
                                | _ -> pm <-- msg
                                    
                                return state
                            else // clear state if working with new runtime instance
                                return! behaviour None msg

                    with
                    | MBraceExn e -> e |> Reply.exn |> reply ; return state
                    | CommunicationException (_,_,_,e) ->
                        if state.IsSome then
                            // retry with clean state
                            return! behaviour None msg
                        else
                            mkMBraceExn (Some e) "Cannot communicate with {m}brace runtime." |> Reply.exn |> reply
                            return state

                    | MessageHandlingException (_,_,_,e) ->
                        mkMBraceExn (Some e) "Runtime replied with exception." |> Reply.exn |> reply
                        return state

                    | e -> reply <| Reply.Exception e; return state
                }

            Actor.bind <| Behavior.stateful None behaviour |> Actor.start

        let processManager = failoverActor.Ref

        let verbosity = true // match Shell.Settings with Some conf -> conf.Verbose | _ -> false

        let postMsg (msgBuilder : IReplyChannel<'T> -> ProcessManagerMsg) =
            async {
                try
                    return! processManager <!- msgBuilder
                with
                | MBraceExn e -> return raise e
                | MessageHandlingException (_,_,_,e) ->
                    return! Async.Raise <| mkMBraceExn (Some e) "Processmanager replied with exception."
                | :? ActorInactiveException ->
                    return! Async.Raise <| mkMBraceExn None "Processmanager client has been disposed."
            }

        let getProcessInfoAsync (pid : ProcessId) = async {

            let processInfoRef = ref Unchecked.defaultof<ProcessInfo>

            let dependencyDownloader =
                {
                    new IRemoteAssemblyPublisher with
                        member __.GetRequiredAssemblyInfo () = async {
                            let! processInfo = postMsg <| fun ch -> GetProcessInfo(ch, pid)

                            processInfoRef := processInfo

                            return 
                                if processInfo.ClientId = MBraceSettings.ClientId then []
                                else
                                    processInfo.Dependencies
                        }

                        member __.PullAssemblies (ids : AssemblyId list) = 
                            if verbosity then printfn "Downloading dependencies for cloud process %d..." pid

                            postMsg <| fun ch -> RequestDependencies(ch, ids)
                }

            do! MBraceSettings.Vagrant.Client.ReceiveDependencies dependencyDownloader

            return processInfoRef.Value
        }
//            async {
//                let! processInfo = postMsg <| fun ch -> GetProcessInfo(ch, pid)
//
//                if processInfo.ClientId <> MBraceSettings.ClientId then
//                    let missingAssemblies = processInfo.Dependencies |> List.filter (not << MBraceSettings.Vagrant.Client.IsLoadedAssembly)
//                    if missingAssemblies.Length <> 0 then
//                        if verbosity then printfn "Downloading dependencies for cloud process %d..." processInfo.ProcessId
//                        
//                        let! assemblies = postMsg <| fun ch -> RequestDependencies (ch, missingAssemblies)
//                        let loadResults = MBraceSettings.Vagrant.Client.LoadPortableAssemblies assemblies
//                        return
//                            match loadResults |> List.tryFind (function Loaded _ -> false | _ -> true) with
//                            | None -> ()
//                            | Some a ->
//                                mfailwithf "Protocol error: could not download dependency '%s'." a.Id.FullName
//
//                return processInfo
//            }

        let getAllProcessInfoAsync () = 
            async {
                let! images = postMsg GetAllProcessInfo

                return 
                    images 
                    |> Array.toList 
                    |> List.sortBy (fun p -> p.InitTime)
            }

        let clearProcessInfoAsync (pid : ProcessId) =
            async {
                do! postMsg <| fun ch -> ClearProcessInfo (ch, pid)
            }  

        let clearAllProcessInfoAsync () =
            async {
                do! postMsg ClearAllProcessInfo
            }

        let getProcessInfo pid = getProcessInfoAsync pid |> Async.RunSynchronously
        let getAllProcessInfo () = getAllProcessInfoAsync () |> Async.RunSynchronously

        member pm.CreateProcessAsync<'T> (comp : CloudComputation<'T>) : Async<Process<'T>> =
            async {
                let requestId = RequestId.NewGuid()

                let dependencyUploader =
                    {
                        new IRemoteAssemblyReceiver with
                            member __.GetLoadedAssemblyInfo (ids : AssemblyId list) =
                                processManager <!- fun ch -> GetAssemblyLoadInfo(ch, requestId, ids)

                            member __.PushAssemblies (pas : PortableAssembly list) =
                                processManager <!- fun ch -> LoadAssemblies(ch, requestId, pas)
                    
                    }

                try
                    // serialization errors for dynamic assemblies
                    let! errors = MBraceSettings.Vagrant.SubmitObjectDependencies(dependencyUploader, comp.Value, permitCompilation = false)

                    let! info = processManager <!- fun ch -> CreateDynamicProcess(ch, requestId, comp.Image)

                    return Process<'T>(info, processManager)
//                let rec trySendProcess missingAssemblies =
//                    async {
//                        let processImage, firstRequest =
//                            match missingAssemblies with
//                            | None -> comp.GetHashBundle() , true
//                            | Some missing -> comp.GetMissingImageBundle missing , false
//                        
//                        if verbosity && not firstRequest then printfn "uploading dependencies... "
//
//                        let! response = processManager <!- fun ch -> CreateDynamicProcess(ch, requestId, processImage)
//                    
//                        match response with
//                        | Process info ->
////                            if verbosity && not firstRequest then printfn "done"
//
//                            return Process<'T>(info, processManager)
//                        | MissingAssemblies missing ->
//                            if firstRequest then
//                                return! trySendProcess <| Some missing
//                            else
//                                return mfailwith "Failed to create cloud process."
//                    }
//
//                try
//                    return! trySendProcess None
                with
                | MBraceExn e -> return! Async.Raise e
                | MessageHandlingException (_,_,_,e) ->
                    return! Async.Raise <| mkMBraceExn (Some e) "Processmanager client has replied with exception."
                | :? ActorInactiveException as e ->
                    return! Async.Raise <| mkMBraceExn None "Processmanager client has been disposed."
            } |> Error.handleAsync

        member pm.KillAsync (pid : ProcessId) =
            async {
                return! postMsg <| fun ch -> KillProcess(ch,pid)
            } |> Error.handleAsync

        member pm.CreateProcess<'T> expr = pm.CreateProcessAsync<'T> expr |> Error.handleAsync2
        member pm.GetProcess (pid : ProcessId) = try Process(getProcessInfo pid, processManager) with e -> Error.handle e
        member pm.GetProcess<'T> (pid : ProcessId) = try let p = pm.GetProcess pid in p.Cast<'T> () with e -> Error.handle e
        member pm.GetAllProcesses () = try getAllProcessInfo () |> List.map (fun info -> Process(info, processManager)) with e -> Error.handle e
        member pm.ClearProcessInfo (pid : ProcessId) = clearProcessInfoAsync pid |> Error.handleAsync2
        member pm.ClearAllProcessInfo () = clearAllProcessInfoAsync () |> Error.handleAsync2
        member pm.Kill pid = pm.KillAsync pid |> Error.handleAsync2
        // TODO : only printable in shell mode!!
        member pm.ShowInfo (?useBorders) =
            let useBorders = defaultArg useBorders false
            try getAllProcessInfo () |> ProcessInfo.prettyPrint useBorders |> printfn "%s" 
            with e -> Error.handle e
        

        interface IDisposable with
            member pm.Dispose() = failoverActor.Stop()    
