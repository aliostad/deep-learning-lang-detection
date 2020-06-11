// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.SyncLib

open System.Threading.Tasks

/// A simple info object to contain all the settings for a specific backend. Extensible over the IDictionary
type ManagedFolderInfo = {
    /// The name or key shown in the gui for the folder, has to be unique (possibly used by the backend)
    Name : string
    /// The full path of the folder (used by the backend)
    FullPath : string
    /// The remote string for the folder (used by the backend)
    Remote : string
    /// Additional settings to be extensible (other backends could have other configurations requirements)
    /// The following are supported natively: "PubsubUrl" "PubsubChannel"
    Additional : Map<string,string>
}  

/// The Type of Conflict that occured while syncing
type SyncConflict = 
    /// Indicates a conflict in the merge process of the given file
    | MergeConflict of string
    /// Indicates that a file is locked
    | FileLocked of string
    /// Another unknown conflict
    | Unknown of string

/// The type of a Sync
type SyncType =
    /// Sync up to the server
    | SyncUp
    /// Sync down from the server
    | SyncDown
with
    /// Revert the sync direction
    static member Revert s = 
        match s with 
        | SyncUp -> SyncDown
        | SyncDown -> SyncUp
        
/// The state of the syncing process
type SyncState = 
    /// The folder is idle and waiting for changes
    | Idle
    /// The folder is starting to processing
    | SyncStart of SyncType
    /// The folder finished processing (only triggered on success)
    | SyncComplete of SyncType
    /// The server for the folder is offline
    | Offline
    /// The folder finished processing with an error
    | SyncError of SyncType * exn

/// Represents a folder which is able to sync
type ISyncFolderFolder = 
    /// Starts syncing of the current folder
    abstract member RequestSync : SyncType->unit
    
    /// Starts the attached provider services
    abstract member StartService : unit -> unit

    /// Stops the attached provider services
    abstract member StopService : unit -> unit    

    /// Indicates the start of a sync
    [<CLIEvent>]
    abstract member SyncStateChanged : IEvent<SyncState>
            
    /// Indicates a conflict while syncing (will be resolved automatically, just notify)
    [<CLIEvent>]
    abstract member SyncConflict : IEvent<SyncConflict>
       
    /// Indicates a progress - change in the sync process
    [<CLIEvent>]
    abstract member ProgressChanged : IEvent<double>

[<AutoOpen>]
module SyncFolderExtensions = 
    type ISyncFolderFolder with
        member x.Error = 
            x.SyncStateChanged
            |> Event.filter (fun t -> match t with SyncState.SyncError(_) -> true | _ -> false)
            |> Event.map (fun t -> match t with SyncState.SyncError(state, e) -> state, e | _ -> failwith "invalid event")
        

/// A simple type to create the Mangers (this can be dynamically loaded in the future for example)
type IBackendManager = 
    /// Inits a FolderSync instance for the given folder
    abstract member CreateFolderManager : ManagedFolderInfo -> ISyncFolderFolder

/// Support for Notification providers (filesystem, pubsub, ...)
type INotifyProvider = 
    /// Trigger when the provider signals a change
    [<CLIEvent>]
    abstract member Notification : IEvent<unit>

    /// Will be called when we want to signal a change to the provider
    abstract member Notify : unit -> unit

/// A managed folder with integrated notification-providers
type IManagedFolder = 
    /// The core folder for the sync services
    abstract member Folder : ISyncFolderFolder with get
    /// Starts the attached provider services
    abstract member StartService : unit -> unit
    /// Stops the attached provider services
    abstract member StopService : unit -> unit    
    /// Has to be called before using the service 
    /// (has side effects, so should be only called when using this manager)
    abstract member Init : unit -> unit    

