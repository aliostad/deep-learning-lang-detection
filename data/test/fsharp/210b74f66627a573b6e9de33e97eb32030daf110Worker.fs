module internal Nessos.MBrace.Runtime.Definitions.Worker

open System
open System.Threading
open System.Runtime.Serialization

open Nessos.Thespian
open Nessos.Thespian.Cluster
open Nessos.Thespian.Cluster.BehaviorExtensions

open Nessos.MBrace
open Nessos.MBrace.Core
open Nessos.MBrace.Utils
open Nessos.MBrace.Runtime
open Nessos.MBrace.Runtime.Store

//type alias to prevent conflicts with non-cluster types
type private ProcessMonitorDb = PublicTypes.ProcessMonitorDb

type State = {
    TaskManager: ReliableActorRef<TaskManager>
} with static member Empty = { TaskManager = ActorRef.empty() |> ReliableActorRef.FromRef }

let workerBehavior (processId: ProcessId)
                   (processMonitor: ActorRef<Replicated<ProcessMonitor, ProcessMonitorDb>>)
                   (taskMap: Atom<Map<TaskId, IDisposable>>)
                   (ctx: BehaviorContext<_>)
                   (state: State)
                   (msg: Worker) =
    
    let config = IoC.Resolve<CoreConfiguration> ()
    let toCloudRef cloudExpr = config.CloudRefStore.Create("temp" + (string processId), Guid.NewGuid().ToString(), cloudExpr, cloudExpr.GetType())
    let taskManager = state.TaskManager
    let processTask (processId : ProcessId, taskId : TaskId, functions : Function list, Dump (dump)) = 
        let traceEnabled stack = stack |> List.exists (fun cloudExpr' -> match cloudExpr' with DoEndTraceExpr -> true | _ -> false)
        let rec processTask' stack = 
            async {
                let! stack' = Interpreter.run processId (taskId.ToString()) functions (traceEnabled stack) stack config
                match stack' with
                | GetWorkerCountExpr :: _ -> return stack'
                | ParallelExpr (cloudExprs, t) :: rest ->
                    let cloudExprs' =
                        if traceEnabled stack' then
                            cloudExprs |> Array.map TraceExpr
                        else
                            cloudExprs 
                    let parallelValue = ParallelValue (cloudExprs', t) 
                    return (ValueExpr parallelValue) :: rest
                | ChoiceExpr (cloudExprs, t) :: rest ->
                    let choiceValue = ChoiceValue (cloudExprs, t) 
                    return (ValueExpr choiceValue) :: rest
                | LocalExpr cloudExpr :: rest -> 
                    let! value = Interpreter.runLocal processId (taskId.ToString()) functions false [cloudExpr] config
                    return! processTask' <| (ValueExpr value) :: rest
                | ValueExpr (Obj (ObjValue value, t)) :: rest when value <> null ->
                    let! cloudRefValue = config.CloudRefStore.Create("temp" + (string processId), Guid.NewGuid().ToString(), box value, typeof<obj>)
                    return (ValueExpr (Obj (CloudRefValue (cloudRefValue  :?> ICloudRef<obj>), t))) :: rest
                | _ -> return stack'
            }
        processTask' dump 
    
    let handleUnexpectedError e =
        let msgName = match msg with
                      | ExecuteTask _ -> "ExecuteTask"
                      | CancelTasks _ -> "CancelTasks"
                      | CancelAll -> "CancelAll"
                      | CancelAllSync  _ -> "CancelAllSync"
                      | SwitchTaskManager _ -> "SwitchTaskManager"
        ctx.LogInfo <| sprintf' "Unexpected error occurred while processing %s: %A" msgName msg
        ctx.LogError e
        state
    
    async {
        match msg with
        | ExecuteTask((processId, taskId) as taskHeader, (ProcessBody(_) as body)) ->
            try
                let cancellationTokenSource = new CancellationTokenSource()

                let taskProcessAsync = async { 
                    ctx.LogInfo <| sprintf' "Executing task (%A, %A)..." processId taskId

                    let! result = 
                        async {
                            try
                                let (ProcessBody (resultType, thunkIdsStack, functionsCloudRef, dump)) = body
                                let! dump' = processTask (processId, taskId, functionsCloudRef.Value, dump) 
                                return Choice1Of2 <| ProcessBody (resultType, thunkIdsStack, functionsCloudRef, dump' |> Dump)
                            with ex ->
                                return Choice2Of2 ex
                        }

                    Atom.swap taskMap (Map.remove taskId)

                    match result with
                    | Choice1Of2 taskResult ->
                        ctx.LogInfo <| sprintf' "(%A, %A) obtained result." processId taskId
                        try
                            //FaultPoint
                            //-
                            taskManager <-- TaskResult(taskHeader, TaskSuccess taskResult)
                        with CommunicationException(_, _, _, (:? SerializationException as e)) ->
                                //FaultPoint
                                //-
                                do! processMonitor <!- fun ch -> Replicated(ch, Choice1Of2 <| CompleteProcess(processId, ExceptionResult(Nessos.MBrace.CloudException("Failed to serialize", processId, e) :> exn, None) |> Serializer.Serialize |> ProcessSuccess ))

                                processMonitor <-- Singular(Choice1Of2 <| ProcessMonitor.DestroyProcess processId)
                            | e -> ctx.LogError e //"Worker: Unable to send task result."
                    | Choice2Of2 e ->
                        try
                            ctx.LogError e //"Worker: Task processing failure."
                            //FaultPoint
                            //-
                            taskManager <-- TaskResult(taskHeader, TaskFailure e)
                        with e -> ctx.LogError e //"Worker: Unable to send task result."
                }

                Atom.swap taskMap (Map.add taskId { new IDisposable with override __.Dispose() = cancellationTokenSource.Cancel(); cancellationTokenSource.Dispose() })
                Async.Start (taskProcessAsync, cancellationToken = cancellationTokenSource.Token)

                return state
            with e ->
                return handleUnexpectedError e

        | CancelTasks taskIds ->
            try
                for taskId in taskIds do
                    ctx.LogInfo <| sprintf' "Cancelling task %A" taskId
                    match taskMap.Value.TryFind taskId with
                    | Some disposable -> disposable.Dispose()
                    | None -> ()

                Atom.swap taskMap (Array.foldBack Map.remove taskIds)

                return state
            with e ->
                return handleUnexpectedError e

        | CancelAll ->
            try
                ctx.LogInfo "Cancelling all tasks..."
                for taskId, disposable in taskMap.Value |> Map.toSeq do
                    ctx.LogInfo <| sprintf' "Cancelling task %A" taskId
                    disposable.Dispose()

                Atom.swap taskMap (fun _ -> Map.empty)

                return state
            with e ->
                return handleUnexpectedError e

        | CancelAllSync(RR ctx reply) ->
            try
                ctx.LogInfo "Cancelling all tasks..."
                for taskId, disposable in taskMap.Value |> Map.toSeq do
                    ctx.LogInfo <| sprintf' "Cancelling task %A" taskId
                    disposable.Dispose()

                Atom.swap taskMap (fun _ -> Map.empty)

                reply nothing

                return state
            with e ->
                reply <| Exception e
                return handleUnexpectedError e

        | SwitchTaskManager taskManager' ->
            try
                return { state with TaskManager = ReliableActorRef.FromRef taskManager' }
            with e ->
                return handleUnexpectedError e
    }

