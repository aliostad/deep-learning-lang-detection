[<AutoOpen>]
module internal Nessos.MBrace.Runtime.Definitions.CommonTypes

open System

open Nessos.Thespian
open Nessos.Thespian.Cluster

open Nessos.Vagrant

open Nessos.MBrace
open Nessos.MBrace.Core
open Nessos.MBrace.Client
open Nessos.MBrace.Runtime
open Nessos.MBrace.Utils

type ProcessDomainId = Guid
type ResultType = Type
type ThunksIdsStack = ThunkId list
type JobId = System.Guid
type ProcessBody = ProcessBody of (ResultType * ThunksIdsStack * ICloudRef<Function list> * Dump)
type ExprImage = byte[] //The binary image of an Expr
type TaskId = Guid
type TaskHeader = ProcessId * TaskId

type TaskResult = TaskSuccess of ProcessBody | TaskFailure of exn

type LoggerMsg = LogEntry

type Scheduler = 
    //Throws
    //BroadcastFailureException => no replication at all
    | NewProcess of IReplyChannel<unit> * ProcessId * ExprImage
    | TaskResult of TaskHeader * TaskResult
    | SetTaskManager of ActorRef<TaskManager>

and TaskManager =
    //CreateRootTask(confirmationOfTaskCreation, processId, processBodyOfRootTask)
    //Throws
    //BroadcastFailureException => no replication at all
    | CreateRootTask of IReplyChannel<unit> * ProcessId * ProcessBody
    //CreateTasks(confirmationOfTaskCreation, parentTaskHeader, listOfChildTasksProcessBodies)
    | CreateTasks of IReplyChannel<unit> * TaskHeader * ProcessBody list
    //LeafTaskComplete(leafTaskId)
    | LeafTaskComplete of TaskId
    | FinalTaskComplete of IReplyChannel<unit> * TaskId
    //RetrtyTask(parentTaskId, (taskHeader, processBody))
    | RetryTask of TaskId option * (TaskHeader * ProcessBody)
    | RecoverTasks of (TaskId option * (TaskHeader * ProcessBody)) []
    | TaskResult of TaskHeader * TaskResult
    | Recover of ActorUUID
    | CancelSiblingTasks of IReplyChannel<unit> * TaskId
    | GetActiveTaskCount of IReplyChannel<int>
    | IsValidTask of IReplyChannel<bool> * TaskId
    | GetWorkerCount of IReplyChannel<int>
    | SetScheduler of ActorRef<Scheduler>

and Worker =
    | ExecuteTask of TaskHeader * ProcessBody
    | CancelTasks of TaskId[]
    | CancelAll
    | CancelAllSync of IReplyChannel<unit>
    | SwitchTaskManager of ActorRef<TaskManager>

and WorkerPool = 
    | AddWorker of ActorRef<Worker>
    | RemoveWorker of ActorRef<Worker>
    //Throws ;; nothing
    | Select of IReplyChannel<ActorRef<Worker> option>
    //Throws ;; nothing
    | SelectMany of IReplyChannel<ActorRef<Worker>[] option> * int
    | GetAvailableWorkers of IReplyChannel<ActorRef<Worker>[]>
    | GetAvailableWorkerCount of IReplyChannel<int>
//    | MapUUID of IReplyChannel<ActorUUID> * ActorUUID

and ContinuationMap =
    | SequentialAdd of ThunkId * Dump
    | SequentialRemove of ThunkId
    | ParallelAdd of ThunkId[] * Dump
    | ParallelRemove of ThunkId
    | RemoveAllParallelsOf of ThunkId //thunkId of one parallel; will remove all other parallels created along with this one
    | UpdateParallelThunkValue of ThunkId * int * CloudExpr
    | Get of IReplyChannel<Dump option> * ThunkId
    | GetAll of IReplyChannel<ContinuationMapDump>
    | Update of ThunkId * Dump

and TaskLogEntry = TaskId * TaskId option * ActorRef<Worker> * (TaskHeader * ProcessBody)
and TaskLog =
    | Log of TaskLogEntry []
    | Unlog of TaskId []
    | RetrieveByWorker of IReplyChannel<TaskLogEntry[]> * ActorUUID
    | IsLogged of IReplyChannel<bool> * TaskId
    | Read of IReplyChannel<TaskLogEntry []>
    | GetSiblingTasks of IReplyChannel<(TaskId * ActorRef<Worker>)[]> * TaskId
    //Throws ;; nothing
    | GetCount of IReplyChannel<int>

and ContinuationMapDump = (Dump * ThunkId[]) []

and ProcessCreationData = {
    ClientId: Guid
    RequestId: RequestId
    Name: string
    Type: byte[]
    TypeName: string
    Dependencies : AssemblyId list
}
and ProcessMonitor =
    //Throws
    //SystemException => run out of pid slots
    | InitializeProcess of IReplyChannel<Process> * ProcessCreationData
    | NotifyProcessInitialized of Process
    | NotifyProcessCreated of ProcessId * DateTime