/// Module for managing providers and IManagedFolder instances
module Sync = 
    /// Start managing a folder
    let toManaged syncFolder = 
        let init = ref false
        { new IManagedFolder with   
            member x.Folder with get() = syncFolder
            member x.StartService () = 
                if !init |> not then invalidOp "Not initialized"
                syncFolder.StartService()
                syncFolder.RequestSync(SyncDown)
                syncFolder.RequestSync(SyncUp)
            member x.StopService () = 
                if !init |> not then invalidOp "Not initialized"
                syncFolder.StopService()
                ()
            member x.Init() = init := true }
    /// Helper method for adding events easily
    let withStartFlag init (managedFolder:IManagedFolder) =
        let isStarted = ref false
        { new IManagedFolder with
            member x.Folder with get() = managedFolder.Folder
            member x.StartService() = 
                isStarted := true
                managedFolder.StartService()
            member x.StopService () = 
                managedFolder.StopService()
                isStarted := false
            member x.Init () = 
                init(isStarted)
                managedFolder.Init() }
    /// Add the given provider to the given managedFolder (SyncDown for a Local Provider)
    let addNotifier syncT (notifier:INotifyProvider) (managedFolder:IManagedFolder) = 
        managedFolder
            |> withStartFlag
                (fun isStarted -> 
                    notifier.Notification
                        |> Event.filter (fun s -> !isStarted)
                        |> Event.add (fun s -> managedFolder.Folder.RequestSync(SyncType.Revert syncT))
                    managedFolder.Folder.SyncStateChanged
                        |> Event.filter (fun s -> !isStarted)
                        |> Event.filter (fun t -> t = SyncComplete(syncT))
                        |> Event.add (fun t -> notifier.Notify ()))
                        
    /// Adds a local notifier
    let addLocalNotifier n m = addNotifier SyncDown n m
    /// Adds a remote notifier
    let addRemoteNotifier n m = addNotifier SyncUp n m

/// Simple module to manage Providers
module Notify =
    /// Create a provider from an event
    let fromEvent ev = 
        { new INotifyProvider with
            [<CLIEvent>]
            member x.Notification = ev |> Event.map (fun s -> ())
            member x.Notify () = () }
    /// create a provider with the given unique id from the events
    let fromRemoteEvents uniqueId (pushedEvent:Event<string>, notification) = 
        { new INotifyProvider with
            [<CLIEvent>]
            member x.Notification = 
                notification
                    |> Event.filter (fun s -> s <> uniqueId)
                    |> Event.map (fun s -> ())
            member x.Notify () = pushedEvent.Trigger uniqueId }
    /// merges two providers
    let mergeProvider (prov1:INotifyProvider) (prov2:INotifyProvider) = 
        { new INotifyProvider with  
            [<CLIEvent>]
            member x.Notification = 
                Event.merge prov1.Notification prov2.Notification
            member x.Notify () =
                prov1.Notify()
                prov2.Notify() }
    /// Gets a local watcher
    let localWatcher path =
        let t = new SimpleLocalChangeWatcher(path)
        t.Start()
        t.Changed

    /// Gets remote events for the given pubsub connection
    let pubsubWatcher uri channel = 
        RemoteConnectionManager.remoteDataToEvent (RemoteConnectionType.Pubsub(uri, channel))

/// A simple wrapper around the interface which keeps track over the state
type ManagedFolderWrapper(impl:IManagedFolder) = 
    let implementation = impl
    let mutable state = SyncState.Idle
    let mutable progress = 0.0
    do 
        impl.Folder.SyncStateChanged
            |> Event.add 
                (fun newstate -> 
                    progress <- 0.0
                    state <- newstate)

        impl.Folder.ProgressChanged
            |> Event.add (fun newProgress -> progress <- newProgress)

    /// The implementation to add events or start/stop the service
    member x.Implementation with get() = implementation
    /// The current state of the implementation
    member x.State with get() = state
    /// The current progress of the current operation (0 when no operation is running)
    member x.Progress 
        with get() = 
            if (match state with | SyncState.SyncStart(_) -> true | _ -> false) 
            then progress
            else 0.0

