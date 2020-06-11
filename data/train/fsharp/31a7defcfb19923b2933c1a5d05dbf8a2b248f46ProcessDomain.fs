namespace Nessos.MBrace.Runtime

    module internal ProcessDomain =
        
        open System
        open System.Diagnostics

        open Nessos.FsPickler
        open Nessos.UnionArgParser

        open Nessos.Thespian
        open Nessos.Thespian.Serialization
        open Nessos.Thespian.PowerPack
        open Nessos.Thespian.Remote.ConnectionPool
        open Nessos.Thespian.Remote.TcpProtocol

        open Nessos.MBrace
        open Nessos.MBrace.Core
        open Nessos.MBrace.Utils
        open Nessos.MBrace.Utils.AssemblyCache
        open Nessos.MBrace.Runtime
        open Nessos.MBrace.Runtime.Store
        open Nessos.MBrace.Runtime.Definitions
        open Nessos.MBrace.Runtime.ProcessDomain.Configuration 
        open Nessos.MBrace.Client

        let selfProc = Process.GetCurrentProcess()

        // if anyone can suggest a less hacky way, be my guest..
        // a process spawned from command line is UserInteractive but has null window handle
        // a process spawned in an autonomous window is UserInteractive and has a non-trivial window handle
        let isWindowed = Environment.UserInteractive && selfProc.MainWindowHandle <> 0n

        let rec mainLoop (parent: System.Diagnostics.Process) =
            let rec loop () =
                async {
                    if (try parent.HasExited with _ -> true) then return 1
                    else
                        do! Async.Sleep 4000
                        return! loop ()
                }

            Async.RunSynchronously (loop ())
        
        //TODO!! check the parent logger actor name
        let getParentLogger serializername (parentAddress: Address) =

            let uri = sprintf' "utcp://%s/*/common.loggerActor.0/%s" (parentAddress.ToString()) serializername

            ActorRef.fromUri uri

        [<EntryPoint>]
        let main args =
            //
            //  parse configuration
            //

//            let results = 
#if APPDOMAIN_ISOLATION
            let exiter = new ExceptionExiter(fun msg -> failwith (defaultArg msg "processdomain error")) :> IExiter
            let results = workerConfig.ParseCommandLine(inputs = args)
#else
            let exiter = new ConsoleProcessExiter(true) :> IExiter
            let results = workerConfig.ParseCommandLine(errorHandler = plugExiter exiter)
#endif

            let parentPid = results.GetResult <@ Parent_Pid @>
            let debugMode = results.Contains <@ Debug @>
            let processDomainId = results.GetResult <@ Process_Domain_Id @>
            let assemblyPath = results.GetResult <@ Assembly_Cache @>
            let hostname = results.GetResult (<@ HostName @>, defaultValue = "localhost")
            let port = results.GetResult (<@ Port @>, defaultValue = -1)
            let parentAddress = results.PostProcessResult (<@ Parent_Address @>, Address.Parse)
            let storeEndpoint = results.GetResult <@ Store_EndPoint @>
            let storeProvider = results.GetResult <@ Store_Provider @>
            let cacheStoreEndpoint = results.GetResult <@ Cache_Store_Endpoint @>
           
            do Assembly.RegisterAssemblyResolutionHandler()

            //
            // Register Things
            //

            AssemblyCache.SetCacheDir assemblyPath

            // Register Serialization
            do Nessos.MBrace.Runtime.Serializer.Register(new FsPickler())

            // Register Store
            try
                // has been filled out to fix build; kostas, change this
                //raise <| new NotImplementedException("worker node configuration setup.")
                let storeProvider = StoreProvider.Parse(storeProvider, storeEndpoint)
                let storeInfo = StoreRegistry.Activate(storeProvider, makeDefault = true)
                
                let coreConfig = CoreConfiguration.Create(IoC.Resolve<ILogger>(), Serializer.Pickler, storeInfo.Store, cacheStoreEndpoint)
                // soon...
                IoC.Register<CoreConfiguration>(fun () -> coreConfig)
                IoC.RegisterValue<IStore>(storeInfo.Store)
                IoC.RegisterValue<StoreInfo>(storeInfo)
                //IoC.Register<ICloudRefStore>(fun () -> coreConfig.CloudRefStore) 
                //IoC.Register<IMutableCloudRefStore>(fun () -> coreConfig.MutableCloudRefStore) 
                //IoC.Register<ICloudSeqProvider>(fun () -> coreConfig.CloudSeqStore) 
                //IoC.Register<ICloudFileStore>(fun () -> coreConfig.CloudFileStore) 
                //IoC.Register<StoreLogger>(fun () -> coreConfig.LogStore :?> StoreLogger)

            with e -> results.Raise (sprintf "Error connecting to store: %s" e.Message, 2)

            // Register listeners
            TcpListenerPool.DefaultHostname <- hostname
            if port = -1 then TcpListenerPool.RegisterListener(IPEndPoint.any)
            else TcpListenerPool.RegisterListener(IPEndPoint.anyIp port)
            TcpConnectionPool.Init()

            //Debug.Listeners.Add(new TextWriterTraceListener("mbrace-process-log.txt")) |> ignore

            // Register Logger
            IoC.Register<ILogger>(
                fun () ->
                    (fun () -> getParentLogger Serialization.SerializerRegistry.DefaultName parentAddress)
                    |> Logger.lazyWrap
                    // prepend "ProcessDomain" prefix to all log entries
                    |> Logger.convert
                        (function SystemLog (txt, lvl, date) -> 
                                    SystemLog (sprintf' "ProcessDomain(%A):: %s" processDomainId txt, lvl, date))
            )

            // Register exiter
            IoC.RegisterValue<IExiter>(exiter)

            // Begin Boot

            let logger = IoC.Resolve<ILogger>()

            logger.LogInfo <| sprintf' "ALLOCATED PORT: %d" port

            logger.LogInfo <| sprintf' "PROC ID: %d" (Process.GetCurrentProcess().Id)

            let unloadF () = 
#if APPDOMAIN_ISOLATION
                AppDomain.Unload(AppDomain.CurrentDomain)
#else
                Process.GetCurrentProcess().Kill()
#endif

            try
                let nodeManagerReceiver = ActorRef.fromUri <| sprintf' "utcp://%s/*/activatorReceiver/%s" (parentAddress.ToString()) "FsPickler"
                logger.LogInfo <| sprintf' "PARENT ADDRESS: %O" parentAddress

                let d : IDisposable option ref = ref None

                d := Nessos.Thespian.Cluster.Common.Cluster.OnNodeManagerSet
                     |> Observable.subscribe (Option.iter (fun nodeManager ->
                            try 
                                nodeManagerReceiver <!= fun ch -> ch, nodeManager
                                d.Value.Value.Dispose()
                            with e -> logger.LogError e "PROCESS DOMAIN INIT FAULT"))
                     |> Some

                let address = new Address(TcpListenerPool.DefaultHostname, TcpListenerPool.GetListener().LocalEndPoint.Port)
                Definitions.Service.bootProcessDomain address
                mainLoop <| System.Diagnostics.Process.GetProcessById(parentPid)
            with e ->
                logger.LogError e "Failed to start process domain."
                1
