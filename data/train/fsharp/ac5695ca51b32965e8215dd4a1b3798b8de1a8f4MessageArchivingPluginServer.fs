// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.Xmpp.MessageArchiving.Server

open Yaaf.Helper

open Yaaf.Xmpp
open Yaaf.Xmpp.Runtime
open Yaaf.Xmpp.Server
open Yaaf.Xmpp.XmlStanzas
open Yaaf.Xmpp.IM

open Yaaf.Logging
open Yaaf.Xmpp.ServiceDiscovery
open Yaaf.Xmpp.MessageArchiving

type IMessageArchivingServerPluginConfig =
    abstract MessageArchiveStore : IMessageArchivingStore with get
    abstract AutoSaveEnabled : bool with get
    abstract AllowAutoSaveChange : bool with get
    abstract CollectionTimeout : System.TimeSpan with get
    abstract DefaultOtrMode : OtrSaveMode
    abstract DefaultMethodUses : AllMethodSettings
type MessageArchivingServerPluginConfig =
    {
        MessageArchiveStore : IMessageArchivingStore
        AutoSaveEnabled : bool
        AllowAutoSaveChange : bool
        CollectionTimeout : System.TimeSpan
        DefaultOtrMode : OtrSaveMode
        DefaultMethodUses : AllMethodSettings
    } with 
    interface IMessageArchivingServerPluginConfig with
        member x.MessageArchiveStore  = x.MessageArchiveStore
        member x.AutoSaveEnabled      = x.AutoSaveEnabled
        member x.AllowAutoSaveChange = x.AllowAutoSaveChange
        member x.CollectionTimeout    = x.CollectionTimeout
        member x.DefaultOtrMode       = x.DefaultOtrMode
        member x.DefaultMethodUses    = x.DefaultMethodUses
    static member OfInterface (x:IMessageArchivingServerPluginConfig) =
        {
            MessageArchiveStore  = x.MessageArchiveStore 
            AutoSaveEnabled      = x.AutoSaveEnabled     
            AllowAutoSaveChange = x.AllowAutoSaveChange
            CollectionTimeout    = x.CollectionTimeout
            DefaultOtrMode       = x.DefaultOtrMode
            DefaultMethodUses    = x.DefaultMethodUses
        }
    static member Default =
        {
            MessageArchiveStore  = Unchecked.defaultof<_>
            AutoSaveEnabled      = true
            AllowAutoSaveChange = true
            CollectionTimeout    = System.TimeSpan.FromHours 1.0
            DefaultOtrMode       = 
                { Expire = None
                  OtrMode = Some OtrMode.Concede
                  SaveMode = Some SaveMode.Body }
            DefaultMethodUses    = 
                { Auto = UseType.Prefer
                  Local = UseType.Concede
                  Manual = UseType.Concede }
        }

type OpenCollectionInfo = (System.DateTime * bool * ChatCollection) option
type IMessageArchivingPerUserService =
    abstract OpenCollection : JabberId -> OpenCollectionInfo with get, set
    abstract OpenCollectionLock : JabberId -> AsyncLock
type MessageArchivingPerUserService () =
    let openCols = new System.Collections.Concurrent.ConcurrentDictionary<_,_>()
    let locks = new System.Collections.Concurrent.ConcurrentDictionary<_,_>()
    interface IMessageArchivingPerUserService with
        member x.OpenCollection 
            with get jid =
                openCols.GetOrAdd(jid.BareId, None)
            and set jid v = 
                openCols.AddOrUpdate(jid.BareId, v, (fun _ _ -> v)) |> ignore
        member x.OpenCollectionLock jid =
            locks.GetOrAdd(jid.BareId, new AsyncLock())

