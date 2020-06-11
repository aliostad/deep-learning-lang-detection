namespace Nessos.MBrace.Client
    
    open Nessos.Thespian
    
    open Nessos.MBrace
    open Nessos.MBrace.Runtime

    [<SealedAttribute ()>]
    /// The type responsible for the {m}brace runtime booting, management,
    /// process creation, etc.
    type MBraceRuntime =
        class
            interface System.IComparable
            interface System.IDisposable
            private new : runtimeActor:Actor<ClientRuntimeProxy> * isEncapsulatedActor:bool -> MBraceRuntime

            member Attach : nodes:#seq<MBraceNode> -> unit
            member AttachAsync : nodes:#seq<MBraceNode> -> Async<unit>
            member AttachLocal : totalNodes:int *
                                 ?permissions:Runtime.Permissions * 
                                 ?debug:bool *
                                 ?background:bool -> unit

            ///Boots the current runtime.
            member internal Boot : ?replicationFactor:int * ?failoverFactor:int -> unit
            ///Boots the current runtime.
            member internal BootAsync : ?replicationFactor:int * ?failoverFactor:int -> Async<unit>

            ///Boots the current runtime.
            member Boot : unit -> unit
            ///Boots the current runtime.
            member BootAsync : unit -> Async<unit>
            
            ///Clears all processes' information from the runtime.
            member ClearAllProcessInfo : unit -> unit
            
            ///Clears the process's information from the runtime.
            member ClearProcessInfo : pid:Runtime.ProcessId -> unit
            ///Clears the process's information from the runtime.
            member ClearProcessInfo : pid:string -> unit
            
            ///<summary>Creates a new process to run the given cloud computation. This method does not wait for the process to complete.</summary>
            ///<param name="computation">The computation to run.</param>
            member internal CreateProcess : computation:CloudComputation<'T> -> Process<'T>

            ///<summary>Creates a new process to run the given cloud computation. This method does not wait for the process to complete.</summary>
            ///<param name="expr">The computation to run.</param>
            ///<param name="name">Use a custom name for the process.</param>
            member CreateProcess : expr:Quotations.Expr<ICloud<'T>> * ?name:string -> Process<'T>
            
            ///<summary>Deletes a container (folder) from the underlying store.</summary>
            ///<param name="container">The container to delete.</param>
            member DeleteContainer : container:string -> unit
            
            ///<summary>Deletes the container for the process from the underlying store.</summary>
            member DeleteContainer : pid:Runtime.ProcessId -> unit

            ///<summary>Deletes a container (folder) from the underlying store.</summary>
            ///<param name="container">The container to delete.</param>            
            member DeleteContainerAsync : container:string -> Async<unit>

            ///<summary>Deletes the container for the process from the underlying store.</summary>
            member DeleteContainerAsync : pid:Runtime.ProcessId -> Async<unit>
            
            member Detach : node:MBraceNode -> unit
            member Detach : uri:System.Uri -> unit
            member Detach : uri:string -> unit
            member DetachAsync : node:MBraceNode -> Async<unit>
            member DetachAsync : uri:string -> unit

            ///<summary>Get the system logs.</summary>
            ///<param name="clear">Delete the logs.</param>
            member GetLogs : ?clear:bool -> Utils.LogEntry seq

            ///<summary>Get the user logs (created with the log and trace combinators) for 
            ///the specified process.</summary>
            ///<param name="pid">The process's id.</param>
            ///<param name="clear">Delete the logs.</param>
            member GetUserLogs : pid:Runtime.ProcessId * ?clear:bool -> Utils.LogEntry seq
            
            ///Sends and receives a value.
            member Echo : input:'a -> 'a
            
            override Equals : y:obj -> bool
            
            ///Gets all processes.
            member GetAllProcesses : unit -> Process list
            
            override GetHashCode : unit -> int
            
            ///Get the process with the specified id.
            member GetProcess : pid:Runtime.ProcessId -> Process
            ///Get the process with the specified id.
            member GetProcess : pid:Runtime.ProcessId -> Process<'T>

            ///Get the process with the specified id.
            member GetProcess : pid:string -> Process
            ///Get the process with the specified id.
            member GetProcess : pid:string -> Process<'T>
            
            ///Kills violently the nodes and the runtime. 
            ///This method should be used only for local runtimes.
            member Kill : unit -> unit

            ///Kill the process with the specified id.
            member KillProcess : pid:Runtime.ProcessId -> unit
            
            ///<summary>Send a ping message to the runtime and return the number of milliseconds of the roundtrip.</summary>
            ///<param name="silent">Does not print a PING log in the system logs.</param>
            ///<param name="timeout">Timeout in milliseconds.</param>
            member Ping : ?silent:bool * ?timeout:int -> int
            
            member internal PostWithReply : m:(IReplyChannel<'d> -> RuntimeMsg) -> 'd
            member internal PostWithReplyAsync : m:(IReplyChannel<'c> -> RuntimeMsg) -> Async<'c>
            
            ///<summary>Reboots the current runtime.</summary>
            ///<param name = "replicationFactor">The replication factor of the runtime.</param>
            ///<param name = "failoverFactor">The failover factor of the runtime.</param>            
            member internal Reboot : ?replicationFactor:int * ?failoverFactor:int -> unit

            ///<summary>Reboots the current runtime.</summary>       
            member Reboot : unit -> unit

            ///Run the given cloud computation. This method blocks until the process has completed.
            member internal Run : computation:CloudComputation<'T> -> 'T

            ///<summary>Run the given cloud computation. This method blocks until the process has completed.</summary>
            ///<param name="name">Use a custom name for the process.</param>
            member Run : expr:Quotations.Expr<ICloud<'T>> * ?name:string -> 'T
            
            ///Run the given cloud computation. This method blocks until the process has completed.
            member internal RunAsync : computation:CloudComputation<'T> -> Async<'T>
            
            ///<summary>Run the given cloud computation. This method blocks until the process has completed.</summary>
            ///<param name="name">Use a custom name for the process.</param>
            member RunAsync : expr:Quotations.Expr<ICloud<'T>> * ?name:string -> Async<'T>
            
            member internal RunFunc : f:System.Func<'T> -> System.Threading.Tasks.Task<'T>
            
            ///<summary>Prints information about the current runtime (nodes, etc).</summary>
            ///<param name="showPerformanceCounters">Prints performance information (CPU usage, etc)
            ///of all the nodes.</param>
            ///<param name="useBorders">Prints entries in fancy mySQL-like borders.</param>
            member ShowInfo : ?showPerformanceCounters:bool * ?useBorders:bool -> unit
            
            ///<summary>Prints the system logs.</summary>
            ///<param name="clear">Deletes the logs.</param>
            member ShowLogs : ?clear:bool -> unit

            ///<summary>Prints information about processes running in the current runtime.</summary>
            ///<param name="useBorders">Enable fancy mySQL-like bordering.</param>
            member ShowProcessInfo : ?useBorders:bool -> unit
            
            ///<summary>Prints the user logs (logs generated by using log and trace combinators)
            ///of a specific process.</summary>
            ///<param name="pid">The process's id.</param>
            ///<param name="clear">Deletes the user logs for this process.</param>
            member ShowUserLogs : pid:Runtime.ProcessId * ?clear:bool -> unit

            ///Shutdown the current runtime.
            member Shutdown : unit -> unit
            ///Shutdown the current runtime.
            member ShutdownAsync : unit -> Async<unit>
            
            ///Returns if the current runtime is active or not.
            member Active : bool
            
            member internal ActorRef : ActorRef<ClientRuntimeProxy>
            
            ///Gets a list of the alternative master nodes.
            member Alts : MBraceNode list
            
            ///Gets the identifier of the runtime.
            member Id : Runtime.DeploymentId
            
            ///Gets a list of the local MBraceNodes.
            member LocalNodes : MBraceNode list
            
            ///Get master node of the current runtime.
            member Master : MBraceNode option
            
            ///Gets the list of nodes composing the current runtime.
            member Nodes : MBraceNode list
            
            static member internal Boot : conf:Runtime.Configuration -> MBraceRuntime
            
            ///<summary>Boots a {m}brace runtime.</summary>
            ///<param name="nodes">A list of MBraceNodes to use in order to boot the runtime.</param>
            ///<param name = "replicationFactor">The replication factor of the runtime.</param>
            ///<param name = "failoverFactor">The failover factor of the runtime.</param>
            static member internal Boot : nodes:MBraceNode list * ?replicationFactor:int * ?failoverFactor:int -> MBraceRuntime
            
            ///<summary>Boots a {m}brace runtime.</summary>
            ///<param name="nodes">A list of MBraceNodes to use in order to boot the runtime.</param>
            static member Boot : nodes:MBraceNode list -> MBraceRuntime

            ///<summary>Boots a {m}brace runtime.</summary>
            ///<param name="uris">A list of Uris of nodes to use in order to boot the runtime.</param>
            ///<param name = "replicationFactor">The replication factor of the runtime.</param>
            ///<param name = "failoverFactor">The failover factor of the runtime.</param>            
            static member internal Boot : uris:System.Uri list * ?replicationFactor:int * ?failoverFactor:int -> MBraceRuntime

            ///<summary>Boots a {m}brace runtime.</summary>
            ///<param name="uris">A list of Uris of nodes to use in order to boot the runtime.</param>        
            static member Boot : uris:System.Uri list -> MBraceRuntime
            
            ///<summary>Boots a {m}brace runtime.</summary>
            ///<param name="uris">A list of Uris of nodes to use in order to boot the runtime.</param>
            ///<param name = "replicationFactor">The replication factor of the runtime.</param>
            ///<param name = "failoverFactor">The failover factor of the runtime.</param>     
            static member internal Boot : uris:string list * ?replicationFactor:int * ?failoverFactor:int -> MBraceRuntime

            ///<summary>Boots a {m}brace runtime.</summary>
            ///<param name="uris">A list of Uris of nodes to use in order to boot the runtime.</param>   
            static member Boot : uris:string list -> MBraceRuntime
            
            static member internal BootAsync : conf:Runtime.Configuration -> Async<MBraceRuntime>
            
//            ///<summary>Initializes a MBrace.Client. This method should not be called directly 
//            /// when using the {m}brace shell.</summary>
//            static member ClientInit : ?MBracedPath:string *
//                                       ?ILoggerFactory:(unit -> Utils.ILogger) *
//                                       ?IStoreFactory:(unit -> Store.IStore) *
//                                       ?InitSocketListenerPool:bool * 
//                                       ?ClientSideExprCheck:bool *
//                                       ?CompressSerialization:bool * 
//                                       ?DefaultSerializer:string -> unit
            
            ///<summary>Connect to an existing runtime.</summary>
            ///<param name="uri">The Uri of a node that belongs to the runtime.</param>
            static member Connect : uri:System.Uri -> MBraceRuntime

            ///<summary>Connect to an existing runtime.</summary>
            ///<param name="uri">The Uri of a node that belongs to the runtime.</param>
            static member Connect : uri:string -> MBraceRuntime

            ///<summary>Connect to an existing runtime.</summary>
            ///<param name="host">The hostname of a node that belongs to the runtime.</param>
            ///<param name="port">The port of a node that belongs to the runtime.</param>
            static member Connect : host:string * port:int -> MBraceRuntime
            
            ///<summary>Connect to an existing runtime.</summary>
            ///<param name="uri">The Uri of a node that belongs to the runtime.</param>
            static member ConnectAsync : uri:System.Uri -> Async<MBraceRuntime>

            ///<summary>Connect to an existing runtime.</summary>
            ///<param name="uri">The Uri of a node that belongs to the runtime.</param>            
            static member ConnectAsync : uri:string -> Async<MBraceRuntime>

            ///<summary>Creates and boots a local MBraceRuntime using the specified configuration.
            ///Most of these options can also be set from the configuration files.</summary>
            ///<param name = "totalNodes">The number of local nodes to spawn.</param>
            ///<param name = "hostname">The hostname that the nodes will use.</param>
            ///<param name = "replicationFactor">The replication factor of the runtime.</param>
            ///<param name = "failoverFactor">The failover factor of the runtime.</param>
            ///<param name = "storeProvider">The provider that will be used by the underlying store.</param>
            ///<param name = "debug">Run in debug mode.</param>
            ///<param name = "background">Spawn the local nodes in the background.</param>
            static member internal InitLocal : totalNodes:int * ?hostname:string * ?replicationFactor:int * ?storeProvider:StoreProvider
                                      * ?failoverFactor:int * ?debug:bool * ?background:bool -> MBraceRuntime

            ///<summary>Creates and boots a local MBraceRuntime using the specified configuration.
            ///Most of these options can also be set from the configuration files.</summary>
            ///<param name = "totalNodes">The number of local nodes to spawn.</param>
            ///<param name = "hostname">The hostname that the nodes will use.</param>
            ///<param name = "storeProvider">The provider that will be used by the underlying store.</param>
            ///<param name = "debug">Run in debug mode.</param>
            ///<param name = "background">Spawn the local nodes in the background.</param>
            static member InitLocal : totalNodes:int * ?hostname:string * ?storeProvider:StoreProvider * 
                                                                ?debug:bool * ?background:bool -> MBraceRuntime
        end

    /// This is an abbreviation for the MBraceRuntime type.
    type MBrace = MBraceRuntime


namespace Nessos.MBrace.Runtime

    open Nessos.Thespian

    open Nessos.MBrace.Utils
    open Nessos.MBrace.Client

    [<AutoOpen>]
    module RuntimeExtensions =
        type MBraceRuntime with
            static member FromActor : actor:Actor<RuntimeMsg> -> MBraceRuntime