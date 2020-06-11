namespace Nessos.MBrace.Runtime.Definitions

open Nessos.Thespian
open Nessos.Thespian.Reversible
open Nessos.Thespian.PowerPack
open Nessos.Thespian.Remote.TcpProtocol.Unidirectional
open Nessos.Thespian.Cluster
open Nessos.Thespian.Cluster.BehaviorExtensions

open Nessos.Vagrant

open Nessos.MBrace.Utils
open Nessos.MBrace.Runtime

//type aliases to resolve conficts with non-cluster types
type private ProcessMonitorDb = PublicTypes.ProcessMonitorDb

// resolve conflict from Nessos.MBrace.Utils.LogLevel
type private LogLevel = Nessos.Thespian.LogLevel

//COMMON NODE DEFINITIONS

type internal AssemblyManagerDefinition(parent: DefinitionPath) =
    inherit ActorDefinition<AssemblyManager>(parent)

    override __.Name = "assemblyManager"

    override __.Dependencies = []

    override __.Behavior(configuration: ActivationConfiguration, instanceId: int) = async {
        return Behavior.stateless AssemblyManager.assemblyManagerBehavior
    }

type internal ProcessDomainManagerDefinition(parent: DefinitionPath, inMemory: bool) =
    inherit ActorDefinition<ProcessDomainManager>(parent)

    new (parent: DefinitionPath) = ProcessDomainManagerDefinition(parent, false)

    override __.Name = "processDomainManager"
    override __.Dependencies = []
    override __.Configuration =
        ActivationConfiguration.Specify [ Conf.Spec(ProcessDomainManager.Configuration.IsolateProcesses, not inMemory)
                                          Conf.Spec<int list>(ProcessDomainManager.Configuration.PortPool, IoC.Resolve<int list>("mbrace.process.portPool"))
                                          Conf.Spec<int>(ProcessDomainManager.Configuration.ProcessDomainPoolSize, 1) ]

    override def.Behavior(configuration: ActivationConfiguration, instanceId: int) = async {
        if configuration.Get(ProcessDomainManager.Configuration.IsolateProcesses) then
            def.LogInfo "Activating with process isolation enabled..."

            let portPool = configuration.Get<_>(ProcessDomainManager.Configuration.PortPool)
            //let portPool = IoC.Resolve<int list>("mbrace.process.portPool")
            let initState = ProcessDomainManager.State.Init(portPool)
            //Throws
            //KeyNotFoundException => not found
            //TimeoutException => not found within given time
            let processDomainClusterManager = Cluster.Get<ActorRef<ClusterManager>>("processDomainClusterManager")
            //Throws
            //KeyNotFoundException => no processDomainCluster managed in this node;; System fault
            return Behavior.stateful initState (ProcessDomainManager.processDomainManagerBehavior processDomainClusterManager)
        else
            return Behavior.stateful InMemoryProcessDomainManager.State.Empty InMemoryProcessDomainManager.processManagerBehavior
    }

    override def.OnActivated(activation: Activation) = 
        let baseHandling = base.OnActivated(activation)
        revasync {
            do! baseHandling

            def.LogInfo "Initializing process domain pool..."

            let activationResult = Seq.head activation.ActorActivationResults
            let processDomainPoolSize = activationResult.Configuration.Get<int>(ProcessDomainManager.Configuration.ProcessDomainPoolSize)

            def.LogInfo (sprintf "Pool size: %d" processDomainPoolSize)

            let processDomainManager = activationResult.ActorRef.Value :?> ActorRef<ProcessDomainManager>
            
            for i in 1..processDomainPoolSize do
                //TODO!!! Extract this to a method on the ProcessDomainManager type
                do! RevAsync.FromAsync(
                        ( processDomainManager <!- fun ch -> CreateProcessDomain(ch, []) ),
                        (fun (_, processDomainId, _) -> async { processDomainManager <-- DestroyProcessDomain processDomainId })
                    ) |> RevAsync.Ignore
        }

    override def.OnDeactivate(activation: Activation) =
        let baseHandling = base.OnDeactivate(activation)
        async {
            do! baseHandling

            def.LogInfo "Clearing process domain pool..."

            let activationResult = Seq.head activation.ActorActivationResults
            let processDomainManager = activationResult.ActorRef.Value :?> ActorRef<ProcessDomainManager>

            do! processDomainManager <!- ClearProcessDomains
        }

    override def.OnDeactivated(activationRef: ActivationReference) =
        let baseHandling = base.OnDeactivated(activationRef)
        async {
            do! baseHandling

            def.LogInfo "Killing process domain cluster..."

            Cluster.NodeManager <-- FiniCluster "processDomainCluster"
        }

type LoggerActorDefinition(parent: DefinitionPath) =
    inherit ActorDefinition<LogEntry>(parent)

    override __.Name = "loggerActor"

    override __.Dependencies = []

    override __.Behavior(configuration: ActivationConfiguration, instanceId: int) = async {
        let logger = IoC.Resolve<Nessos.MBrace.Utils.ILogger>()
        return Behavior.stateless (Logger.loggerActorBehaviour logger)
    }

type PerformanceMonitorDefinition(parent: DefinitionPath) =
    inherit BaseActorDefinition<IReplyChannel<NodePerformanceInfo>>(parent)

    override __.Name = "performanceMonitor"
    override __.Configuration = ActivationConfiguration.Empty
    override __.Dependencies = []
    override __.PublishProtocols = []
    override __.Actor(_, _) = async {
        return PerformanceMonitor.init()
    }

//MASTER NODE DEFINITIONS

type internal ProcessMonitorDefinition(parent: DefinitionPath) =
    inherit ReplicatedActorDefinition<ProcessMonitor, Nessos.MBrace.Runtime.Definitions.PublicTypes.ProcessMonitorDb>(parent)

    override __.Name = "processMonitor"

    override __.InitState = Nessos.MBrace.Runtime.Definitions.PublicTypes.ProcessMonitorDb.Create()
    override __.Behavior(configuration: ActivationConfiguration, instanceId: int, state: Nessos.MBrace.Runtime.Definitions.PublicTypes.ProcessMonitorDb) =
        Behavior.stateful (ReplicatedState.create state) Nessos.MBrace.Runtime.Definitions.ProcessMonitor.processMonitorBehavior

    override __.ReplicatedOnNodeLossAction = ReActivateOnNodeLossSpecific ActivationStrategy.masterNode