type MessageArchivingServerPlugin 
    (config : IMessageArchivingServerPluginConfig, serverApi : IServerApi, neg : INegotiationService,
     stanzas : IXmlStanzaService, runtimeConfig : IRuntimeConfig, perUser : IPerUserService, mgr : IXmppPluginManager,
     disco : IDiscoService, imService : IImService, addressing : IAddressingService, registrar : IPluginManagerRegistrar) =

    let store = config.MessageArchiveStore
    let mutable autoSaveEnabled = config.AutoSaveEnabled
    do
        perUser.RegisterService<IMessageArchivingPerUserService, MessageArchivingPerUserService>()

        // check if we need a store
        //if (not config.IsClientStream) then
        //    Configuration.configFail "MessageArchivingPlugin makes no sense on s2s streams"
        match runtimeConfig.StreamType with
        | ClientStream ->
            if (not runtimeConfig.IsInitializing) then
                if (*not <| mgr.HasPluginOf<MessagePlugin>() &&*) not <| mgr.HasPluginOf<Server.IMServerPlugin>() then
                    Configuration.configFail "MessageArchivingServerPlugin requires an MessagePlugin or IMServerPlugin!"
        | _ -> ()
            
        if not runtimeConfig.IsServerSide then
            Configuration.configFail "MessageArchivingServerPlugin has to be on a server!"
        // required to store incomming messages
        if obj.ReferenceEquals(null, store) then
            Configuration.configFail "MessageArchivingServerPlugin requires an MessageArchiveStore in the configuration!"

        if runtimeConfig.StreamType.OnClientStream then
            if (not runtimeConfig.IsInitializing) then
                // only announce features when c2s and we are the server
                disco.RegisterFeatureItem(None, {Var = "urn:xmpp:archive"})
                disco.RegisterFeatureItem(None, {Var = "urn:xmpp:archive:auto"})
                disco.RegisterFeatureItem(None, {Var = "urn:xmpp:archive:manage"})
                disco.RegisterFeatureItem(None, {Var = "urn:xmpp:archive:manual"})
                disco.RegisterFeatureItem(None, {Var = "urn:xmpp:archive:pref"})

    let serverDefaults = 
        { AutomaticArchiving = config.AutoSaveEnabled
          // Must be Global at the beginning or logic in createFromGlobalStore will fail
          AutomaticArchivingScope = Some ArchivingScope.Global
          DefaultModesUnset = Some true
          DefaultOtrSaveMode = config.DefaultOtrMode
          ItemSetting = []
          SessionSetting = []
          MethodSetting = config.DefaultMethodUses }

    let createFromGlobalStore (defaults:PreferenceInfo) globalStore =
        match globalStore with
        | Some s -> 
            {   
                AutomaticArchiving = 
                    if defaults.AutomaticArchivingScope.IsNone || defaults.AutomaticArchivingScope.Value = ArchivingScope.Stream then
                        defaults.AutomaticArchiving
                    else
                        match s.AutomaticArchiving with
                        | Some aa -> aa
                        | None -> defaults.AutomaticArchiving
                AutomaticArchivingScope = 
                    if defaults.AutomaticArchivingScope.IsNone || defaults.AutomaticArchivingScope.Value = ArchivingScope.Stream then
                        defaults.AutomaticArchivingScope
                    else
                        Some ArchivingScope.Global
                DefaultModesUnset = 
                    let d = s.DefaultOtrSaveMode
                    if d.Expire.IsNone && d.OtrMode.IsNone && d.SaveMode.IsNone then Some true else None
                DefaultOtrSaveMode = 
                    let d = s.DefaultOtrSaveMode
                    let def = defaults.DefaultOtrSaveMode
                    { 
                        Expire =
                            match d.Expire with
                            | Some ex -> Some ex
                            | None -> def.Expire
                        OtrMode =
                            match d.OtrMode with
                            | Some otr -> Some otr
                            | None -> def.OtrMode
                        SaveMode =
                            match d.SaveMode with
                            | Some save -> Some save
                            | None -> def.SaveMode }
                ItemSetting = s.ItemSetting
                SessionSetting = defaults.SessionSetting
                MethodSetting = 
                    match s.MethodSetting with
                    | Some metds -> metds
                    | None -> defaults.MethodSetting }
        | None -> defaults
    let mutable streamCurrentPreferences = None
    let getCurrentPreferences storedPreferences =
        let curData =
            match streamCurrentPreferences with
            | Some s -> s
            | None -> serverDefaults
        let newPrefs = createFromGlobalStore curData storedPreferences
        streamCurrentPreferences <- Some newPrefs
        newPrefs
    let handlePreferences (msgStanza:Stanza<PreferenceAction>) = 
        async {
        let user = neg.RemoteJid
        let pushBack () = 
            async {
            do! serverApi.OnAllSimple user
                    (fun innerClient ->
                        async {
                            let stanzaService = innerClient.GetService<IXmlStanzaService>()
                            let stanza = 
                                Parsing.createPreferenceElement 
                                    (stanzaService.GenerateNextId()) 
                                    (Some innerClient.RemoteJid)
                                    msgStanza.Data
                            stanzaService.QueueStanzaGeneric None stanza
                        })
            } |> Log.TraceMe
        // get preferences from store
        let! userPrefStore = store.GetPreferenceStore user |> Task.await
        let! storedPreferences = userPrefStore.GetUserPreferences() |> Task.await
        let currentPreferences = getCurrentPreferences storedPreferences
        let newPreferences = 
            match storedPreferences with
            | Some s -> s
            | None -> StoredPreferenceInfo.Default
        match msgStanza.Data with
        | PreferenceAction.RequestPreferences ->
            // send result back
            let stanza = 
                Parsing.createPreferenceElement 
                    (msgStanza.Header.Id.Value) 
                    (Some user) 
                    (PreferenceAction.PreferenceResult currentPreferences)
            stanzas.QueueStanzaGeneric None stanza
        | PreferenceAction.SetDefault newDef ->
            // save new preferences
            streamCurrentPreferences <- Some { currentPreferences with DefaultOtrSaveMode = newDef}
            //let newPref = { newPreferences with DefaultOtrSaveMode = newDef }
            do! userPrefStore.SetDefaultOtrSaveMode (Some newDef) |> Task.awaitPlain

            // send ack
            stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)

            // push result back to all resources
            do! pushBack()
        | PreferenceAction.SetItem (newJid,newSetting) ->
            let newItems = 
                if currentPreferences.ItemSetting |> Seq.exists (fun (jid,ortSaveMode) -> jid.FullId = newJid.FullId) then
                    currentPreferences.ItemSetting
                    |> List.map (fun (oldJid, oldSetting) -> if oldJid.FullId = newJid.FullId then (newJid, newSetting) else (oldJid, oldSetting))
                else
                    (newJid,newSetting) :: currentPreferences.ItemSetting
            streamCurrentPreferences <- Some { currentPreferences with ItemSetting = newItems}
            //let newPref = { newPreferences with ItemSetting = newItems }
            do! userPrefStore.SetItem (newJid,newSetting) |> Task.awaitPlain

            // send ack
            stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)

            // push result back to all resources
            do! pushBack()
        | PreferenceAction.SetMethods methds -> 
            // save new preferences
            streamCurrentPreferences <- Some { currentPreferences with MethodSetting = methds }
            //let newPref = { newPreferences with MethodSetting = Some methds }
            do! userPrefStore.SetMethodPreferences (Some methds) |> Task.awaitPlain

            // send ack
            stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)

            // push result back to all resources
            do! pushBack()
        | PreferenceAction.SetSession (newThread,newSetting) ->
            // Note: Sessions are per stream.
            let newSessions = 
                if currentPreferences.SessionSetting |> Seq.exists (fun (thread,ortSaveMode) -> thread = newThread) then
                    currentPreferences.SessionSetting
                    |> List.map (fun (thread, oldSetting) -> thread, if thread = newThread then newSetting else oldSetting)
                else
                    (newThread,newSetting) :: currentPreferences.SessionSetting
            streamCurrentPreferences <- Some { currentPreferences with  SessionSetting = newSessions }
            
            // send ack
            stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)

            // push result back to all resources
            do! pushBack()
        | PreferenceAction.RemoveSession (newThread) ->
            // Note: Sessions are per stream.
            let newSessions = 
                currentPreferences.SessionSetting 
                |> List.filter (fun (thread,ortSaveMode) -> thread <> newThread) 
            streamCurrentPreferences <- Some { currentPreferences with  SessionSetting = newSessions }
            
            // send ack
            stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)

            // push result back to all resources
            do! pushBack()
        | PreferenceAction.RemoveItem (newJid) ->
            let newItems = 
                currentPreferences.ItemSetting 
                |> List.filter (fun (jid,ortSaveMode) -> jid.FullId <> newJid.FullId) 
            streamCurrentPreferences <- Some  { currentPreferences with ItemSetting = newItems }
            //let newPref = { newPreferences with ItemSetting = newItems }
            do! userPrefStore.RemoveItem newJid |> Task.awaitPlain

            // send ack
            stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)

            // push result back to all resources
            do! pushBack()
        | PreferenceAction.PreferenceResult _ ->
            failwith "don't expect PreferenceResult on this level!"
        } |> Log.TraceMe

    let handleManualArchiving (msgStanza:Stanza<ManualArchivingAction>) = 
        async {
        let user = neg.RemoteJid
        match msgStanza.Data with
        | ManualArchivingAction.Save col ->
            let! userPrefStore = store.GetArchiveStore user.BareJid |> Task.await
            do! userPrefStore.StoreCollection col |> Task.awaitPlain
        | ManualArchivingAction.SaveResult res ->
            failwith "don't expect SaveResult on this level!"
        } |> Log.TraceMe


    let handleAutomaticArchiving (msgStanza:Stanza<AutomaticArchivingAction>) = 
        async {
        let user = neg.RemoteJid
        match msgStanza.Data with
        | AutomaticArchivingAction.SetAutomaticArchiving (value, scope) ->
            if config.AllowAutoSaveChange then
                let! prefStore = (store.GetPreferenceStore user.BareJid) |> Task.await
                let! storedPrefs = prefStore.GetUserPreferences() |> Task.await
                let currentPreferences = getCurrentPreferences storedPrefs
                streamCurrentPreferences <- Some  { currentPreferences with AutomaticArchiving = value; AutomaticArchivingScope = scope }
                if (scope.IsSome && scope.Value = ArchivingScope.Global) then
                    // Save in settings
                    let storedPrefs =
                        match storedPrefs with
                        | Some s -> s
                        | None -> StoredPreferenceInfo.Default
                    //let newPref = { storedPrefs with AutomaticArchiving = Some value }
                    do! prefStore.SetArchiving (Some value) |> Task.awaitPlain

                autoSaveEnabled <- value
                // send ack
                stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)
            else
                if value = config.AutoSaveEnabled then
                    // not changed, so we are good to go
                    stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)
                else
                    // errors, see: 6. Automatic Archiving
                    let rawStanza = msgStanza.SimpleStanza
                    let cond = 
                        if (value) then
                            StanzaErrorConditon.FeatureNotImplemented
                        else
                            StanzaErrorConditon.NotAllowed
                    let error = StanzaException.createSimpleErrorStanza StanzaErrorType.Cancel cond rawStanza
                    stanzas.QueueStanzaGeneric None error
        } |> Log.TraceMe

    
    let handleReplication (msgStanza:Stanza<ReplicationAction>) = 
        async {
        let user = neg.RemoteJid
        match msgStanza.Data with
        | ReplicationAction.RequestModifiedSince date ->
            let! userPrefStore = store.GetArchiveStore user.BareJid |> Task.await
            let! changes = userPrefStore.GetChangesSince date |> Task.await
            // return changes
            let stanza = 
                Parsing.createReplicationElement 
                    (msgStanza.Header.Id.Value) 
                    (Some user)
                    (ReplicationAction.RequestModifiedResult changes)
            stanzas.QueueStanzaGeneric None stanza
        | ReplicationAction.RequestModifiedResult _ ->
            failwith "don't expect RequestModifiedResult on this level!"
        return ()
        } |> Log.TraceMe

    
    let handleArchiveManagement (msgStanza:Stanza<MessageArchivingAction>) = 
        async {
        let user = neg.RemoteJid
        let returnResults d = 
            async {
            let stanza = 
                Parsing.createArchivingManagementElement 
                    (msgStanza.Header.Id.Value) 
                    (Some user)
                    (d)
            stanzas.QueueStanzaGeneric None stanza
            } |> Log.TraceMe
        let! userPrefStore = store.GetArchiveStore user.BareJid |> Task.await
        match msgStanza.Data with
        | MessageArchivingAction.CollectionResult _
        | MessageArchivingAction.RequestResult _ -> 
            failwith "don't expect CollectionResult or RequestResult on this level!"
        | MessageArchivingAction.RequestList filter -> 
            let! result = userPrefStore.FilterMessages filter |> Task.await
            do! returnResults (MessageArchivingAction.RequestResult result)
        | MessageArchivingAction.RequestCollection col ->
            let! result = userPrefStore.RetrieveCollection col |> Task.await
            do! returnResults (MessageArchivingAction.CollectionResult result)
        | MessageArchivingAction.RemoveAllCollections filter ->
            let! cols = userPrefStore.FilterMessages filter |> Task.await
            for c in cols do
                do! userPrefStore.RemoveCollection c.Id |> Task.await |> Async.Ignore
            if cols.IsEmpty then
                let error = StanzaException.createSimpleErrorStanza StanzaErrorType.Cancel StanzaErrorConditon.ItemNotFound msgStanza.SimpleStanza
                stanzas.QueueStanzaGeneric None error
            else
                // send ack
                stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)
        | MessageArchivingAction.RemoveCollection id ->
            let! res = userPrefStore.RemoveCollection id |> Task.await
            if not res then
                let error = StanzaException.createSimpleErrorStanza StanzaErrorType.Cancel StanzaErrorConditon.ItemNotFound msgStanza.SimpleStanza
                stanzas.QueueStanzaGeneric None error
            else
                // send ack
               stanzas.QueueStanza None (Stanza.createEmptyIqResult (Some user) msgStanza.Header)
        | MessageArchivingAction.RemoveOpenCollections jid ->
            // TODO: save open Collections in context
        
                let error = StanzaException.createSimpleErrorStanza StanzaErrorType.Cancel StanzaErrorConditon.ItemNotFound msgStanza.SimpleStanza
                stanzas.QueueStanzaGeneric None error
        return ()
        } |> Log.TraceMe

    let createPipelinePlugin name isContent parseContent handleContent =
        { new IRawStanzaPlugin with        
            member x.ReceivePipeline = 
                { Pipeline.empty (sprintf "MessageArchiving-%s" name) with
                    HandlerState =
                        fun info ->
                            let stanza : Stanza = info.Result.Element
                            if isContent stanza && addressing.IsLocalStanzaMaybeServer stanza then HandlerState.ExecuteAndHandle
                            else HandlerState.Unhandled
                    Process =
                        fun info ->
                            async {
                                let elem = info.Result.Element
                                let stanza = Stanza<_>.Create(elem, (parseContent elem))
                                do! handleContent (stanza)
                            } |> Async.StartAsTask
                } :> IPipeline<_> }
    do
        registrar.RegisterFor<IRawStanzaPlugin> (createPipelinePlugin "preference" Parsing.isContentPreference Parsing.parseContentPreference handlePreferences)
        registrar.RegisterFor<IRawStanzaPlugin> (createPipelinePlugin "manual-archiving" Parsing.isContentManualArchiving Parsing.parseContentManualArchiving handleManualArchiving)
        registrar.RegisterFor<IRawStanzaPlugin> (createPipelinePlugin "automatic-archiving" Parsing.isContentAutomaticArchiving Parsing.parseContentAutomaticArchiving handleAutomaticArchiving)
        registrar.RegisterFor<IRawStanzaPlugin> (createPipelinePlugin "replication" Parsing.isContentReplication Parsing.parseContentReplication handleReplication)
        registrar.RegisterFor<IRawStanzaPlugin> (createPipelinePlugin "archiving-management" Parsing.isContentArchiveManagement Parsing.parseContentArchivingManagement handleArchiveManagement)
       
    let createNewCol (withJid:JabberId) =
        { 
            Header = 
                { 
                    Id = 
                        { 
                            With = withJid.BareJid
                            Start = System.DateTime.UtcNow }
                    Thread = Some "thread"
                    Version = None
                    Subject = Some (sprintf "Chat with %s" withJid.BareId) }
            ChatItems = []
            SetPrevious = false
            Previous = None
            SetNext = false
            Next = None }

    let toMessageSimple (isTo,msg) = 
        let msgInfo = {
                Sec = None
                Utc = Some System.DateTime.UtcNow
                Name = None
                Jid = None
            }
        let content = {
                Body = Some msg
                AdditionalData = []
            }
        if isTo then
            ChatItem.To(msgInfo, content)
        else
            ChatItem.From(msgInfo, content)
    let createNewCollection isTo withJid (stanza:MessageStanza) currentCollection =
        let openCol =
            match currentCollection with
            | Some (lastAccess, isSaved, openCol) ->
                if System.DateTime.UtcNow - lastAccess > config.CollectionTimeout then
                    // new collection
                    createNewCol withJid
                else
                    openCol
            | None ->
                createNewCol withJid
        { openCol with 
            ChatItems = 
                stanza.Data.Body 
                    |> List.map (fun (body, lang) -> toMessageSimple(isTo, body))
                    |> List.append openCol.ChatItems }
    let archiveInStorage (withJid:JabberId) (userService:IMessageArchivingPerUserService) (jid:JabberId) =
        async {
        let maybeCol = userService.OpenCollection(withJid)
        match maybeCol with
        | Some (lastAccess, isSaved, openCol) ->
            if not isSaved && System.DateTime.UtcNow - lastAccess > System.TimeSpan.FromSeconds(20.0) then
                Log.Verb (fun _ -> L "Saving messages for %s with %s." jid.BareId withJid.BareId)
                let! userstore = store.GetArchiveStore jid |> Task.await
                // store the collection
                do! userstore.StoreCollection openCol |> Task.awaitPlain
                userService.OpenCollection(withJid) <- Some (lastAccess, true, { openCol with ChatItems = [] })
        | None -> ()
        } |> Log.TraceMe
        
    let archiveInStorageDelayed isTo (withJid:JabberId) (userService:IMessageArchivingPerUserService) (stanza:MessageStanza) (jid:JabberId) =
        async {
        let maybeCol = userService.OpenCollection(withJid)
        let openCol = createNewCollection isTo withJid stanza maybeCol

        // We append the messages to the collection, this is the inMemory action
        userService.OpenCollection(withJid) <- Some (System.DateTime.UtcNow, false, openCol)
        async {
            try
                do! Async.Sleep (30000)
                return! userService.OpenCollectionLock(withJid).Lock (fun () -> archiveInStorage withJid userService jid)
            with 
            | exn -> 
                Log.Err (fun _ -> L "Error while saving history for %s with %s: %O" jid.BareId withJid.BareId exn)
            return () 
        } |> Log.TraceMeAs "ArchiveManager-DelayedStorage" |> Async.Start
        return ()
        }
    let archiveMessageFor (stanza:MessageStanza) jid =
        async {
            Log.Verb (fun () -> L "handle archiving message for %A" jid)
            let! userPrefStore = store.GetPreferenceStore jid |> Task.await
            let! storedPrefs = userPrefStore.GetUserPreferences() |> Task.await
            let prefs = getCurrentPreferences storedPrefs

            let isAutoSaveEnabled = 
                prefs.AutomaticArchiving && 
                prefs.DefaultOtrSaveMode.SaveMode.IsSome && 
                prefs.DefaultOtrSaveMode.SaveMode.Value = SaveMode.Body
            if isAutoSaveEnabled then
                Log.Verb (fun () -> L "archiving message for %A" jid)
                let userService = (perUser.ForUser jid).GetService<IMessageArchivingPerUserService>()
                // let context = serverApi.ServerContext.GetUserContext jid
                let isTo = 
                    stanza.Header.From.IsSome && stanza.Header.From.Value.BareId = jid.BareId
                let withJid = 
                    if isTo then stanza.Header.To.Value else stanza.Header.From.Value
                do! userService.OpenCollectionLock(withJid).Lock (fun () -> archiveInStorageDelayed isTo withJid userService stanza jid)
        }
        
    let messageReceived (stanza:MessageStanza) = 
        
        Log.Verb (fun () -> L "handling messageReceived for automatic archiving")

        if (stanza.Data.Body.Length > 0) then
            // if autoarchiving is enabled -> archive
            match stanza.Header.From with
            | Some from ->
                if from.IsSpecialOf(JabberId.Parse serverApi.Domain) then
                    // archive message in "from" store
                    Async.StartAsTask(archiveMessageFor stanza from) |> ignore
            | None -> ()

            match stanza.Header.To with
            | Some toJid ->
                if stanza.Header.From.IsNone || stanza.Header.From.Value.BareId <> toJid.BareId then
                    // not an internal chat from resource to resource.
                    if toJid.IsSpecialOf(JabberId.Parse serverApi.Domain) then
                        // archive message in "toJid" store
                        Async.StartAsTask(archiveMessageFor stanza toJid) |> ignore
            | None -> ()

    do
        imService.MessageReceived
            |> Event.add messageReceived

    interface IXmppPlugin with
        member x.Name = "MessageArchivingPlugin"
        member x.PluginService = Service.None 
