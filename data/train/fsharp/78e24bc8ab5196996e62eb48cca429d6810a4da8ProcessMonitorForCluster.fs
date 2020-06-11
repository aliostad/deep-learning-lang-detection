module internal Nessos.MBrace.Runtime.Definitions.ProcessMonitor

open System

open Nessos.Thespian
open Nessos.Thespian.Cluster
open Nessos.Thespian.Cluster.BehaviorExtensions
open Nessos.Thespian.ImemDb

open Nessos.Vagrant

open Nessos.MBrace.Utils
open Nessos.MBrace.Runtime

open ReplicatedState

let private processMonitorBehaviorNormal (ctx: BehaviorContext<_>)
                                         (state: ReplicatedState<ProcessMonitorDb>)
                                         (msg: ProcessMonitor) =

    //Throws
    //SystemCorruptionException => system inconsistency;; SYSTEM FAULT
    let processRecordToProcessInfo (record: Process) = async {
        //Throws
        //SystemCorruptionException => system inconsistency;; SYSTEM FAULT
        let! taskCount = async {
            match state.State.Process.DataMap.TryFind record.ProcessId with
            | Some { State = Running } ->
                try
                    //FaultPoint
                    //SystemCorruptionException => system inconsistency;; SYSTEM FAULT
                    let! r = Cluster.ClusterManager <!- fun ch -> ResolveActivationRefs(ch, { Definition = empDef/"process"/"taskManager"/"taskManager"; InstanceId = record.ProcessId })

                    if r.Length > 0 then
                        //Throws
                        //InvalidCastException => rethrow as SystemCorruptionException
                        let taskManager = r.[0] :?> ActorRef<TaskManager> |> ReliableActorRef.FromRef

                        //FaultPoint
                        //FailureException => node failure ;; do not hande node failure ;; return 0
                        let! count = taskManager <!- GetActiveTaskCount
                        return count
                    else return 0
                with FailureException _ -> return 0
                     | :? InvalidCastException as e -> return! Async.Raise <| SystemCorruptionException("System services corruption detected.", e)
                     | MessageHandlingException2(SystemCorruptionException _ as e) -> return! Async.Raise e

            | _ -> return 0
        }

        //Throws
        //SystemCorruptionException => system inconsistency;; SYSTEM FAULT
        let! workerCount = async {
            try
                //FaultPoint
                //SystemCorruptionException => system inconsistency;; SYSTEM FAULT;; rethrow
                let! r = Cluster.ClusterManager <!- fun ch -> ResolveActivationRefs(ch, { Definition = empDef/"process"/"worker"/"workerRaw"; InstanceId = record.ProcessId })

                return r.Length
            with MessageHandlingException2(SystemCorruptionException _ as e) -> return! Async.Raise e
        }

        return {
            Name = record.Name
            ProcessId = record.ProcessId
            Type = record.Type
            InitTime = record.Initialized
            TypeName = record.TypeName
            ExecutionTime = match record.Started, record.Completed with
                            | Some whenStarted, Some whenCompleted -> whenCompleted - whenStarted
                            | Some whenStarted, None -> DateTime.Now - whenStarted
                            | None, _ -> TimeSpan.FromMilliseconds 0.
            Workers = workerCount
            Tasks = taskCount
            Result = record.Result
            ProcessState = record.State
            Dependencies = record.Dependencies
            ClientId = record.ClientId
        }
    }

    async {
        let db = state.State

        match msg with
        | InitializeProcess(RR ctx reply, data) ->
            //ASSUME ALL EXCEPTIONS PROPERLY HANDLED AND DOCUMENTED
            try
                if db.Process.DataMap.Count >= Utils.PidSlots then 
                        return! Async.Raise <| new SystemException("Pid Allocator ran out of slots.")

                let pid = Utils.genNextPid (fun p -> not <| db.Process.DataMap.ContainsKey p)

                let processRecord = {
                    ProcessId = pid
                    ClientId = data.ClientId
                    RequestId = data.RequestId
                    Name = data.Name
                    Type = data.Type
                    TypeName = data.TypeName
                    Initialized = DateTime.Now
                    Created = None
                    Started = None
                    Completed = None
                    TasksRecovered = 0
                    Dependencies = data.Dependencies
                    Result = None
                    State = Initialized
                }

                reply (Value processRecord)

                return same state
            with e ->
                ctx.LogError e
                reply <| Exception e

                return same state

        | NotifyProcessInitialized processRecord ->
            try
                let db' = 
                    db |> Database.insert <@ fun db -> db.Process @> processRecord

                return update state db'
            with e ->
                ctx.LogError e
                //trigger system fault

                return same state

        | NotifyProcessCreated(processId, whenCreated) ->
            try
                let db' =
                    match db.Process.DataMap.TryFind processId with
                    | Some record -> db |> Database.insert <@ fun db -> db.Process @> { record with Created = Some whenCreated; State = Created }
                    | None -> db

                return update state db'
            with e -> 
                ctx.LogError e
                //TODO!!! trigger system fault

                return same state

        | NotifyProcessStarted(processId, whenStarted) ->
            try
                let db' =
                    match db.Process.DataMap.TryFind processId with
                    | Some record -> db |> Database.insert <@ fun db -> db.Process @> { record with Started = Some whenStarted; State = Running }
                    | None -> db //TODO!!! Log a warning

                return update state db'
            with e ->
                ctx.LogError e
                //TODO!!! trigger system fault

                return same state

        | NotifyRecoverState(processId, None) ->
            try
                let db' = 
                    match db.Process.DataMap.TryFind processId with
                    | Some record -> db |> Database.insert <@ fun db -> db.Process @> { record with State = Running }
                    | None -> db

                return update state db'
            with e ->
                ctx.LogError e
                //TODO!!! trigger system fault

                return same state

        | NotifyRecoverState(processId, Some recoveryMode) ->
            try
                let db' =
                    match db.Process.DataMap.TryFind processId with
                    | Some record -> db |> Database.insert <@ fun db -> db.Process @> { record with State = Recovering recoveryMode }
                    | None -> db

                return update state db'
            with e ->
                ctx.LogError e
                //TODO!!! trigger system fault

                return same state

        | CompleteProcess(processId, resultImage) ->
            try
                ctx.LogInfo <| sprintf' "Completing process %A" processId

                let db' =
                    match db.Process.DataMap.TryFind processId with
                    | Some record -> db |> Database.insert <@ fun db -> db.Process @> { record with Completed = Some DateTime.Now; Result = Some resultImage; State = match resultImage with ProcessInitError _ | ProcessSuccess _ | ProcessKilled _ -> Completed | ProcessFault _ -> Failed }
                    | None -> db //TODO!!! Log a warning

                if ctx.Self.Name.Contains "local" then
                    try
                        do! Cluster.ClusterManager <!- fun ch -> DeActivateDefinition(ch, { Definition = empDef/"process"; InstanceId = processId })
                    with e -> ctx.LogError e

                return update state db'
            with e ->
                ctx.LogError e
                //TODO!!! trigger system fault

                return same state

        | ProcessMonitor.DestroyProcess processId ->
            return same state

        | NotifyProcessTaskRecovery(processId, numberOfRecoveredTasks) ->
            try
                let db' =
                    match db.Process.DataMap.TryFind processId with
                    | Some record -> db |> Database.insert <@ fun db -> db.Process @> { record with TasksRecovered = numberOfRecoveredTasks }
                    | None -> db //TODO!! Log a warning

                return update state db'
            with e ->
                ctx.LogError e
                //TODO!!! trigger system fault

                return same state

        | FreeProcess processId ->
            try
                let db' = db |> Database.remove <@ fun db -> db.Process @> processId

                return update state db'
            with e ->
                ctx.LogError e
                //TODO!!! trigger system fault

                return same state

        | FreeAllProcesses ->
            return update state (ProcessMonitorDb.Create())

        | ProcessMonitor.TryGetProcessInfo(RR ctx reply, processId) ->
            //ASSUME ALL EXCEPTIONS PROPERLY HANDLED AND DOCUMENTED
            try
                match db.Process.DataMap.TryFind processId with
                | Some record ->
                    //Throws
                    //SystemCorruptionException => system inconsistency;; SYSTEM FAULT;; do not handle
                    let! pinfo = processRecordToProcessInfo record
                    pinfo |> Some |> Value |> reply
                | None -> reply <| Value None
            with e ->
                ctx.LogError e
                reply (Exception e)

            return same state

        | TryGetProcessInfoByRequestId(RR ctx reply, requestId) ->
            //ASSUME ALL EXCEPTIONS PROPERLY HANDLED AND DOCUMENTED
            try
                let recordOpt = Query.from db.Process
                                |> Query.where <@ fun proc -> proc.RequestId = requestId @>
                                |> Query.toSeq
                                |> Seq.tryHead

                match recordOpt with
                | Some record -> 
                    //Throws
                    //SystemCorruptionException => system inconsistency;; SYSTEM FAULT;; do not handle
                    let! pinfo = processRecordToProcessInfo record
                    pinfo |> Some |> Value |> reply
                | None -> reply <| Value None
            with e ->
                ctx.LogError e
                reply (Exception e)

            return same state

        | TryGetProcessResult(RR ctx reply, processId) ->
            try
                match db.Process.DataMap.TryFind processId with
                | Some { Result = result } -> result |> Some |> Value |> reply
                | None -> None |> Value |> reply
            with e ->
                ctx.LogError e
                reply (Exception e)

            return same state

        | GetResult(RR ctx reply, processId) ->
            try
                //Throws
                //KeyNotFoundException
                let result = db.Process.DataMap.[processId]

                //Throws
                //KeyNotFoundException
                reply (Value result.Result.Value)
            with :? System.Collections.Generic.KeyNotFoundException as e ->
                    reply (Exception e)
                | e ->
                    ctx.LogError e
                    reply (Exception e)

            return same state

        | ProcessMonitor.GetAllProcessInfo(RR ctx reply) ->
            try
                let! allProcessInfo =
                    Query.from db.Process
                    |> Query.toSeq
                    //   |> Seq.sortBy (fun proc -> proc.Initialized) // do this from the client
                    |> Seq.map processRecordToProcessInfo
                    |> Async.Parallel

                reply (Value allProcessInfo)
            with e ->
                ctx.LogError e
                reply (Exception e)

            return same state
    }

let private processMonitorBehaviorStateful (ctx: BehaviorContext<_>) 
                                           (state: ReplicatedState<ProcessMonitorDb>)
                                           (msg: Stateful<ProcessMonitorDb>) =
    async {
        match msg with
        | GetState(RR ctx reply) ->
            reply <| Value state
            
            return same state
        | SetState state' ->
            return state'

        | GetGeneration(RR ctx reply) ->
            reply <| Value (state.Generation, ctx.Self :> ActorRef)

            return same state
    }

let processMonitorBehavior (ctx: BehaviorContext<_>)
                           (state: ReplicatedState<ProcessMonitorDb>)
                           (msg: Choice<ProcessMonitor, Stateful<ProcessMonitorDb>>) =
    async {
        match msg with
        | Choice1Of2 payload -> return! processMonitorBehaviorNormal ctx state payload
        | Choice2Of2 payload -> return! processMonitorBehaviorStateful ctx state payload
    }


                           