type internal MasterAssemblyManager(parent: DefinitionPath) =
    inherit ActorDefinition<AssemblyManager>(parent)

    let dependencyPath = empDef/"common"/"assemblyManager"

    override __.Name = "masterAssemblyManager"

    override __.Dependencies =
        [{
            Definition = dependencyPath
            Instance = Some 0
            Configuration = ActivationConfiguration.Empty
            ActivationStrategy = ActivationStrategy.clusterWide
        }]

    override __.Behavior(configuration: ActivationConfiguration, instanceId: int) = async {
        let localAssemblyManager = Cluster.NodeRegistry.ResolveLocal<AssemblyManager>
                                        { Definition = dependencyPath; InstanceId = 0 }

        let slaveProvider = async {
            //Cluster.NodeRegistry.Resolve<AssemblyManager> { Definition = dependencyPath; InstanceId = 0 }
            let! r = Cluster.ClusterManager <!- fun ch -> ResolveActivationRefs(ch, { Definition = dependencyPath; InstanceId = 0 })
            return r |> Seq.cast<ActorRef<AssemblyManager>>
        }

        return Behavior.stateless (AssemblyManager.masterAssemblyManagerBehavior localAssemblyManager slaveProvider)
    }

type internal ProcessManagerDefinition(parent: DefinitionPath) =
    inherit ActorDefinition<ProcessManager>(parent)

    override __.Name = "processManager"
    override __.Configuration = ActivationConfiguration.Empty
    override __.Dependencies = []
    override __.PublishProtocols = [Remote.TcpProtocol.Bidirectional.BTcp()] //TODO!!! Add UTCP as well?
    override __.Behavior(_, _) = async {
        let processMonitor = Cluster.NodeRegistry.ResolveLocal<Replicated<ProcessMonitor, PublicTypes.ProcessMonitorDb>>
                                (empDef/"master"/"processMonitor"/"replicated"/"processMonitor" |> ActivationReference.FromPath)

        let masterAssemblyManager = Cluster.NodeRegistry.ResolveLocal<AssemblyManager>
                                        (empDef/"master"/"masterAssemblyManager" |> ActivationReference.FromPath)

        return Behavior.stateless (ProcessManager.processManagerBehavior processMonitor masterAssemblyManager)
    }

//CLOUD PROCESS DEFINITIONS

