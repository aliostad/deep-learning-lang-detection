module Drive

open System
open System.IO
open System.Text
open System.Diagnostics
open Config
open System.Threading
open DriveModel

let private encoding = Encoding.GetEncoding("ISO-8859-1")

let private writePlayListFile (config : ConfigData) (PlayList playList) = 
    use fs = new FileStream(config.SAPPlaylistPath, FileMode.Create, FileAccess.Write)
    use writer = new StreamWriter(fs, encoding)
    playList |> Seq.iter (fun (MusicFile mf) -> writer.WriteLine mf)

let rec openPlayListFile (config : ConfigData) retryCnt = 
    if retryCnt > 0 then 
        let lines = 
            try 
                Some(File.ReadAllLines(config.SAPPlaylistPath, encoding))
            with _ -> None
        match lines with
        | Some(content) -> content
        | None -> 
            Thread.Sleep 100
            openPlayListFile config (retryCnt - 1)
    else failwith "Cannot open play-list file."

let private findCurrentIndex config = 
    let playListContent = openPlayListFile config 10
    let indexOpt = playListContent |> Array.tryFindIndex (fun l -> l.StartsWith "#")
    match indexOpt with
    | Some(i) -> TrackIndex(i)
    | None -> TrackIndex(0)

let private getElapsedTime (config : ConfigData) = 
    let playListFileInfo = FileInfo config.SAPPlaylistPath
    DateTime.Now.Subtract(playListFileInfo.LastWriteTime)

let private prepareSapProcess config = 
    let info = ProcessStartInfo config.SAPExePath
    info.WorkingDirectory <- config.SAPDirectory
    info.UseShellExecute <- false
    let sapProcess = new Process()
    sapProcess.StartInfo <- info
    (info, sapProcess)

let private startSapProcess config notifyFinished = 
    let _, sapProcess = prepareSapProcess config
    sapProcess.EnableRaisingEvents <- true
    sapProcess.Exited.Add(fun _ -> 
        notifyFinished()
        sapProcess.Dispose())
    sapProcess.Start() |> ignore

let private runSapControlProcess config command = 
    let info, p = prepareSapProcess config
    use sapProcess = p
    info.Arguments <- command
    sapProcess.Start() |> ignore
    sapProcess.WaitForExit()

let isLastTrack (PlayList(playList)) (TrackIndex(index)) = 
    playList
    |> List.length
    |> (=) (index + 1)

let private isFirstTrack (TrackIndex(index)) = index = 0

let private setPlayList drive playList = 
    match drive with
    | Empty -> Ready playList
    | Ready(_) -> Ready playList
    | _ -> drive

let private play config schedule notifyFinished drive = 
    match drive with
    | Ready(playList) -> 
        writePlayListFile config playList
        startSapProcess config notifyFinished
        Starting playList
    | Paused(playList, track) -> 
        schedule (fun _ -> 
            startSapProcess config notifyFinished
            Playing(playList, track, TimeSpan.Zero))
        Resuming(playList, track)
    | _ -> drive

let private stop config schedule drive = 
    match drive with
    | Playing(playList, _, _) -> 
        schedule (fun _ -> 
            runSapControlProcess config "Stop"
            Ready playList)
        Stopping playList
    | Paused(playList, _) -> 
        writePlayListFile config playList
        Ready playList
    | _ -> drive

let private pause config schedule drive = 
    match drive with
    | Playing(playList, idx, _) -> 
        schedule (fun _ -> 
            runSapControlProcess config "Pause"
            Paused(playList, idx))
        Pausing(playList, idx)
    | _ -> drive

let private next config schedule drive = 
    match drive with
    | Playing(pl, tr, _) when not (isLastTrack pl tr) -> 
        schedule (fun nextDrv -> 
            runSapControlProcess config "Next"
            nextDrv)
        GoingToNext(pl, tr)
    | _ -> drive

let private previous config schedule drive = 
    match drive with
    | Playing(pl, tr, _) when not (isFirstTrack tr) -> 
        schedule (fun nextDrv -> 
            runSapControlProcess config "Prev"
            nextDrv)
        GoingToPrevious(pl, tr)
    | _ -> drive

let private query config drive = 
    match drive with
    | Playing(playList, _, _) -> 
        Playing(playList, (findCurrentIndex config), (getElapsedTime config))
    | _ -> drive