//TODO!!! Uncomment
//    | NotifyProcessSchedulerAllocated of ProcessId * ActorRef<SchedulerManager> * ActorRef<ProcessDomainManager>
//    | NotifyProcessSchedulerDeallocated of ProcessId
//    | NotifyProcessLoggersAllocated of ProcessId * (ActorRef<LoggerManager> * ActorRef<ProcessDomainManager>) []
//    | NotifyProcessLoggerDeallocated of ProcessId * ActorRef<LoggerManager>
//    | NotifyProcessWorkersAllocated of ProcessId * (ActorRef<WorkerManager> * ActorRef<ProcessDomainManager>) []
//    | NotifyProcessWorkerDeallocated of ProcessId * ActorRef<WorkerManager>
    | NotifyProcessStarted of ProcessId * DateTime
    | NotifyRecoverState of ProcessId * ProcessRecoveryType option
    | CompleteProcess of ProcessId * ExecuteResultImage
    | DestroyProcess of ProcessId
    | NotifyProcessTaskRecovery of ProcessId * int
    | FreeProcess of ProcessId
    | FreeAllProcesses
//TODO!!! Uncomment
//    | NotifyNodeLoss of ActorRef<ProcessDomainManager>
    //Throws
    //SystemCorruptionException => system inconsistency;; SYSTEM FAULT
    | TryGetProcessInfo of IReplyChannel<ProcessInfo option> * ProcessId
    //Throws
    //SystemCorruptionException => system inconsistency;; SYSTEM FAULT
    | TryGetProcessInfoByRequestId of IReplyChannel<ProcessInfo option> * RequestId
    | TryGetProcessResult of IReplyChannel<ExecuteResultImage option option> * ProcessId
    | GetResult of IReplyChannel<ExecuteResultImage> * ProcessId
    | GetAllProcessInfo of IReplyChannel<ProcessInfo []>

and AssemblyManager =
    //Throws ;; nothing
    | CacheAssemblies of IReplyChannel<AssemblyLoadInfo list> * PortableAssembly list
    | GetInfo of IReplyChannel<AssemblyLoadInfo list> * AssemblyId list
    | GetAllInfo of IReplyChannel<AssemblyLoadInfo list>
    | GetImages of IReplyChannel<PortableAssembly list> * (bool * AssemblyId) list // bool: include static initializers only
    | GetAllImages of IReplyChannel<PortableAssembly list>
    | LoadAssemblies of AssemblyId list
    | LoadAssembliesSync of IReplyChannel<unit> * AssemblyId list
//    | Clear

and ProcessDomainManager =
    //Create a process domain
    //nodeManagerOfProcessDomain, processDomainId, isPublic = CreateProcessDomain(newProcessDomainid, preloadAssemblies)
    | CreateProcessDomain of IReplyChannel<ActorRef<NodeManager> * ProcessDomainId * bool> * AssemblyId list
    //Destroy a process domain
    | DestroyProcessDomain of ProcessDomainId
    //Destroy all process domains
    | ClearProcessDomains of IReplyChannel<unit>
    //Allocate process domain for process
    //nodeManagerOfProcessDomain, clusterProxyManager, clusterProxyMap = AllocateProcessDomainForProcess(processId, requiredAssemblies)
    | AllocateProcessDomainForProcess of IReplyChannel<ActorRef<NodeManager> * ActorRef<ClusterProxyManager> option * Nessos.Thespian.Atom<Map<ActivationReference, ReliableActorRef<RawProxy>>> option> * ProcessId * AssemblyId list
//    | AllocateProcessDomainForProcess of IReplyChannel<ReliableActorRef<NodeManager> * ActorRef<ClusterProxyManager> option> * ProcessId * AssemblyId[]
    //Deallocate the process domain for a process
    | DeallocateProcessDomainForProcess of ProcessId
    //Set the process monitor dependency
    //| SetProcessMonitor of ActorRef<Replicated<ProcessMonitor, Data.ProcessMonitorDb>>


//    //Create a dynamic process
//    // CreateDynamicProcess(replyTheDomainActivator, newProcessId, requiredAssemblies)
//    | CreateDynamicProcess of IReplyChannel<ActorRef<ProcessDomainActivator>> * ProcessId * AssemblyId[]
//    | DestroyProcess of ProcessId
//    | GetProcessDomainActivator of IReplyChannel<ActorRef<ProcessDomainActivator>> * ProcessDomainId
//    | GetProcessDomainOfProcess of IReplyChannel<ProcessDomainId> * ProcessId
//    | GetProcessDomainActivatorOfProcess of IReplyChannel<ActorRef<ProcessDomainActivator>> * ProcessId
//    | GetProcessInfo of IReplyChannel<ProcessDomainId * ActorRef<ProcessDomainActivator> * bool> * ProcessId
//    | ListProcessDomains of IReplyChannel<(ProcessDomainId * ActorRef<ProcessDomainActivator>)[]>
//    | DestroyProcessDomain of ProcessDomainId
//    | Clear of IReplyChannel<unit>
    //| Reset of ActorRef<ProcessDomainMonitor>
//    | SetProcessMonitor of ActorRef<Replicated<ProcessMonitor, Data.ProcessMonitorDb>>

    module Configuration =
        let RequiredAssemblies = "RequiredAssemblies"