type internal WorkerPoolDefinition(parent: DefinitionPath) =
    inherit ActorDefinition<WorkerPool>(parent)

    let workerPath = empDef/"process"/"worker"/"workerRaw"

    override __.Name = "workerPool"
    override __.Configuration = ActivationConfiguration.Empty
    override __.Dependencies = 
        [{
            Definition = workerPath
            Instance = None //same as this one
            Configuration = ActivationConfiguration.Empty
            ActivationStrategy = ActivationStrategy.clusterWide
        }]
    override def.Behavior(_, instanceId) = async {
        let initWorkerPool = Cluster.NodeRegistry.Resolve<RawProxy> { Definition = workerPath; InstanceId = instanceId }
                             |> Seq.map (fun rawProxyRef -> new RawActorRef<Worker>(rawProxyRef) :> ActorRef<Worker>)
                             |> Set.ofSeq

        def.LogInfo <| sprintf' "Initial worker pool size: %d" (Set.count initWorkerPool)

        // Round-Robin selection
        let lastOne = ref 0
        let selectF (pool: Set<_>) = 
            let pool' = pool |> Set.toArray 
            if pool'.Length = 0 then None
            else
                try
                    lastOne := lastOne.Value + 1
                    if lastOne.Value >= pool'.Length then
                        lastOne := 0
                    Some (pool'.[lastOne.Value])
                with _ -> None

        let initState = { WorkerPool.Pool = initWorkerPool }

        return Behavior.stateful initState (WorkerPool.workerPoolBehavior instanceId selectF) 
    }

    override def.OnDependencyLoss(currentActivation: Activation, lostDependency: ActivationReference, lostNode: ActorRef<NodeManager>) = async {
        try
            let taskManager = 
                let rawProxyRef = Cluster.NodeRegistry.ResolveLocal<RawProxy>
                                    { Definition = empDef/"process"/"taskManager"/"taskManagerRaw"; InstanceId = currentActivation.InstanceId }
                new RawActorRef<TaskManager>(rawProxyRef) :> ActorRef<TaskManager>

            let workerPool = currentActivation.Resolve<WorkerPool> { Definition = def.Path; InstanceId = currentActivation.InstanceId }

            match Cluster.NodeRegistry.ResolveActivation({ Definition = lostDependency.Definition; InstanceId = currentActivation.InstanceId }, lostNode) with
            | Some activation ->
                //Throws ?
                //KeyNotFoundException
                let lostWorker = activation.ActorRef.Value

                workerPool <-- RemoveWorker (RawActorRef.FromRawProxy (lostWorker :?> ActorRef<RawProxy>))
                taskManager <-- Recover lostWorker.UUId
            | None -> ()
        with e -> 
            def.LogError e "Worker pool OnDependencyLoss fault."
            return! Async.Raise e
    }

type internal ProcessStateDefinition(parent: DefinitionPath) =
    inherit CombinedAsyncReplicatedActorDefinition<ContinuationMap, ContinuationMap.State, ContinuationMapDump, TaskLog, TaskLog.State, TaskLogEntry[]>(parent, ContinuationMap.stateMap, TaskLog.mapState)

    override __.Name = "state"
    override __.Name1 = "continuationMap"
    override __.Name2 = "taskLog"

    override __.InitState1 = ReplicatedState.create (Map.empty, Map.empty)
    override __.InitState2 = ReplicatedState.create Map.empty

    override __.Behavior1(_, _) = ContinuationMap.continuationMapBehavior
    override __.Behavior2(_, _) = Nessos.MBrace.Runtime.Definitions.TaskLog.taskLogBehavior

type internal ProcessMonitorProxyDefinition(parent: DefinitionPath) =
    inherit ReplicatedProxyActorDefinition<ProcessMonitor, Nessos.MBrace.Runtime.Definitions.PublicTypes.ProcessMonitorDb>(
                parent,
                {
                    Definition = empDef/"master"/"processMonitor"/"replicated"/"processMonitor"
                    Instance = Some 0
                    Configuration = ActivationConfiguration.Empty
                    ActivationStrategy = ActivationStrategy.masterNode
                })

    override __.Name = "processMonitorProxy"
    override __.Configuration = ActivationConfiguration.Empty
    override __.ExceptionReplyProvider =
        fun ctx msg -> match msg with
                       | InitializeProcess(RR ctx reply, _) -> reply << Exception
                       | CompleteProcess _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "CompleteProcess Exception :: %A" e)
                       | DestroyProcess _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "DestroyProcess Exception :: %A" e)
                       | FreeAllProcesses -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "FreeAllProcesses Exception :: %A" e)
                       | FreeProcess _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "FreeProcess Exception :: %A" e)
                       | ProcessMonitor.GetAllProcessInfo(RR ctx reply) -> reply << Exception
                       | GetResult(RR ctx reply, _) -> reply << Exception
                       | NotifyProcessCreated _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "NotifyProcessCreated Exception :: %A" e)
                       | NotifyProcessInitialized _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "NotifyProcessInitialized Exception :: %A" e)
                       | NotifyProcessStarted _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "NotifyProcessStarted Exception :: %A" e)
                       | NotifyProcessTaskRecovery _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "NotifyProcessTaskRecovery Exception :: %A" e)
                       | NotifyRecoverState _ -> fun e -> ctx.LogEvent(Nessos.Thespian.LogLevel.Error, sprintf' "NotifyRecoverState Exception :: %A" e)
                       | TryGetProcessInfo(RR ctx reply, _) -> reply << Exception
                       | TryGetProcessInfoByRequestId(RR ctx reply, _) -> reply << Exception
                       | TryGetProcessResult(RR ctx reply, _) -> reply << Exception


type internal SchedulerDefinition(parent: DefinitionPath) =
    inherit RawActorDefinition<Scheduler>(parent)
    
    let processMonitorProxyPath = empDef/"process"/"processMonitorProxy"
    let replicatedStateLoggerPath = empDef/"process"/"state"/"replicated"/"state"

    let getProcessMonitor instanceId =
        let processMonitorProxy = Cluster.NodeRegistry.Resolve<ReplicatedProxy<ProcessMonitor, ProcessMonitorDb>>
                                    { Definition = processMonitorProxyPath; InstanceId = instanceId }
                                  |> Seq.head

        processMonitorProxy |> ActorRef.map ReplicatedProxy

    override __.Name = "scheduler"
    override __.Configuration = ActivationConfiguration.Empty
    override __.Dependencies = 
        [{
            Definition = processMonitorProxyPath
            Instance = None
            Configuration = ActivationConfiguration.Empty
            ActivationStrategy = ActivationStrategy.collocated
         }]
    override __.Behavior(_, instanceId) = async {
        let processMonitor = getProcessMonitor instanceId
        let replicatedStateLogger = 
            Cluster.NodeRegistry.ResolveLocal<CombinedAsyncReplicated<ContinuationMap, ContinuationMapDump, TaskLog, TaskLogEntry[]>>
                                                { Definition = replicatedStateLoggerPath; InstanceId = instanceId }

        let continuationMap = replicatedStateLogger |> PowerPack.ActorRef.map FwdLeft

        let initState = Scheduler.State.New continuationMap

        return Behavior.stateful initState (Scheduler.schedulerBehavior processMonitor)
    }
//    override __.OnActorFailure(instanceId, _) = fun e ->
//        let processMonitor = getProcessMonitor instanceId
//
//        processMonitor <!= fun ch -> Replicated(ch, Choice1Of2 <| CompleteProcess(instanceId, new System.SystemException("Scheduler state corrupted. Severe system error. Contact M-Brace support.", e) :> exn |> ProcessFault))

type internal TaskManagerDefinition(parent: DefinitionPath) =
    inherit RawActorDefinition<TaskManager>(parent)

    let workerPoolPath = empDef/"process"/"workerPool"
    let replicatedStateLoggerPath = empDef/"process"/"state"/"replicated"/"state"

    override __.Name = "taskManager"
    override __.Configuration = ActivationConfiguration.Empty
    override __.Dependencies = []
    override __.Behavior(_, instanceId) = async {
        let workerPool = Cluster.NodeRegistry.ResolveLocal<WorkerPool>
                            { Definition = workerPoolPath; InstanceId = instanceId }
        let replicatedStateLogger = 
            Cluster.NodeRegistry.ResolveLocal<CombinedAsyncReplicated<ContinuationMap, ContinuationMapDump, TaskLog, TaskLogEntry[]>>
                                                { Definition = replicatedStateLoggerPath; InstanceId = instanceId }
        let taskLog = replicatedStateLogger |> PowerPack.ActorRef.map FwdRight
        let initState = TaskManager.State.Empty
        return Behavior.stateful initState (TaskManager.taskManagerBehavior instanceId workerPool taskLog)
    }

type internal WorkerDefinition(parent: DefinitionPath) =
    inherit RawActorDefinition<Worker>(parent)

    let processMonitorProxyPath = empDef/"process"/"processMonitorProxy"

    override __.Name = "worker"
    override __.Configuration = ActivationConfiguration.Empty
    override __.Dependencies =
        [{
            Definition = processMonitorProxyPath
            Instance = None
            Configuration = ActivationConfiguration.Empty
            ActivationStrategy = ActivationStrategy.collocated
        }]
    override __.Behavior(_, instanceId) = async {
        let processMonitor = Cluster.NodeRegistry.Resolve<ReplicatedProxy<ProcessMonitor, ProcessMonitorDb>>
                                { Definition = processMonitorProxyPath; InstanceId = instanceId }
                             |> Seq.head
                             |> ActorRef.map ReplicatedProxy

        let taskMap = Atom.atom Map.empty

        let initState = Worker.State.Empty

        return Behavior.stateful initState (Worker.workerBehavior instanceId processMonitor taskMap)
    }
    override def.OnDeactivate currentActivation = async {
        def.LogInfo "OnDeactivate..."
        let worker = currentActivation.Resolve<Worker> currentActivation.ActivationReference
        try
            do! worker <!- CancelAllSync
        with e -> def.LogMsg LogLevel.Warning (sprintf' "%A" e)
        def.LogInfo "OnDeactivate complete."
    }

    override __.OnNodeLossAction _ = ReActivateOnNodeLoss

//GROUP DEFINITIONS

type internal CommonGroupDefinition(parent: DefinitionPath, inMemory: bool) =
    inherit GroupDefinition(parent)

    new (parent: DefinitionPath) = CommonGroupDefinition(parent, false)

    override __.Name = "common"
    override __.Configuration = ActivationConfiguration.Empty
    override def.Collocated = 
        let loggerActorDef = new LoggerActorDefinition(def.Path)
        let assemblyManagerDef = new AssemblyManagerDefinition(def.Path)
        let processDomainManagerDef = new ProcessDomainManagerDefinition(def.Path, inMemory)
        let performanceMonitorDef = new PerformanceMonitorDefinition(def.Path)

        [loggerActorDef; assemblyManagerDef; processDomainManagerDef; performanceMonitorDef]

type internal MasterGroupDefinition(parent: DefinitionPath) =
    inherit GroupDefinition(parent)

    override __.Name = "master"
    override __.Configuration = ActivationConfiguration.Empty
    override __.Dependencies = 
        {
            Definition = empDef/"common"
            Instance = Some 0
            Configuration = ActivationConfiguration.Empty
            ActivationStrategy = ActivationStrategy.clusterWide
        }::base.Dependencies
    override def.Collocated = 
        let processMonitorDef = new ProcessMonitorDefinition(def.Path)
        let masterAssemblyManagerDef = new MasterAssemblyManager(def.Path)
        let processManagerDef = new ProcessManagerDefinition(def.Path)
    
        [processMonitorDef; masterAssemblyManagerDef; processManagerDef]

    override __.OnNodeLossAction _ = ReActivateOnNodeLossSpecific ActivationStrategy.masterNode

type internal ProcessGroupDefinition(parent: DefinitionPath) =
    inherit GroupDefinition(parent)
    
    member private def.WorkerPoolDef = new WorkerPoolDefinition(def.Path)
    member private def.ProcessStateDef = new ProcessStateDefinition(def.Path)
    member private def.SchedulerDef = new SchedulerDefinition(def.Path)
    member private def.TaskManagerDef = new TaskManagerDefinition(def.Path)

    override __.Name = "process"
    override __.Configuration = 
        ActivationConfiguration.Specify [Conf.Spec<AssemblyId list>(Configuration.RequiredAssemblies)]
    override def.Collocated = [def.WorkerPoolDef; def.ProcessStateDef; def.SchedulerDef; def.TaskManagerDef]

    override def.OnActivated(activation: Activation) = 
        let baseHandling = base.OnActivated(activation)
        revasync {
            do! baseHandling

            def.LogInfo "Setting up Scheduler and TaskManager..."

            let schedulerPath = def.SchedulerDef.Path/"scheduler"
            let taskManagerPath = def.TaskManagerDef.Path/"taskManager"

            let scheduler = activation.Resolve<Scheduler> { Definition = schedulerPath; InstanceId = activation.InstanceId }
            let taskManager = activation.Resolve<TaskManager> { Definition = taskManagerPath; InstanceId = activation.InstanceId }
            let workerPool = activation.Resolve<WorkerPool> { Definition = def.WorkerPoolDef.Path; InstanceId = activation.InstanceId }

            scheduler <-- SetTaskManager taskManager
            taskManager <-- SetScheduler scheduler

            let workers = Cluster.NodeRegistry.Resolve<RawProxy> { Definition = empDef/"process"/"worker"/"workerRaw"; InstanceId = activation.InstanceId }
                          |> Seq.map (fun rawProxyRef -> new RawActorRef<Worker>(rawProxyRef) :> ActorRef<Worker>)
                          |> Seq.toList

            def.LogInfo "Setting up Workers..."

            do! workers
                |> Seq.map ReliableActorRef.FromRef
                |> Broadcast.post (SwitchTaskManager taskManager)
                |> Broadcast.onFault (fun (failedWorker, _) -> workerPool <-- RemoveWorker failedWorker)
                |> Broadcast.ignoreFaults Broadcast.allFaults
                |> Broadcast.exec
                |> Async.Ignore
                |> RevAsync.FromAsync

            def.LogInfo "Reading task log..."

            let replicas = 
                Cluster.NodeRegistry.Resolve<RawProxy> { Definition = def.ProcessStateDef.Path/"replica"/"taskLogRaw"; InstanceId = activation.InstanceId }
                |> Seq.map (fun r -> new RawActorRef<Choice<TaskLog, Stateful<TaskLogEntry[]>>>(r) :> ActorRef<_>)
                

            let allMaps =
                [| for entries in replicas |> Seq.choose (fun taskLog -> try Some( taskLog <!= fun ch -> Choice1Of2(Read ch) ) with _ -> None) ->
                        entries |> Seq.map (fun (taskId, parentTaskId, _, _) -> taskId, parentTaskId)
                                |> Map.ofSeq
                |]

            def.LogInfo "Task log sanity check."
            try
                let isSane = allMaps |> Array.forall (fun m -> allMaps |> Array.forall (fun m' -> m = m'))
                def.LogInfo <| sprintf "Sanity check complete. %A" isSane
                //if not isSane then runtime <-- Shutdown
            with e ->
                def.LogError e "Sanity check failed."
                return! RevAsync.Raise <| System.SystemException("Sanity check failed.")

            let taskLogPath = def.ProcessStateDef.Path/"local"/"taskLog"
            let taskLog = Cluster.NodeRegistry.ResolveLocal<Choice<TaskLog, Stateful<TaskLogEntry[]>>> { Definition = taskLogPath; InstanceId = activation.InstanceId }

            let! taskLogEntries = RevAsync.FromAsync( taskLog <!- fun ch -> Choice1Of2(TaskLog.Read ch) )

            let logMap = taskLogEntries |> Seq.map (fun (taskId, parentTaskId, worker, payload) -> taskId, (parentTaskId, worker, payload))
                                        |> Map.ofSeq

            def.LogInfo <| sprintf' "%d entries read." taskLogEntries.Length

            let tasksToRetry = 
                taskLogEntries |> Array.fold (fun tasksToRetry' (taskId, pTaskId, _, payload) -> 
                                                match pTaskId with
                                                | Some parentTaskId ->
                                                    match logMap |> Map.tryFind parentTaskId with
                                                    | Some(grandParentTaskId, _, parentPayload) -> (grandParentTaskId, parentPayload)::tasksToRetry'
                                                    | None -> (pTaskId, payload)::tasksToRetry'
                                                | None -> 
                                                    (pTaskId, payload)::tasksToRetry'
                                            ) [] |> Seq.distinctBy (fun (_, ((_, taskId), _)) -> taskId) |> Seq.toArray

            def.LogInfo <| sprintf' "Will retry %d tasks..." tasksToRetry.Length

            taskManager <-- RecoverTasks tasksToRetry 
        }

    override __.OnNodeLossAction _ = ReActivateOnNodeLoss
    override def.OnNodeLoss(lostNode, activationRef) = async {
        let workerActivationRef = { Definition = empDef/"process"/"worker"/"workerRaw"; InstanceId = activationRef.InstanceId }

        let workers =
            Cluster.NodeRegistry.Resolve<RawProxy> workerActivationRef
            |> Seq.map (fun rawProxyRef -> new RawActorRef<Worker>(rawProxyRef) :> ActorRef<Worker>)
            |> Set.ofSeq

        def.LogInfo "Cancelling all task execution in process..."

        do! workers 
            |> Set.toSeq 
            |> Seq.map ReliableActorRef.FromRef 
            |> Seq.map (fun worker -> async {
                try
                    do! worker.PostAsync CancelAll
                with e -> def.LogError e "Task cancellation failure."
            })
            |> Async.Parallel
            |> Async.Ignore
    }

//EVENT MANAGEMENT
type MBraceNodeEventManager() =
    inherit NodeEventManager()

    ///On node initialization, start the node's Runtime actor.
    override __.OnInit() = async {
        Log.logInfo "Node init:: Initializing client interfaces."

        let initState = MBraceNode.State.Empty
        
        let mbraceNode =
            Actor.bind <| FSM.fsmBehavior (FSM.goto MBraceNode.mbraceNodeManagerBehavior initState)
            |> Actor.subscribeLog (Default.actorEventHandler Default.fatalActorFailure System.String.Empty)
            |> Actor.rename "runtime"
            |> Actor.publish [Remote.TcpProtocol.Bidirectional.BTcp()] //TODO!!! Also add UTcp() ?
            |> Actor.start
        
        Cluster.Set("MBraceNode", mbraceNode)

        Log.logInfo "Node init:: Client interfaces ready."
    }

    override __.OnClusterInit(clusterId: ClusterId, clusterManager: ActorRef<ClusterManager>) = async {
        if clusterId = "HEAD" then
            Log.logInfo "OnClusterInit :: Activating master node services..."

            let masterActivationRecord = {
                Definition = empDef/"master"
                Instance = Some 0
                Configuration = ActivationConfiguration.Empty
                ActivationStrategy = ActivationStrategy.specificNode Cluster.NodeManager
            }

            try
                //FaultPoint
                //MessageHandlingException InvalidActivationStrategy => invalid argument;; collocation strategy not supported ;; SYSTEM FAULT
                //MessageHandlingException CyclicDefininitionDependency => invalid configuration;; SYSTEM FAULT
                //MessageHandlingException OutOfNodesExceptions => unable to recover due to lack of nodes;; SYSTEM FAULT
                //MessageHandlingException KeyNotFoundException ;; from NodeManager => definition.Path not found in node;; SYSTEM FAULT
                //MessageHandlingException ActivationFailureException ;; from NodeManager => failed to activate definition.Path;; SYSTEM FAULT
                //MessageHandlingException SystemCorruptionException => system failure occurred during execution;; SYSTEM FAULT
                //MessageHandlingException SystemFailureException => Global system failure;; SYSTEM FAULT
                //FailureException => SYSTEM FAULT
                do! Cluster.ClusterManager <!- fun ch -> ActivateDefinition(ch, masterActivationRecord)

                Log.logInfo "OnClusterInit :: Master node services activated."
            with MessageHandlingException2 e | e ->
                Log.logNow LogLevel.Error "OnClusterInit :: Failed to activate master node services."
                Log.logInfo "OnClusterInit :: Triggering KillCluster..."
                try Cluster.ClusterManager <-- KillCluster
                with e -> Log.logException e "OnClusterInit :: Failed to trigger KillCluster"
    }

    override __.OnMaster(clusterId: ClusterId) = async {
        if clusterId = "HEAD" then
            do MBraceNode.StateChangeEvent.Trigger(Nessos.MBrace.Runtime.NodeType.Master)
    }

    override __.OnAddToCluster(clusterId: ClusterId, clusterManager: ReliableActorRef<ClusterManager>) = async {
        if clusterId = "HEAD" then
            try
                if not (ActorRef.isCollocated Cluster.ClusterManager) then
                    do MBraceNode.StateChangeEvent.Trigger(Nessos.MBrace.Runtime.NodeType.Slave)

                Log.logInfo "OnAddToCluster :: Initializing ProcessDomain cluster..."

                let processDomainClusterConfiguration' = ClusterConfiguration.New "processDomainCluster"
                let processDomainClusterConfiguration = 
                    { processDomainClusterConfiguration' with 
                        NodeDeadNotify = (
                                            fun _ -> async {
                                                if ActorRef.isCollocated Cluster.ClusterManager then
                                                    System.Diagnostics.Process.GetCurrentProcess().Kill()
                                                else
                                                    do! Cluster.NodeManager <-!- DetachFromCluster
                                                    do! Cluster.ClusterManager <-!- RemoveNode Cluster.NodeManager 
                                            })}

                //FaultPoint
                //-
                let! _ = Cluster.NodeManager <!- fun ch -> InitCluster(ch, processDomainClusterConfiguration)
                //FaultPoint
                //-
                let! processDomainClusterManager = Cluster.NodeManager <!- fun ch -> TryGetManagedCluster(ch, "processDomainCluster")

                //Throws
                //NullReferenceException => SYSTEM FAULT
                Cluster.Set("processDomainClusterManager", processDomainClusterManager.Value)

                Log.logInfo "OnAddToCluster :: ProcessDomain cluster initialized."
            with e ->
                Log.logNow LogLevel.Error <| sprintf' "OnAddToCluster :: %A" e
                Log.logInfo "OnAddToCluster :: Triggering KillCluster..."
                try Cluster.ClusterManager <-- KillCluster
                with e -> Log.logException e "OnAddToCluster :: Failed to trigger KillCluster"
    }

    override __.OnAttachToCluster(clusterId: ClusterId, clusterManager: ReliableActorRef<ClusterManager>) = async {
        try
            let isCommonActivated =
                empDef/"common" |> ActivationReference.FromPath |> Cluster.NodeRegistry.IsActivatedLocally

            if not isCommonActivated then

                Log.logInfo "OnAttachToCluster :: Activating common node services..."
 
                let commonActivationRecord = {
                    Definition = empDef/"common"
                    Instance = Some 0
                    Configuration = ActivationConfiguration.Empty
                    ActivationStrategy = ActivationStrategy.specificNode Cluster.NodeManager
                }

                //FaultPoint
                //-
                do! clusterManager <!- fun ch -> ActivateDefinition(ch, commonActivationRecord)

            
                Log.logInfo "OnAttachToCluster :: Common node services activated."
        
                //Create workers for processes
        
                //FaultPoint
                //-
                let! r = Cluster.ClusterManager <!- fun ch -> ResolveActivationRefs(ch, empDef/"master"/"masterAssemblyManager" |> ActivationReference.FromPath)
                if r.Length <> 0 then // if is 0 then there is no masterAssemblyManager, meaning master services are not activated, meaning no processes
                    Log.logInfo "OnAttachToCluster :: Adding existing processes to node..."

                    //1: Give all assemblies to node

                    //Throws
                    //-
                    let masterAssemblyManager = ReliableActorRef.FromRef (r.[0] :?> ActorRef<AssemblyManager>)

                    //FaultPoint
                    //-
                    let! images = masterAssemblyManager <!- GetAllImages

                    Log.logInfo "OnAttachToCluster :: Downloaded assemblies."

                    //Throws
                    //-
                    let assemblyManager = Cluster.NodeRegistry.ResolveLocal<AssemblyManager>
                                            (empDef/"common"/"assemblyManager" |> ActivationReference.FromPath)

                    //FaultPoint
                    //-
                    let! _ = assemblyManager <!- fun ch -> CacheAssemblies(ch, images)

                    Log.logInfo "OnAttachToCluster :: Loaded assemblies."

                    Log.logInfo "OnAttachToCluster :: Recovering process information..."

                    //2: Get all processes (all workerPools)
                    //FaultPoint
                    //-
                    let! workerPoolActivations = Cluster.ClusterManager <!- fun ch -> ResolveActivationInstances(ch, empDef/"process"/"workerPool")

                    //Throws
                    //-
                    let processDomainManager = Cluster.NodeRegistry.ResolveLocal<ProcessDomainManager>
                                                    (empDef/"common"/"processDomainManager" |> ActivationReference.FromPath)

                    let! r' = Cluster.ClusterManager <!- fun ch -> ResolveActivationRefs(ch, empDef/"master"/"processMonitor"/"replicated"/"processMonitor" |> ActivationReference.FromPath)
                    let processMonitor = ReliableActorRef.FromRef (r'.[0] :?> ActorRef<Replicated<ProcessMonitor, ProcessMonitorDb>>)

                    //3: For each process
                    for workerPoolActivation in workerPoolActivations do
                        let processId = workerPoolActivation.ActivationReference.InstanceId

                        Log.logInfo <| sprintf' "OnAttachToCluster :: Adding process %A to node..." processId

                        //Throws
                        //-
                        let workerPool = ReliableActorRef.FromRef (workerPoolActivation.ActorRef.Value :?> ActorRef<WorkerPool>)
                        //FaultPoint
                        //-
                        let! processInfo = processMonitor <!- fun ch -> Singular(Choice1Of2 <| TryGetProcessInfo(ch, processId))
                        match processInfo with
                        | Some { Dependencies = requiredAssemblies } ->
                            //4.1 Create Worker in process domain
                            let workerActivationRecord = {
                                Definition = empDef/"process"/"worker"
                                Instance = Some processId
                                Configuration = ActivationConfiguration.FromValues [Conf.Val Configuration.RequiredAssemblies requiredAssemblies]
                                ActivationStrategy = ActivationStrategy.specificNode Cluster.NodeManager
                            }
                            //FaultPoint
                            //-
                            let! activations, _ = clusterManager <!- fun ch -> ActivateDefinitionWithResults(ch, true, workerActivationRecord, Array.empty, Array.empty)
                
                            //Throws
                            //-
                            let workerActivation = 
                                activations |> Seq.find (fun clusterActivation -> clusterActivation.ActivationReference.Definition = empDef/"process"/"worker"/"workerRaw")

                            let worker = new RawActorRef<Worker>(workerActivation.ActorRef.Value :?> ActorRef<RawProxy>) :> ActorRef<Worker>

                            let taskManagerActivationRef = {
                                Definition = empDef/"process"/"taskManager"/"taskManagerRaw"
                                InstanceId = processId
                            }

                            let! r = clusterManager <!- fun ch -> ResolveActivationRefs(ch, taskManagerActivationRef)
                            let taskManager = new RawActorRef<TaskManager>(r.[0] :?> ActorRef<RawProxy>) :> ActorRef<TaskManager>
    //                            let taskManagerActivation = 
    //                                activations |> Seq.find (fun clusterActivation -> clusterActivation.ActivationReference.Definition = empDef/"process"/"taskManager"/"taskManagerRaw")
    //                            new RawActorRef<TaskManager>(taskManagerActivation.ActorRef.Value :?> ActorRef<RawProxy>) :> ActorRef<TaskManager>

                            worker <-- Worker.SwitchTaskManager taskManager

                            //4.2 Add worker to WorkerPool
                            //FaultPoint
                            //-
                            workerPool <-- AddWorker worker
                        | None -> () //process has probably finished

                    Log.logInfo "All processes added to current node."
            else
                Log.logInfo "OnAttachToCluster :: Common node services already active"
        with e ->
            Log.logError <| sprintf' "OnAttachToCluster :: %A" e
            Log.logInfo "OnAttachToCluster :: Triggering KillCluster..."
            try Cluster.ClusterManager <-- KillCluster
            with e -> Log.logException e "OnAttachToCluster :: Failed to trigger KillCluster"
    }

    override __.OnRemoveFromCluster(clusterId: ClusterId) =
        async {
            
            return ()
        }

type ProcessDomainNodeEventManager() =
    inherit NodeEventManager()
    
module DefinitionRegistry =
    let definitionRegistry =
        DefinitionRegistry.Empty
            .Register(new CommonGroupDefinition(empDef))
            .Register(new MasterGroupDefinition(empDef))
            .Register(new ProcessGroupDefinition(empDef))
            .Register(new WorkerDefinition(empDef/"process"))
            .Register(new ProcessMonitorProxyDefinition(empDef/"process"))

    let inMemoryDefinitionRegistry =
        DefinitionRegistry.Empty
            .Register(new CommonGroupDefinition(empDef, true))
            .Register(new MasterGroupDefinition(empDef))
            .Register(new ProcessGroupDefinition(empDef))
            .Register(new WorkerDefinition(empDef/"process"))
            .Register(new ProcessMonitorProxyDefinition(empDef/"process"))


module ActivationPatterns =
    let private actorActivationMap = new System.Collections.Generic.Dictionary<ActivationReference, ActorRef option * ActorRef<NodeManager>>(HashIdentity.Structural)
    let private definitionActivationMap = new System.Collections.Generic.Dictionary<ActivationReference, ActorRef<NodeManager>>(HashIdentity.Structural)

    let processActivation =
        let pattern (ctx: BehaviorContext<_>) 
                    (processDomainClusterManager: ActorRef<ClusterManager>) 
                    (activationReference: ActivationReference)
                    (dependencyActivations: ClusterActivation [], dependencyActiveDefinitions: ClusterActiveDefinition []) =
            if activationReference.Definition.IsDescendantOf(empDef/"process") then
                let activate (instanceId: int, activationConfiguration: ActivationConfiguration) = revasync {
                    ctx.LogInfo (sprintf' "Cloud process %A :: activating %O..." instanceId activationReference.Definition)
                    
                    //Throws
                    //KeyNotFoundException => unknown definition ;; System fault ;; rethrow SystemCorruptionException
                    let definition = Cluster.DefinitionRegistry.Resolve activationReference.Definition

                    //Throws
                    //ActivationResolutionException => activationRef not found ;; System fault ;; rethrow SystemCorruptionException
                    let processDomainManager = 
                        Cluster.NodeRegistry.ResolveLocal<ProcessDomainManager>(empDef/"common"/"processDomainManager" |> ActivationReference.FromPath)

                    //Throws
                    //KeyNotFoundException => config value not found ;; System fault ;; rethrow SystemCorruptionException
                    let requiredAssemblies = activationConfiguration.Get<AssemblyId list>(Configuration.RequiredAssemblies)

                    ctx.LogInfo "Allocating process domain..."

                    //allocate process domain for process
                    let! processDomainNodeManager, clusterProxyManager, proxyMap = 
                        //TODO!!! Extract to method on ProcessDomainManager
                        //FaultPoint
                        //-
                        RevAsync.FromAsync(
                            async { 
                                let! unreliableProcessDomainManager, clusterProxyManager, proxyMap = 
                                    processDomainManager <!- fun ch -> AllocateProcessDomainForProcess(ch, instanceId, requiredAssemblies)
                                return ReliableActorRef.FromRef unreliableProcessDomainManager, clusterProxyManager, proxyMap
                            },
                            fun _ -> async { processDomainManager <-- DeallocateProcessDomainForProcess instanceId })

                    ctx.LogInfo "Process domain allocated."
                    
                    let activationStrategy = ActivationStrategy.specificNode processDomainNodeManager

                    let activationRecord = {
                        Definition = activationReference.Definition
                        Instance = Some activationReference.InstanceId
                        Configuration = activationConfiguration
                        ActivationStrategy = activationStrategy
                    }

                    ctx.LogInfo (sprintf' "%A :: Activating %O in process domain..." instanceId activationReference.Definition)

                    //Throws
                    //KeyNotFoundException
                    //-
                    let dependencyActivations' =
                        dependencyActivations |> Array.map (fun clusterActivation ->
                            if clusterActivation.NodeManager = Cluster.NodeManager then
                                match actorActivationMap.TryFind clusterActivation.ActivationReference with
                                | Some(actorRef, realNode) -> { clusterActivation with NodeManager = realNode; ActorRef = actorRef }
                                | None -> clusterActivation
                            else clusterActivation)

                    //Throws
                    //KeyNotFoundException
                    //-
                    let dependencyActiveDefinitions' =
                        dependencyActiveDefinitions |> Array.map (fun clusterActiveDefinition ->
                            if clusterActiveDefinition.NodeManager = Cluster.NodeManager then
                                match definitionActivationMap.TryFind clusterActiveDefinition.ActivationReference with
                                | Some realNode -> { clusterActiveDefinition with NodeManager = realNode }
                                | None -> clusterActiveDefinition
                            else clusterActiveDefinition)

                    //FaultPoint
                    //-
                    let! clusterActivations, clusterActiveDefinitions =
                        RevAsync.FromAsync(
                            ( processDomainClusterManager <!- fun ch -> ActivateDefinitionWithResults(ch, false, activationRecord, dependencyActivations', dependencyActiveDefinitions') ),
                            fun _ -> ( processDomainClusterManager <!- fun ch -> DeActivateDefinition(ch, activationReference) )
                        )

                    ctx.LogInfo (sprintf' "%A :: %O activated." instanceId activationReference.Definition)

                    for clusterActivation in clusterActivations do
                        if not (actorActivationMap.ContainsKey clusterActivation.ActivationReference) then
                            actorActivationMap.Add(clusterActivation.ActivationReference, (clusterActivation.ActorRef, processDomainNodeManager.UnreliableRef))

                    for clusterActiveDefinition in clusterActiveDefinitions do
                        if not (definitionActivationMap.ContainsKey clusterActiveDefinition.ActivationReference) then
                            definitionActivationMap.Add(clusterActiveDefinition.ActivationReference, processDomainNodeManager.UnreliableRef)

                    let proxyfiedActivations =
                        if clusterProxyManager.IsSome then
                            ctx.LogInfo (sprintf' "%A :: Initializing proxies..." instanceId)

                            clusterActivations 
                            |> Array.map (fun clusterActivation ->
                                match clusterActivation.ActorRef with
                                | Some(:? ActorRef<RawProxy> as actorRef) ->
                                    ctx.LogInfo (sprintf' "%A :: Registering proxy for %O"  instanceId clusterActivation.ActivationReference.Definition)
                                    
                                    //in memory
                                    //TODO!!! Make into a RevAsync with recovery
                                    Nessos.Thespian.Atom.swap proxyMap.Value (Map.add clusterActivation.ActivationReference (ReliableActorRef.FromRef actorRef))
                                    //clusterProxyManager.Value <-- RegisterProxy(clusterActivation.ActivationReference, actorRef)

                                    let proxyRef =
                                        new ProxyActorRef(actorRef.UUId, actorRef.Name, ReliableActorRef.FromRef clusterProxyManager.Value, clusterActivation.ActivationReference)
                                        :> ActorRef

                                    ctx.LogInfo (sprintf' "%A :: Proxy reference instance created." instanceId)

                                    { clusterActivation with ActorRef = Some proxyRef }
                                | _ -> clusterActivation
                            )
                        else clusterActivations

                    let localActivations = proxyfiedActivations |> Seq.map (fun activation -> { activation with NodeManager = Cluster.NodeManager })
                    let localActiveDefinitions = clusterActiveDefinitions |> Seq.map (fun activeDef -> { activeDef with NodeManager = Cluster.NodeManager })

                    Cluster.NodeRegistry.RegisterBatchOverriding(localActivations, localActiveDefinitions)

                    ctx.LogInfo "Activation results registered."

                    let activation = {
                        new Activation(instanceId, definition) with
                            override __.DeactivateAsync() = async {
                                if clusterProxyManager.IsSome then
                                    ctx.LogInfo "Unregistering proxies..."
                                    proxyfiedActivations
                                    |> Seq.filter (fun activationResult -> activationResult.ActorRef.IsSome 
                                                                           && match activationResult.ActorRef.Value with :? ProxyActorRef -> true | _ -> false)
                                    |> Seq.iter (fun activationResult -> Nessos.Thespian.Atom.swap proxyMap.Value (Map.remove activationResult.ActivationReference))
                                                                         //clusterProxyManager.Value <-- UnregisterProxy activationResult.ActivationReference) //in memory

                                for localActivation in localActivations do
                                    actorActivationMap.Remove(localActivation.ActivationReference) |> ignore
                                    Cluster.NodeRegistry.UnRegisterActivation(Cluster.NodeManager, localActivation.ActivationReference)

                                for localActiveDefinition in localActiveDefinitions do
                                    definitionActivationMap.Remove(localActiveDefinition.ActivationReference) |> ignore
                                    Cluster.NodeRegistry.UnRegisterDefinition(Cluster.NodeManager, localActiveDefinition.ActivationReference)

                                //FaultPoint
                                //-
                                do! processDomainClusterManager <!- fun ch -> DeActivateDefinition(ch, activationReference)

                                //in memory
                                processDomainManager <-- DeallocateProcessDomainForProcess instanceId
                            }

                            override __.ActorActivationResults = localActivations
                            override __.DefinitionActivationResults = localActiveDefinitions
                    }

                    ctx.LogInfo (sprintf' "Cloud process %A :: %O activated." instanceId activationReference.Definition)

                    return activation
                }

                Some activate
            else None

        {
            ClusterId = "processDomainCluster"
            PatternF = pattern
        }



module Service =
    open System
    open System.Net
    open Nessos.Thespian.Remote.TcpProtocol

    let private ipAny = IPAddress.Any.ToString()

    let boot (hostname: string) (ips: IPAddress list) (primaryPort: int) =

        let toLoopback (addr : Address) = AddressUtils.changePort addr.Port Address.LoopBack

        let endpoints = 
            match ips with
            | [] -> [new IPEndPoint(IPAddress.Any, primaryPort)]
            | _ -> ips |> List.map (fun ip -> new IPEndPoint(ip, primaryPort))

        Log.logInfo "{m}brace Runtime Service"
        Log.logInfo "START..."

        Log.logInfo (sprintf "Hostname: %s" hostname)
        Log.logInfo (sprintf "Listening to endpoints: %A" endpoints)

        TcpListenerPool.DefaultHostname <- hostname

        for endpoint in endpoints do
            TcpListenerPool.RegisterListener(endpoint, concurrentAccepts = 10)

        // pass primary connection port to processDomainManager
        IoC.RegisterValue(Address.LoopBack |> AddressUtils.changePort primaryPort, "primaryAddress", behaviour = Override)

        Log.logInfo "Available endpoints registered."

        let nodeConfiguration = {
            NodeAddress = new Address(hostname, primaryPort)
            DefinitionRegistry = DefinitionRegistry.definitionRegistry
            EventManager = new MBraceNodeEventManager()
            ActivationPatterns = [ActivationPatterns.processActivation]
        }

        Log.logInfo "Initializing node..."

        NodeManager.initNode nodeConfiguration
        |> Async.Start

    let bootProcessDomain (primaryAddress: Address) =
        Log.logInfo "{m}brace Runtime Service"
        Log.logInfo "START PROCESS DOMAIN..."

        Log.logInfo (sprintf' "Address: %A" primaryAddress)

        let nodeConfiguration = {
            NodeAddress = primaryAddress
            DefinitionRegistry = DefinitionRegistry.definitionRegistry
            EventManager = new ProcessDomainNodeEventManager()
            ActivationPatterns = []
        }

        Log.logInfo "Initializing node..."

        NodeManager.initNode nodeConfiguration
        |> Async.Start

    let bootSingle addr = 
//        boot addr
        Cluster.Get("MBraceNode", System.Threading.Timeout.Infinite)

//    let bootInMemory (port: int) (nodeCount: int) =
//        let address = new Address("locahost", port)
//
//        boot address
//
//        let master = Cluster.Get("MBraceNode", System.Threading.Timeout.Infinite)
//
//
//
//        ()
        


