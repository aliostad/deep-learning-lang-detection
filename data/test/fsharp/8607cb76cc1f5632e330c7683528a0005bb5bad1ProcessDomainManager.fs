module internal Nessos.MBrace.Runtime.Definitions.ProcessDomainManager

module Configuration =
    let IsolateProcesses = "IsolateProcesses"
    let PortPool = "PortPool"
    let ProcessDomainPoolSize = "ProcessDomainPoolSize"

open System
open System.Diagnostics

open Nessos.Thespian
open Nessos.Thespian.AsyncExtensions
open Nessos.Thespian.Remote.TcpProtocol
open Nessos.Thespian.Cluster
open Nessos.Thespian.ImemDb

open Nessos.Vagrant

open Nessos.MBrace.Runtime
open Nessos.MBrace.Runtime.ProcessDomain.Configuration
open Nessos.MBrace.Utils
open Nessos.MBrace.Utils.String


//Process creation strategy
//A single process domain may host more than one cloud processes
//How is a new process allocated to a process domain is controlled by
//the process creation strategy.
//A new process can either:
//i). Reuse an existing process domain, if that process domain has all the required
//dependencies already loaded
//ii). Extend an existing process domain, if that process domain has some of the required
//dependencies, and there are no conflicting dependencies
//iii). Create a new process domain to host the process.
//Note: These are purely disjoint. For a particular process domain and process only one of these
//is possible.
//By default, a process is allocated to the process domain with the least hosted processes,
//if that can be reused or extended. If reuse/extend is not possible for that process domain,
//a new process domain is created to host the process.
//This behavior can be changed by assigning priorities to reuse/extend/create, from 0 to 100.
//The higher the priotiy the more likely this strategy is going to be chosen.
//How it works: Candidate process domains are sorted is ascending order of hosted processes,
//and for each the possible strategy is determined. Then, the process domains are re-sorted,
//where the hosted process count is descreased by priority percent. The first process domain
//and strategy is chosen in the generated order.

type private ProcessCreationStrategy = Reuse | Extend of Set<AssemblyId> | Create
//priorities for process creation strategy; use 0 to 100, 100 meaning highest priority
let private reusePriority = 60
let private extendPriority = 50
let private createPriority = 0

type OsProcess = System.Diagnostics.Process

module Atom = Nessos.MBrace.Utils.Atom

type State = {
    Db: ProcessDomainDb
    //ProcessMonitor: ReliableActorRef<Replicated<ProcessMonitor, ProcessMonitorDb>>
    PortPool: int list
} with
    static member Init(?portPool: int list) = {
        Db = ProcessDomainDb.Create()
        //ProcessMonitor = ReliableActorRef.FromRef <| ActorRef.empty()
        PortPool = defaultArg portPool []
    }