let private handlePlayListChanged config drive = 
    let index = findCurrentIndex config
    match index with
    | TrackIndex(i) -> 
        let reportPlaying pl = Playing(pl, index, (getElapsedTime config))
        match drive with
        | Starting(playList) -> reportPlaying playList
        | Playing(playList, _, _) -> reportPlaying playList
        | GoingToNext(playList, _) -> reportPlaying playList
        | GoingToPrevious(playList, _) -> reportPlaying playList
        | _ -> drive

let private handlePlayerPocessFinished config schedule drive = 
    match drive with
    | Playing(playList, _, _) -> 
        schedule (fun d -> 
            writePlayListFile config playList
            d)
        Ready(playList)
    | _ -> drive

let private shouldTriggerUpdate lastDrive newDrive (lastUpdate : DateTime) (now : DateTime) = 
    let updatesNotVeryClose = now.Subtract(lastUpdate) > TimeSpan.FromMilliseconds(200.0)
    match lastDrive, newDrive with
    | Playing(_, t1, elapsed1), Playing(pl2, t2, elapsed2) -> 
        match t1, t2 with
        | TrackIndex(i1), TrackIndex(i2) when i2 < i1 || (i1 = i2 && elapsed2 < elapsed1) -> false
        | _ -> 
            if updatesNotVeryClose then true
            else 
                let toCompareTo = Playing(pl2, t2, elapsed1)
                lastDrive <> toCompareTo
    | d1, d2 -> updatesNotVeryClose || d1 <> d2

type private DriveActorCommand = 
    | DriveCommand of Command
    | PlayListChange
    | NextAction of (DriveState -> DriveState)
    | PlayerProcessFinished

type private DriveActorState = 
    { driveState : DriveState
      lastExecution : DateTime }

let private driveStateChangedEvents = Event<DriveState>()

let createApi (config : ConfigData) = 
    let driveActor = 
        MailboxProcessor.Start(fun inbox -> 
            let schedule a = inbox.Post(NextAction a)
            let notifyFinished() = inbox.Post PlayerProcessFinished
            
            let rec messageLoop state = 
                async { 
                    let! actorCmd = inbox.Receive()
                    let driveState = state.driveState
                    
                    let newDrive = 
                        try
                            match actorCmd with
                            | DriveCommand cmd -> 
                                match cmd with
                                | SetPlayList(pl) -> setPlayList driveState pl
                                | Play -> play config schedule notifyFinished driveState
                                | Stop -> stop config schedule driveState
                                | Pause -> pause config schedule driveState
                                | Next -> next config schedule driveState
                                | Previous -> previous config schedule driveState
                                | Query -> query config driveState
                            | PlayListChange _ -> handlePlayListChanged config driveState
                            | NextAction(a) -> a driveState
                            | PlayerProcessFinished -> handlePlayerPocessFinished config schedule driveState
                        with e -> (Broken e.Message)
                    
                    let now = DateTime.Now
                    if shouldTriggerUpdate driveState newDrive state.lastExecution now then 
                        driveStateChangedEvents.Trigger newDrive
                    return! messageLoop { driveState = newDrive
                                          lastExecution = now }
                }
            messageLoop { driveState = Empty
                          lastExecution = DateTime.Now })
    
    let playListWatcher = new FileSystemWatcher(config.SAPDirectory, Path.GetFileName config.SAPPlaylistPath)
    playListWatcher.EnableRaisingEvents <- true
    playListWatcher.Changed
    |> Observable.subscribe (fun _ -> driveActor.Post PlayListChange)
    |> ignore
    let impl cmd = driveActor.Post(DriveCommand cmd)
    { execute = impl
      changes = driveStateChangedEvents.Publish }

let availableCommands drive = 
    let setPlayList = SetPlayList(PlayList [])
    match drive with
    | Empty -> [ setPlayList ]
    | Ready(_) -> [ setPlayList; Play ]
    | Playing(playList, track, _) -> 
        seq { 
            yield Stop
            yield Pause
            if not (isLastTrack playList track) then yield Next
            if not (isFirstTrack track) then yield Previous
        }
        |> Seq.toList
    | Paused(_) -> [ Play; Stop ]
    | _ -> []
