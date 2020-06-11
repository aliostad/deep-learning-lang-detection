module internal Nessos.MBrace.Runtime.Definitions.InMemoryProcessDomainManager

open System
open Nessos.Thespian
open Nessos.Thespian.Cluster
open Nessos.Thespian.Cluster.BehaviorExtensions

open Nessos.MBrace.Runtime

type State = {
    ProcessDomainMap: Map<ProcessDomainId, Actor<NodeManager>>
    ProcessMap: Map<ProcessId, ProcessDomainId>
    ProcessMonitor: ActorRef<Replicated<ProcessMonitor, ProcessMonitorDb>>
} with
    static member Empty = {
        ProcessDomainMap = Map.empty
        ProcessMap = Map.empty
        ProcessMonitor = ActorRef.empty()
    }

let processManagerBehavior (ctx: BehaviorContext<_>) (state: State) (msg: ProcessDomainManager) =
    async {
        match msg with
        | CreateProcessDomain(R reply, preloadAssemblies) ->
            try
                let processDomainId = Guid.NewGuid()

                let address = 
                    Cluster.NodeManager.Configurations |> Seq.choose (function :? Remote.TcpProtocol.Unidirectional.UTcp as utcp -> Some utcp | _ -> None)
                    |> Seq.map (fun utcp -> match utcp.Addresses with [] -> None | addr::_ -> Some addr)
                    |> Seq.choose id
                    |> Seq.head

                let nodeEventManager = new NodeEventManager()

                let processDomainNodeConfig = {
                    NodeAddress = address
                    DefinitionRegistry = Cluster.DefinitionRegistry
                    EventManager = nodeEventManager
                    ActivationPatterns = []
                }

                let! processDomainNodeManager = NodeManager.createNodeManager processDomainNodeConfig

                reply <| Value (processDomainNodeManager.Ref, processDomainId, true)

                let state' = { state with ProcessDomainMap = state.ProcessDomainMap |> Map.add processDomainId processDomainNodeManager }

                return state'
            with e ->
                ctx.LogError e
                reply <| Exception e

                return state

        | DestroyProcessDomain processDomainId ->
            try
                let processDomainNodeManager = state.ProcessDomainMap.[processDomainId]

                processDomainNodeManager.Stop()
            with e ->
                ctx.LogError e

            return { state with ProcessDomainMap = state.ProcessDomainMap |> Map.remove processDomainId }

        | ClearProcessDomains(R reply) ->
            try
                for processDomainNodeManager in state.ProcessDomainMap |> Map.toSeq |> Seq.map snd do 
                    processDomainNodeManager.Stop()

                reply nothing
            with e -> ctx.LogError e

            return { state with ProcessDomainMap = Map.empty }

//        | SetProcessMonitor processMonitor ->
//            return { state with ProcessMonitor = processMonitor }

        | AllocateProcessDomainForProcess(R reply, processId, assemblyIds) ->
            try
                let processDomainId, processDomainNodeManager = state.ProcessDomainMap |> Map.toSeq |> Seq.head

                reply <| Value (processDomainNodeManager.Ref, None, None)

                return { state with ProcessMap = state.ProcessMap |> Map.add processId processDomainId }
            with e ->
                ctx.LogError e
                reply <| Exception e
                return state

        | DeallocateProcessDomainForProcess processId ->
            return { state with ProcessMap = state.ProcessMap |> Map.remove processId }
    }
