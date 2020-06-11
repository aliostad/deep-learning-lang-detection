namespace Nessos.MBrace.Runtime

    open System

    open Microsoft.FSharp.Quotations

    open Nessos.Thespian
    open Nessos.Vagrant
        
    open Nessos.MBrace
    open Nessos.MBrace.Utils
    open Nessos.MBrace.Runtime.Store

    type ProcessId = Nessos.MBrace.ProcessId
    type RequestId = System.Guid
    type DeploymentId = System.Guid
    type PackageId = System.Guid


    type CloudPackage private (expr : Expr, t : Type) =
        member __.Expr = expr
        member __.ReturnType = t
        member __.Eval () = Swensen.Unquote.Operators.evalRaw expr : ICloud
        static member Create (expr : Expr<ICloud<'T>>) =
            CloudPackage(expr, typeof<'T>)

    type ProcessImage = 
        {
            Name : string
            Computation : byte [] // serialized QuotationPackage
            Type : byte []  // serialized System.Type
            TypeName : string
            ClientId : Guid
            Dependencies : AssemblyId list
        }

    type ExecuteResult = Result<obj>

    exception SchedulerDeserializationException of exn

    type ExecuteResultImage = 
        | ProcessInitError of exn // compiler / serialization exceptions etc.
        | ProcessFault of exn // system fault
        | ProcessSuccess of byte [] // completed cloud process value / exception
        | ProcessKilled // process is killed
            

    type NodeType = 
        | Master | Alt | Slave | Idle
    with
        override t.ToString() =
            match t with
            | Master -> "Master"
            | Alt -> "Alt Master"
            | Slave -> "Slave"
            | Idle -> "Idle"
                
    type Permissions =
        | None   = 0b000
        | Slave  = 0b001
        | Master = 0b010
        | Other  = 0b100 // dummy
        | All    = 0b111

    type ProcessRecoveryType = RecoveringScheduler | RecoveringWorker | RecoveringLogger //TODO!!! Perhaps make this an enum?
    type ProcessState = Initialized | Created | Running | Recovering of ProcessRecoveryType | Completed | Failed | Killed
    with
        override s.ToString() =
            match s with
            | Initialized -> "Initialized"
            | Created -> "Created"
            | Running -> "Running"
            | Recovering _ -> "Recovering"
            | Completed -> "Completed"
            | Failed -> "Failed"
            | Killed -> "Killed"

    // ProcessInfo type with serialized entries
    // to compensate for isolation
    type ProcessInfo =
        {
            Name : string
            ProcessId : ProcessId
            Type : byte []
            InitTime : DateTime
            ExecutionTime : TimeSpan
            TypeName : string
            Workers : int
            Tasks : int
            Result : ExecuteResultImage option
            ProcessState: ProcessState
            Dependencies : AssemblyId list
            ClientId : Guid
        }

    type PerformanceCounterValue =
        | Single of single
        | Pair   of single * single
        | NotAvailable

    with 
        override this.ToString () = 
            match this with 
            | Single v -> sprintf "%.2f" v 
            | Pair (a,b) -> sprintf "%.2f / %.2f" a b
            | NotAvailable -> "N/A"

    /// Some node metrics, such as CPU, memory usage, etc
    type NodePerformanceInfo =
        {
            TotalCpuUsage : PerformanceCounterValue
            TotalCpuUsageAverage : PerformanceCounterValue
            TotalMemory : PerformanceCounterValue
            TotalMemoryUsage : PerformanceCounterValue
            TotalNetworkUsage : PerformanceCounterValue
        }


    type ProcessManager =
        //Throws
        //MBrace.Exception => Failed to activate process
        //MBrace.SystemCorruptedException => system corruption while trying to activate process ;; SYSTEM FAULT
        //MBrace.SystemFailedException => SYSTEM FAULT
        | CreateDynamicProcess of IReplyChannel<ProcessInfo> * Guid * ProcessImage
        | GetAssemblyLoadInfo of IReplyChannel<AssemblyLoadInfo list> * Guid * AssemblyId list
        | LoadAssemblies of IReplyChannel<AssemblyLoadInfo list> * Guid * PortableAssembly list

//            | GetProcessResult of IReplyChannel<ExecuteResultImage> * ProcessId // marked for deprecation : client no longer sends messages of this type
//            | TryGetProcessResult of IReplyChannel<ExecuteResultImage option> * ProcessId // ditto
        | GetProcessInfo of IReplyChannel<ProcessInfo> * ProcessId
        | GetAllProcessInfo of IReplyChannel<ProcessInfo []>
        | ClearProcessInfo of IReplyChannel<unit> * ProcessId // Clears process from logs if no longer running
        | ClearAllProcessInfo of IReplyChannel<unit> // Clears all inactive processes
        | RequestDependencies of IReplyChannel<PortableAssembly list> * AssemblyId list // Assembly download API
        | KillProcess of IReplyChannel<unit> * ProcessId


//        and ProcessCreationResponse = Process of ProcessInfo | MissingAssemblies of AssemblyLoadResponse []

    type Runtime = 
        //MasterBoot(replyChannel, endPointsOfSlaveNodes, numOfAltMasterNodes)
        //Boots the runtime. The node receiving this message becomes the Master Node
        //and assumes the Scheduler Role.
        | MasterBoot of IReplyChannel<NodeRef * NodeRef []> * Configuration // reply master * alts
        //Get an actorRef for the process manager.
        | GetProcessManager of IReplyChannel<ActorRef<ProcessManager>>
        //Get list of runtime nodes (master node followed by alts).
        | GetMasterAndAlts of IReplyChannel<NodeRef * NodeRef []>
        //Get runtime deployment id
        | GetDeploymentId of IReplyChannel<DeploymentId>
        //Gets *all* nodes attached to runtime
        | GetAllNodes of IReplyChannel<NodeRef []>
        //Gets default store id: this is a temporary sanity check until the store propagation mechanism is put in place
        | GetStoreId of IReplyChannel<StoreId>
        //Gets a Dump of all logs kept in node, boolean specifies if logs should be cleared from memory
        | GetLogDump of IReplyChannel<LogEntry []> * bool
        //Attach(confirmationChannel, someRuntime)
        //Tell a node to attach itself to the runtime.
        | Attach of IReplyChannel<unit> * NodeRef
        //Tell a node to detach itself from the runtime it is attached to.
        | Detach of IReplyChannel<unit>
        //set node permissions
        | SetNodePermissions of Permissions
        //a Machine that goes Ping!
        | Ping of IReplyChannel<unit> * (*log silence*) bool
        // returns runtime-independent information
        | GetNodeDeploymentInfo of IReplyChannel<NodeDeploymentInfo>
        //Request for performance counters
        | GetNodePerformanceCounters of IReplyChannel<NodePerformanceInfo> 
        //Clears all runtime state.
        | Shutdown
        | ShutdownSync of IReplyChannel<unit>
        //For internal communication, not for client use
        | GetInternals of IReplyChannel<ActorRef>

    and NodeRef = ActorRef<Runtime>

    and Configuration(nodes : NodeRef [], replicationFactor : int, failoverFactor : int) =
        member __.Nodes = nodes
        member __.ReplicationFactor = replicationFactor
        member __.FailoverFactor = failoverFactor
        static member Null = Configuration(Array.empty, 0, 0)

    and NodeDeploymentInfo =
        {
            HostId : HostId
            // a unique Guid that identifies this process instance
            DeploymentId : Guid
            Pid : int
            Permissions : Permissions
            State : NodeType
        }

    /// a wrapper type to the runtime protocol for use by the client lib
    and ClientRuntimeProxy =
        | RemoteMsg of Runtime
        | GetLastRecordedState of IReplyChannel<NodeRef list>


namespace Nessos.MBrace.Client

    type StoreId = Nessos.MBrace.Runtime.Store.StoreId