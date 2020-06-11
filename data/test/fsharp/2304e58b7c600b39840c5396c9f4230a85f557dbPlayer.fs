module Player

open System
open System.IO
open System.Text
open System.Diagnostics
open Config
open System.Threading

type Result<'a> = 
    | Success of 'a
    | Failure of string

type MusicFile = 
    | MusicFile of string

type PlayList = 
    | PlayList of MusicFile list

type TrackIndex = 
    | TrackIndex of int

type Drive = 
    | NoDisk
    | Loaded of playList : PlayList
    | Playing of playList : PlayList * track : TrackIndex * elapsed : TimeSpan
    | Paused of playList : PlayList * track : TrackIndex
    | Starting of playList : PlayList
    | Stopping of playList : PlayList
    | Pausing of playList : PlayList * track : TrackIndex
    | Resuming of playList : PlayList * track : TrackIndex
    | GoingToNext of playList : PlayList * track : TrackIndex
    | GoingToPrevious of playList : PlayList * track : TrackIndex
    | Broken of reason : string

type Command = 
    | SetPlayList of PlayList
    | Play
    | Stop
    | Pause
    | Next
    | Previous
    | Query

type Api = 
    { handle : Command -> unit
      changes : IObservable<Drive> }

type InternalCommand = 
    | ExternalCommand of Command
    | PlayListChange
    | NextAction of (Drive -> Drive)
    | PlayerProcessFinished

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
        | Some(content) -> Success content
        | None -> 
            Thread.Sleep 100
            openPlayListFile config (retryCnt - 1)
    else Failure "Cannot open play-list file."

let private findCurrentIndex config = 
    match (openPlayListFile config 10) with
    | Success(playListContent) -> 
        let index = playListContent |> Array.tryFindIndex (fun l -> l.StartsWith "#")
        match index with
        | Some(i) -> Success(TrackIndex i)
        | None -> Success(TrackIndex 0)
    | Failure(msg) -> Failure(sprintf "Could nor retrieve current track (Reason: %s)" msg)

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
    sapProcess.Exited.Add(fun _ -> notifyFinished())
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
    | NoDisk -> Loaded playList
    | Loaded (_) -> Loaded playList
    | _ -> drive

let private play config schedule notifyFinished drive = 
    match drive with
    | Loaded(playList) -> 
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
            Loaded playList)
        Stopping playList
    | Paused(playList, _) -> 
        writePlayListFile config playList
        Loaded playList
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
        match (findCurrentIndex config) with
        | Success(index) -> Playing(playList, index, (getElapsedTime config))
        | Failure(msg) -> Broken msg
    | _ -> drive

let private handlePlayListChanged config drive = 
    match (findCurrentIndex config) with
    | Failure(msg) -> Broken msg
    | Success(index) -> 
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
        Loaded(playList)
    | _ -> drive

let private shouldTriggerUpdate lastDrive newDrive (lastUpdate : DateTime) (now : DateTime) = 
    match lastDrive, newDrive with
    | Playing(_, t1, elapsed1), Playing(pl2, t2, elapsed2) -> 
        match t1, t2 with
        | TrackIndex(i1), TrackIndex(i2) when i2 < i1 || (i1 = i2 && elapsed2 < elapsed1) -> false
        | _ -> 
            if now.Subtract(lastUpdate) > TimeSpan.FromMilliseconds(200.0) then true
            else 
                let toCompareTo = Playing(pl2, t2, elapsed1)
                lastDrive <> toCompareTo
    | d1, d2 -> d1 <> d2

let createApi (config : ConfigData) = 
    let directEvents = Event<Drive>()
    
    let commandReceiver = 
        MailboxProcessor.Start(fun inbox -> 
            let schedule a = inbox.Post(NextAction a)
            let notifyFinished() = inbox.Post PlayerProcessFinished
            
            let rec messageLoop drive lastLoopExecution = 
                async { 
                    let! internalCmd = inbox.Receive()
                    let newDrive = 
                        match internalCmd with
                        | ExternalCommand cmd -> 
                            match cmd with
                            | SetPlayList(pl) -> setPlayList drive pl
                            | Play -> play config schedule notifyFinished drive
                            | Stop -> stop config schedule drive
                            | Pause -> pause config schedule drive
                            | Next -> next config schedule drive
                            | Previous -> previous config schedule drive
                            | Query -> query config drive
                        | PlayListChange _ -> handlePlayListChanged config drive
                        | NextAction(a) -> a drive
                        | PlayerProcessFinished -> handlePlayerPocessFinished config schedule drive
                    
                    let now = DateTime.Now
                    if shouldTriggerUpdate drive newDrive lastLoopExecution now then directEvents.Trigger newDrive
                    return! messageLoop newDrive now
                }
            messageLoop NoDisk DateTime.Now)
    
    let playListWatcher = new FileSystemWatcher(config.SAPDirectory, Path.GetFileName config.SAPPlaylistPath)
    playListWatcher.EnableRaisingEvents <- true
    playListWatcher.Changed
    |> Observable.subscribe (fun _ -> commandReceiver.Post PlayListChange)
    |> ignore
    let impl cmd = commandReceiver.Post(ExternalCommand cmd)
    { handle = impl
      changes = directEvents.Publish }