//TODO!!! Handle failures
let private createProcessDomain (ctx: BehaviorContext<_>) clusterManager processDomainId preloadAssemblies portOpt =
    async {
        ctx.LogInfo (sprintf' "Creating process domain %A..." processDomainId)

        //create os process of cloud process
        let ospid = System.Diagnostics.Process.GetCurrentProcess().Id
        let processExecutable = IoC.Resolve<string> "MBraceProcessExe"
        let debugMode = defaultArg (IoC.TryResolve<bool> "debugMode") false

        let storeEndpoint = IoC.Resolve<string> "storeEndpoint"
        let storeProvider = IoC.Resolve<string> "storeProvider"
                    
        let cacheStoreEndpoint = IoC.Resolve<string> "cacheStoreEndpoint"

//        let serializerName = IoC.Resolve<string> "defaultSerializerName"
//        let compressSerialization = IoC.Resolve<bool> "compressSerialization"
        // protocol specific! should be changed
        let primaryAddr = IoC.Resolve<Address> "primaryAddress"
        //sprintf "%s%cmbrace.process.exe" AppDomain.CurrentDomain.BaseDirectory Path.DirectorySeparatorChar

#if APPDOMAIN_ISOLATION
        let command = processExecutable

        let args =
            [
                yield Parent_Pid ospid
                yield Process_Domain_Id processDomainId
                yield Assembly_Cache AssemblyCache.CachePath
                yield Parent_Address <| primaryAddr.ToString ()
                yield Store_EndPoint storeEndpoint
                yield Store_Provider storeProvider
                yield Debug debugMode
                match portOpt with
                | Some selectedPort ->
                    yield HostName TcpListenerPool.DefaultHostname
                    yield Port selectedPort
                | None -> ()

                if cacheStoreEndpoint <> null then
                    yield Cache_Store_Endpoint cacheStoreEndpoint
            ] 
            |> workerConfig.Print

#else                                
        let args =
            [
                yield Parent_Pid ospid
                yield Process_Domain_Id processDomainId
                failwith "fix cache path"
//                yield Assembly_Cache AssemblyCache.CachePath
                yield Parent_Address <| primaryAddr.ToString ()
                yield Store_EndPoint storeEndpoint
                yield Store_Provider storeProvider
                yield Debug debugMode
                match portOpt with
                | Some selectedPort ->
                    yield HostName TcpListenerPool.DefaultHostname
                    yield Port selectedPort
                | None -> ()

                if cacheStoreEndpoint <> null then
                    yield Cache_Store_Endpoint cacheStoreEndpoint
            ]

        let command, args =
            if runsOnMono then
                "mono", sprintf' "%s %s" processExecutable <| workerConfig.PrintCommandLineFlat args
            else
                processExecutable, workerConfig.PrintCommandLineFlat args
#endif

        use nodeManagerReceiver = Receiver.create()
                                  |> Receiver.rename "activatorReceiver"
                                  |> Receiver.publish [Unidirectional.UTcp()]
                                  |> Receiver.start
        
        let awaitNodeManager = nodeManagerReceiver |> Receiver.toObservable |> Async.AwaitObservable
        ctx.LogInfo (sprintf' "Receiver address %O" primaryAddr)
        ctx.LogInfo "Spawning process domain..."

#if APPDOMAIN_ISOLATION
        let appDomain = AppDomain.CreateDomain(processDomainId.ToString())
        async { appDomain.ExecuteAssembly(command, args) |> ignore } |> Async.Start
        let killF () = AppDomain.Unload appDomain
#else
        let startInfo = new ProcessStartInfo(command, args)
        startInfo.UseShellExecute <- false
        startInfo.CreateNoWindow <- true
        let osProcess = Process.Start(startInfo)

        let killF () = osProcess.Kill()
#endif
        
        //receive NodeManager and confirm it
        //TODO!!! Add timeout on wait
        let! R(reply), processDomainNodeManager = awaitNodeManager
        reply nothing

        ctx.LogInfo (sprintf' "Process domain %A spawned." processDomainId)

        ctx.LogInfo "Adding to cluster..."
        do! clusterManager <!- fun ch -> AddNodeSync(ch, processDomainNodeManager)
        
        ctx.LogInfo "Activating assembly manager..."

        let assemblyManagerRecord = {
            Definition = empDef/"common"/"assemblyManager"
            Instance = Some 0
            Configuration = ActivationConfiguration.Empty
            ActivationStrategy = ActivationStrategy.specificNode processDomainNodeManager
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
            do! clusterManager <!- fun ch -> ActivateDefinition(ch, assemblyManagerRecord)
        with MessageHandlingException2 e | e -> return! Async.Raise <| SystemCorruptionException("System entered corrupted state.", e)

        ctx.LogInfo "Resolving assmebly manager..."

        let! r = clusterManager <!- fun ch -> ResolveActivationRefs(ch, { Definition = assemblyManagerRecord.Definition; InstanceId = 0 })
        let nodeAssemblyManager = ReliableActorRef.FromRef (r.[0] :?> ActorRef<AssemblyManager>)

        ctx.LogInfo "Loading assemblies..."

        //FaultPoint
        //-
        do! nodeAssemblyManager <!- fun ch -> LoadAssembliesSync(ch, preloadAssemblies)

        ctx.LogInfo "Process domain created."

        return processDomainNodeManager, killF
    }

let rec processDomainManagerBehavior (processDomainClusterManager: ActorRef<ClusterManager>)
                                     (ctx: BehaviorContext<_>)
                                     (state: State)
                                     (msg: ProcessDomainManager) =

    async {
        match msg with
        | CreateProcessDomain(RR ctx reply, preloadAssemblies) ->
            //TODO!!! Sanitize failure handling. Use RevAsync perhaps

            let processDomainId = Guid.NewGuid()

            try
                //First check if we can assign the process domain a public endpoint
                let portOpt, state' =
                    match state.PortPool with
                    | [] -> None, state
                    | available::rest -> Some available, { state with PortPool = rest }

                let! processDomainNodeManager, killF = createProcessDomain ctx processDomainClusterManager processDomainId preloadAssemblies portOpt

                let clusterProxyManager, proxyMap =
                    if portOpt.IsNone then
                        ctx.LogInfo "Starting cluster proxy manager..."

                        let proxyMap = Nessos.Thespian.Atom.atom Map.empty<ActivationReference, ReliableActorRef<RawProxy>>

                        let name = sprintf' "clusterProxyManager.%A" processDomainId
                        Actor.bind <| Behavior.stateless (ClusterProxy.clusterProxyBehavior proxyMap)
                        |> Actor.subscribeLog (Default.actorEventHandler Default.fatalActorFailure name)
                        |> Actor.rename name
                        |> Actor.publish [Unidirectional.UTcp()]
                        |> Actor.start
                        |> Some,
                        Some proxyMap
                    else None, None

                ctx.LogInfo (sprintf' "Process domain %A ready." processDomainId)

                reply <| Value (processDomainNodeManager, processDomainId, portOpt.IsSome)

                return { state' with 
                            Db = state.Db |> Database.insert <@ fun db -> db.ProcessDomain @> {
                                Id = processDomainId
                                NodeManager = ReliableActorRef.FromRef processDomainNodeManager
                                LoadedAssemblies = preloadAssemblies |> Set.ofList
                                Port = portOpt
                                ClusterProxyManager = clusterProxyManager
                                ClusterProxyMap = proxyMap
                                KillF = killF
                            }
                        }
            with e -> 
                ctx.LogInfo "Process domain creation failed due to error."
                ctx.LogError e

                ctx.Self <-- DestroyProcessDomain processDomainId

                reply <| Exception e

                return state

        | DestroyProcessDomain processDomainId ->
            try
                match state.Db.ProcessDomain.DataMap.TryFind processDomainId with
                | Some { NodeManager = processDomainNodeManager; Port = portOpt; ClusterProxyManager = clusterProxyManager; KillF = killF } ->
                    ctx.LogInfo <| sprintf "Destroying process domain: %A" processDomainId

                    processDomainClusterManager <-- DetachNodes [| processDomainNodeManager |]

                    ctx.LogInfo "Detach from process domain cluster triggered."

                    do if clusterProxyManager.IsSome then clusterProxyManager.Value.Stop()

                    do killF()

                    return { state with
                                Db = state.Db |> Database.remove <@ fun db -> db.ProcessDomain @> processDomainId
                                              |> Database.delete <@ fun db -> db.Process @> <@ fun cloudProcess -> cloudProcess.ProcessDomain = processDomainId @>
                                PortPool = match portOpt with Some port -> port::state.PortPool | None -> state.PortPool
                            }
                | None -> 
                    ctx.LogWarning <| sprintf' "Attempted to destroy a non existent process domain: %A" processDomainId

                    return state
            with e ->
                //TODO!!! unxpected exception;; trigger system fault
                ctx.LogError e

                return state

        | ClearProcessDomains(RR ctx reply) ->
            try
                ctx.LogInfo "Clearing all process domains..."
                
                let processDomains =
                    Query.from state.Db.ProcessDomain
                    |> Query.toSeq
                    |> Seq.cache
                
                ctx.LogInfo "Detaching process domain nodes from process domain cluster..."

                do! processDomains 
                    |> Seq.map (fun processDomain -> processDomain.NodeManager.UnreliableRef)
                    |> Seq.toArray
                    |> DetachNodes
                    |> processDomainClusterManager.PostAsync

                ctx.LogInfo "Destroying process domain nodes..."

                do processDomains
                   |> Seq.map (fun processDomain -> processDomain.KillF)
                   |> Seq.iter (fun killF -> killF())

                let freedPorts =
                    processDomains
                    |> Seq.map (fun processDomain -> processDomain.Port)
                    |> Seq.choose id
                    |> Seq.toList

                ctx.LogInfo "Process domains cleared."

                reply nothing

                return { state with Db = ProcessDomainDb.Create(); PortPool = freedPorts@state.PortPool }
            with e -> 
                //TODO!!! This is an unexpected exception;; trigger system fault
                ctx.LogError e

                return state

//        | SetProcessMonitor processMonitor ->
//            return { state with ProcessMonitor = ReliableActorRef.FromRef processMonitor }

        | AllocateProcessDomainForProcess(RR ctx reply, processId, assemblyIds) ->
            try
                let existingProcessDomain =
                    Query.from state.Db.Process
                    |> Query.innerJoin state.Db.ProcessDomain <@ fun (proc, procDomain) -> proc.ProcessDomain = procDomain.Id @>
                    |> Query.where <@ fun (proc, _) -> proc.Id = processId @>
                    |> Query.toSeq
                    |> Seq.map snd
                    |> Seq.tryHead

                match existingProcessDomain with
                | None ->
                    ctx.LogInfo <| sprintf' "Allocating process domain for process %A..." processId
                        
                    //sort processDomains by number of processes
                    let candidateDomains = 
                        Query.from state.Db.ProcessDomain
                        |> Query.leftOuterJoin state.Db.Process <@ fun (processDomain, cloudProcess) -> processDomain.Id = cloudProcess.ProcessDomain @>
                        |> Query.toSeq
                        |> Seq.map (function processDomain, None -> processDomain, 0 | processDomain, _ -> processDomain, 1)
                        |> Seq.groupBy fst
                        |> Seq.map (fun (processDomainId, instances) -> processDomainId.Id, instances |> Seq.map snd |> Seq.sum)
                        |> Seq.sortBy snd

                    //Case 1: the required assemblies are already loaded
                    //in this case assemblyIds is a subset of the loaded assemblies in
                    //the candidate process domain.
                    //Case 2: a subset of the required assemblies is already loaded
                    //in this case the loaded assemblies are a subset of the required assemblies
                    //Case 3: Something is different. Create a new process domain.
                    let requestedAssemblies = assemblyIds |> Set.ofList
                    let selected = 
                        candidateDomains 
                        |> Seq.map (fun (pdid, pidCount) -> 
                            let { NodeManager = processDomainNodeManager; LoadedAssemblies = loadedAssemblies; Port = port; ClusterProxyManager = clusterProxyManager; ClusterProxyMap = clusterProxyMap } = state.Db.ProcessDomain.DataMap.[pdid]
                            if Set.isSubset requestedAssemblies loadedAssemblies then
                                pdid, processDomainNodeManager, clusterProxyManager, clusterProxyMap, Reuse, pidCount - ((pidCount * reusePriority)/100), port
                            else if Set.isSubset loadedAssemblies requestedAssemblies then
                                pdid, processDomainNodeManager, clusterProxyManager, clusterProxyMap, Extend(Set.difference requestedAssemblies loadedAssemblies), pidCount - ((pidCount * extendPriority)/100), port
                            else pdid, processDomainNodeManager, clusterProxyManager, clusterProxyMap, Create, pidCount - ((pidCount * createPriority)/100), port
                        )
                        |> Seq.sortBy (fun (_, _, _, _, _, priority, _) -> priority)
                        |> Seq.map (fun (processDomainId, processDomainNodeManager, clusterProxyManager, clusterProxyMap, strategy, _, port) -> processDomainId, processDomainNodeManager, clusterProxyManager, clusterProxyMap, strategy, port)
                        |> Seq.head

                    match selected with
                    | processDomainId, processDomainNodeManager, clusterProxyManager, clusterProxyMap, Reuse, _ ->
                            
                        ctx.LogInfo <| sprintf "Process %A is allocated to reuse process domain %A" processId processDomainId

                        reply <| Value (processDomainNodeManager.UnreliableRef, clusterProxyManager |> Option.map Actor.ref, clusterProxyMap)

                        return { state with
                                    Db = state.Db |> Database.insert <@ fun db -> db.Process @> { Id = processId; ProcessDomain = processDomainId }
                               }
                    | processDomainId, processDomainNodeManager, clusterProxyManager, clusterProxyMap, Extend extendedAssemblies, port ->
                        ctx.LogInfo <| sprintf' "Process %A is allocated to extended process domain %A" processId processDomainId

                        ctx.LogInfo <| sprintf' "Extending process domain %A..." processDomainId

                        //FaultPoint
                        //-
                        let! r = processDomainNodeManager <!- fun ch -> Resolve(ch, { Definition = empDef/"common"/"assemblyManager"; InstanceId = 0 })

                        let nodeAssemblyManager = ReliableActorRef.FromRef (r :?> ActorRef<AssemblyManager>)
                        //FaultPoint
                        //-
                        do! nodeAssemblyManager <!- fun ch -> LoadAssembliesSync(ch, extendedAssemblies |> Set.toList)

                        reply <| Value (processDomainNodeManager.UnreliableRef, clusterProxyManager |> Option.map Actor.ref, clusterProxyMap)

                        let processDomain = state.Db.ProcessDomain.DataMap.[processDomainId]

                        return { state with
                                    Db = state.Db |> Database.insert <@ fun db -> db.ProcessDomain @> 
                                                        { processDomain with LoadedAssemblies = extendedAssemblies }
                                                  |> Database.insert <@ fun db -> db.Process @> { Id = processId; ProcessDomain = processDomainId }
                                }
                    | _, _, _, _, Create, _ ->
                        ctx.LogInfo <| sprintf' "A new process domain will be allocated for process %A..." processId

                        let newProcessDomainId = ProcessDomainId.NewGuid()
                            
                        let! processDomainNodeManager, portOpt, killF, state' = 
                            async {
                                try
                                    let portOpt, state' =
                                        match state.PortPool with
                                        | [] -> None, state
                                        | available::rest -> Some available, { state with PortPool = rest }

                                    let! processDomainNodeManager, killF = createProcessDomain ctx processDomainClusterManager newProcessDomainId assemblyIds portOpt
                                    return processDomainNodeManager, portOpt, killF, state'
                                with e ->
                                    ctx.Self <-- DestroyProcessDomain newProcessDomainId
                                    return raise e
                            }

                        let clusterProxyManager, proxyMap =
                            if portOpt.IsNone then
                                let proxyMap = Nessos.Thespian.Atom.atom Map.empty
                                let name = sprintf' "clusterProxyManager.%A" newProcessDomainId
                                Actor.bind <| Behavior.stateless (ClusterProxy.clusterProxyBehavior proxyMap)
                                |> Actor.subscribeLog (Default.actorEventHandler Default.fatalActorFailure name)
                                |> Actor.rename name
                                |> Actor.publish [Unidirectional.UTcp()]
                                |> Actor.start
                                |> Some,
                                Some proxyMap
                            else None, None

                        ctx.LogInfo <| sprintf' "Process domain %A created and allocated to process %A." newProcessDomainId processId

                        let processDomainNodeManager' = ReliableActorRef.FromRef processDomainNodeManager

                        reply <| Value (processDomainNodeManager'.UnreliableRef, clusterProxyManager |> Option.map Actor.ref, proxyMap)

                        return { state' with 
                                    Db = state.Db |> Database.insert <@ fun db -> db.ProcessDomain @>
                                                        { Id = newProcessDomainId; NodeManager = processDomainNodeManager'; LoadedAssemblies = assemblyIds |> Set.ofList; Port = portOpt; KillF = killF; ClusterProxyManager = clusterProxyManager; ClusterProxyMap = proxyMap }
                                                  |> Database.insert <@ fun db -> db.Process @> { Id = processId; ProcessDomain = newProcessDomainId }
                               }
                | Some processDomain ->
                    
                    reply <| Value (processDomain.NodeManager.UnreliableRef, processDomain.ClusterProxyManager |> Option.map Actor.ref, processDomain.ClusterProxyMap)

                    return state
            with e -> 
                ctx.LogInfo "Process creation failed due to error."
                ctx.LogError e

                reply <| Exception e

                return state

        | DeallocateProcessDomainForProcess processId ->
            return { state with Db = state.Db |> Database.remove <@ fun db -> db.Process @> processId }
    }

