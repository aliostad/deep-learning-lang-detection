// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.GameMediaManager

open Wire
open System
open System.Windows.Forms
open System.IO
open System.Drawing
open System.Diagnostics
open Yaaf.Logging
open Yaaf.Utils
open Yaaf.GameMediaManager.WinFormGui
open Yaaf.GameMediaManager.Primitives
open Yaaf.GameMediaManager.WinFormGui.Properties

/// The Wire Plugin implementation
type ReplayWirePlugin() = 
    inherit Wire.Plugin()
    
    let logger = 
        let trace = Source "Yaaf.GameMediaManager.ReplayWirePlugin" ""
        DefaultTracer trace "Initialization"
    
    let shutdown reason = 
        logger.logVerb "Shutdown (%s)" reason
        try
            Process.GetCurrentProcess().Kill()
        with exn ->
            logger.logErr "Shutdown-Error (%O)" exn

    let contextMenu = 
        let cm = 
            new ContextMenuStrip(
                RenderMode = ToolStripRenderMode.ManagerRenderMode,
                Font = new Font("Tahoma", 8.0f),
                ShowCheckMargin = false,
                ShowItemToolTips = false,
                AutoClose = true)
        let item s pic f = 
             new ToolStripMenuItem(s, pic, 
                (fun sender e -> 
                    let t = 
                        new System.Threading.Thread(fun () ->
                            try
                                f()
                            with exn ->
                                logger.logErr "Error: %O" exn)
                    t.SetApartmentState(System.Threading.ApartmentState.STA)
                    t.Start())) 
             :> ToolStripItem
        let seperator () = new ToolStripSeparator() :> ToolStripItem
        let showForm (f:System.Windows.Forms.Form) = 
            using f (fun form ->
                form.ShowDialog() |> ignore)
        [
            item Resources.ReportBug Resources.mail
                (fun () -> 
                    try 
                        Process.Start(ProjectConstants.GetLink "issues/new") |> ignore
                    with exn -> logger.logErr "Error: %O" exn)
            item Resources.Info Resources.i
                (fun () -> new InfoForm(logger) |> showForm)
            item Resources.EditGames Resources.add
                (fun () -> new EditGames(logger)|> showForm)
            item Resources.MatchSessions Resources.favs
                (fun () ->
                    new ViewMatchSessions(logger)|> showForm)
            item Resources.EditPlayers Resources.edit
                (fun () ->
                    new ManagePlayers(logger)|> showForm)
            seperator()
            item Resources.Shutdown Resources.cancel
                (fun () ->
                    try 
                        Process.Start(Database.pluginFolder) |> ignore
                        Process.Start(ProjectConstants.GetLink "issues/new") |> ignore
                    with exn -> logger.logErr "Error: %O" exn
                    shutdown "User exit")
            item Resources.CloseMenu Resources.cancel id
        ]
            |> List.iter (fun t -> cm.Items.Add(t) |> ignore)
        cm

    // Session Management
    let gameSessions = new System.Collections.Generic.Dictionary<int, Session option>()
    let getGameSession id = 
        match gameSessions.TryGetValue id with
        | true, v -> v
        | false, _ -> None
    let setGameSession id game = gameSessions.[id] <- game

    let sessionMatchStarted logger (gameInterface:Wire.GameInterface) matchId = 
        let matchInfo =
            match matchId with
            | Some warId ->
                let info = gameInterface.matchInfo(warId)
                let eslMatchLink = info.["uri"] :?> string
                Some { EslId = warId; MatchUrl = eslMatchLink }
            | None -> None
        Session.MatchStarted logger matchInfo
    
    /// Starts the mediawatcher for the given game
    let sessionGameStarted (logger:ITracer)  (session:Session) gameId gamePath = 
        session.GameStarted logger gameId gamePath

    /// Stops the watcher saves the matchmedia and starts the given actions
    let sessionEnd (logger:ITracer) (session:Session) = 
        session.SessionEnd logger
    
    let setupGameEvents (gameInterface:Wire.GameInterface) = 
        // Setup Game events
        let logEvent event f = 
            let logger = logger.childTracer (event)
            try
                let t = 
                    new System.Threading.Thread(fun () ->
                        try
                            f logger
                        with exn ->
                            logger.logErr "Error: %O" exn)
                t.SetApartmentState(System.Threading.ApartmentState.STA)
                t.Start()
            with exn ->
                logger.logErr "Error: %O" exn

        let formatGameData (data:System.Collections.Generic.Dictionary<_,_>) =
            let stringJoin sep strings =
                System.String.Join(sep, strings |> Seq.toArray)
            let s = 
                data
                |> Seq.map (fun k -> k.Key, k.Value)
                |> Seq.map (fun (k,v) -> sprintf "\t[%s, %O]" k v)
                |> stringJoin "; \n"
            sprintf "[ \n%s ]" s

        // Match started (before Game started and only with wire)
        gameInterface.add_MatchStarted
            (fun matchId matchMediaPath -> 
                logEvent ("MatchStart" + string matchId) (fun logger ->
                    Settings.Default.MatchMediaPath <- matchMediaPath
                    Settings.Default.Save()
                    let data = gameInterface.matchInfo matchId
                    logger.logInfo 
                        "Starting Match with data: %s" (data |> formatGameData)
                    let gameId = data.["gameId"] :?> int
                    match getGameSession gameId with
                    | Some (s) -> 
                        failwith "a previous session was not closed properly!"
                    | None ->
                        let session = Some (sessionMatchStarted logger gameInterface (Some matchId))
                        setGameSession gameId session))

        // Game started (with or without wire)
        gameInterface.add_GameStarted
            (fun gameId gamePath -> 
                logEvent ("GameStart" + string gameId) (fun logger ->
                    let currS = 
                        match getGameSession gameId with
                        | Some (s) -> s // Use this session as it was created in MatchStart
                        | None -> sessionMatchStarted logger gameInterface None
                        
                    sessionGameStarted logger currS gameId gamePath 
                    |> Some
                    |> setGameSession gameId))

        // Game stopped (before Match ended and always)
        // On real matches we have time until Anticheat has finished (parallel) for copying our matchmedia
        gameInterface.add_GameStopped
            (fun gameId -> 
                logEvent ("GameEnd" + string gameId) (fun logger ->
                    match getGameSession gameId with
                    | Some (s) -> 
                        // Use this session as it was created in MatchStart
                        setGameSession gameId None
                        sessionEnd logger s
                    | None -> 
                        failwith "No session found on GameEnd!"))

        // Match ended (the Matchmedia dialog is already opened)
        // This event brings no additional information...
        gameInterface.add_MatchEnded
            (fun matchId -> 
                logEvent ("MatchEnd" + string matchId) (fun logger ->
                    let data = gameInterface.matchInfo matchId
                    logger.logInfo 
                        "Ending match session with data: %s" (data |> formatGameData)
                             
                    let gameId = data.["gameId"] :?> int
                    match getGameSession gameId with
                    | Some (s) -> 
                        setGameSession gameId None
                        sessionEnd logger s
                        failwith "Session not already closed on MatchEnd!"
                    | None -> ()))



    let shutdownAndThrow reason = 
        shutdown reason
        raise (InvalidOperationException(sprintf "Shutdown Process %s" reason))

    let executeTask asynchronous message failstring (task:ITask<_> option) = 
        match task with
        | Some (t) ->     
            //let t = Primitives.Task<_>(t, update) :> Primitives.ITask<_>
            let onFinished () = 
                match t.ErrorObj with
                | Some error ->
                    MessageBox.Show(
                        System.String.Format(failstring, error.Message), 
                        Resources.Error)
                        |> ignore
                | None -> ()
            let startTaskFun = 
                if asynchronous then 
                    WaitingForm.StartTaskAsync
                else 
                    (fun (logger, t, message, onFinished) -> 
                        try
                            WaitingForm.StartTask(logger, t, message)
                        finally
                            onFinished.Invoke())
            startTaskFun(logger, t, message , Action(onFinished))                
        | None -> ()
        
        

    /// Interop with CSharp 
    let interop = 
        let dataBaseInterop = 
            { new IFSharpDatabase with
                member x.GetIdentityPlayer db = Database.getIdentityPlayer db.Context
                member x.GetPlayerByEslId (db, eslId) = 
                    match Database.tryGetPlayerByEslId db.Context eslId with
                    | Some s -> s
                    | None -> null
                member x.GetPlayerById (db, id) = 
                    match Database.tryGetPlayerById db.Context id with
                    | Some s -> s
                    | None -> null 
                member x.DeleteMatchSession (db, delFiles,session) = 
                    Database.removeSession db.Context delFiles session
                member x.GetGame (db, nameOrId) =
                    match Database.getGameByName db.Context nameOrId with
                    | Some s -> s
                    | None -> null 
                member x.DeleteMatchmedia (db,delFile, media) =
                    Database.removeMatchmedia db.Context delFile media }
        { new IFSharpInterop with
            member x.GetMatchmediaPath media = 
                Database.mediaPath media
            member x.Database with get() = dataBaseInterop
            member x.GetNewContext () = Database.getContext()     
            member x.GetFetchPlayerTask link =
                let asyncTask = async { return! EslGrabber.getMatchMembers link } 
                Primitives.Task(asyncTask) :> Primitives.ITask<_> 
            member x.FillWrapperTable(session, players, wrapperTable, mediaTable) = 
                Database.fillWrapperTable session players wrapperTable mediaTable
            member x.GetUpgradeTask logger = Upgrading.getUpgradeTask logger }    

    /// Init Global variables & Setup Assembly Loading machanism
    do  logger.logVerb "Starting up Yaaf.GameMediaManager (%s)" ProjectConstants.VersionString
    static do 
        Application.EnableVisualStyles()

        Settings.Default.SetProjectDefaults()        
        if Version(Settings.Default.SettingsVersion) < ProjectConstants.ProjectVersion then
            Settings.Default.Upgrade()
            Settings.Default.SettingsVersion <- ProjectConstants.VersionString
        
        if System.String.IsNullOrEmpty Settings.Default.MatchMediaPath then
            Settings.Default.MatchMediaPath <-
                Path.Combine(
                    System.Environment.GetFolderPath(System.Environment.SpecialFolder.MyDocuments),
                    "ESL Match Media")

        Settings.Default.Save()

        // without this important WinFormGui.dll will not be found for some reason
        let dir = Path.GetDirectoryName (System.Reflection.Assembly.GetExecutingAssembly().Location)
        let winFormGui = System.Reflection.Assembly.LoadFile(Path.Combine(dir, "Yaaf.GameMediaManager.WinFormGui.dll"))
        System.AppDomain.CurrentDomain.add_AssemblyResolve
            (System.ResolveEventHandler(fun o e -> if e.Name.StartsWith("Yaaf.GameMediaManager.WinFormGui") then winFormGui else null))
            
    override x.Author with get() = "Matthias Dittrich"
    override x.Title with get() = "Yaaf WirePlugin"
    override x.Version with get() = System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString()
    override x.iconClicked (xCord, yCord, button) = 
        match button with
        | Plugin.MouseButton.RightButton ->
            contextMenu.Show(xCord, yCord)
        | Plugin.MouseButton.LeftButton ->
            ()
        | _ ->
            ()

        base.iconClicked(xCord, yCord, button)
    
    override x.init () =
        try 
            logger.logVerb "Init Plugin" 
            FSharpInterop.Interop <- interop

            let gameInterface = InterfaceFactory.gameInterface()
            
            // Upgrade Database
            let dbtask = DatabaseUpgrade.getUpgradeDatabaseTask logger
            executeTask false Resources.UpgradingDatabase Resources.FailedToUpgradeDatabase dbtask
            
            let upgradeTask = Upgrading.getUpgradeTask logger
            executeTask true Resources.UpgradingPlugin Resources.FailedToUpgradePlugin (Some upgradeTask)

            setupGameEvents gameInterface
            
            // Set the icon
            x.setIcon(Resources.bluedragon)
        with exn ->
            logger.logErr "Error: %O" exn
            shutdown ("Startup error!")

