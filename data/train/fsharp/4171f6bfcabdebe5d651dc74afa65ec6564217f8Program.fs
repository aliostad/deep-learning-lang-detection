namespace MassConvert

open System
open System.IO
open System.Collections.Generic
open System.Diagnostics

open FunToolbox
open FunToolbox.FileSystem

open Argu
open SharpYaml.Serialization

open MassConvert.Core

open Player

type Arguments = 
    | [<Mandatory>] Config of string
    | Convert
    | Brave
    | Silent
    | Run
    | Watch
    interface IArgParserTemplate with
        member s.Usage = 
            match s with
            | Config _ -> "specify a configuration file"
            | Convert -> "do the conversion, don't do a dry-run"
            | Brave -> "be brave, don't halt on errors"
            | Run -> "don't walk, run"
            | Silent -> "don't be chatty, don't show what's being done"
            | Watch -> "watch the files and trigger conversions as soon they happen"

type Mode = 
    | DryRun
    | Convert

type Character =
    | Coward
    | Brave

type Speed = 
    | Walk
    | Run

type Chattiness = 
    | Verbose
    | Silent

type StartupArguments = {
    configFile: Path
    mode: Mode
    character: Character
    speed: Speed
    chattiness: Chattiness
    watch: bool
} with
    static member fromCommandLine currentDir argv = 
        let parser = ArgumentParser.Create<Arguments>()
        let result = parser.Parse(argv)
        let configFile = result.GetResult(<@ Config @>) |> (fun p -> currentDir |> Path.extend p)
        let convert = result.Contains(<@ Arguments.Convert @>)
        let brave = result.Contains(<@ Arguments.Brave @>)
        let run = result.Contains(<@ Arguments.Run @>)
        let silent = result.Contains(<@ Arguments.Silent @>)
        let watch = result.Contains(<@ Arguments.Watch @>)

        let mode = if convert then Mode.Convert else Mode.DryRun
        let character = if brave then Brave else Coward
        let speed = if run then Run else Walk
        let chattiness = if silent then Silent else Verbose

        {
            configFile = configFile
            mode = mode
            character = character
            speed = speed
            chattiness = chattiness
            watch = watch
        }


module Main =
    open System.Threading

    let WalkingDelayAfterEachAction = TimeSpan.FromSeconds(1.)

    let readConfiguration (args: StartupArguments) : Configuration =
        let ser = Serializer()
        let file = File.ReadAllText(args.configFile.value)
        let configDir = args.configFile |> Path.parent
        let values = ser.Deserialize<Dictionary<obj, obj>>(file)
        Configuration.fromDictionary configDir values

    let processActions (startupArgs: StartupArguments) (config: Configuration) (actions: ActionBuilder.Action seq) = 
        match startupArgs.mode with
        | Mode.DryRun ->
            let results = actions |> Player.play (fun a -> a.string)
            results |> Seq.iter (printfn "%s")

        | Mode.Convert ->
            let player = 
                fun (action: ActionBuilder.Action) ->
                    if startupArgs.chattiness = Verbose then
                        printfn "%s" action.string
                    let r = Player.fileSystemPlayer action
                    match startupArgs.speed with
                    | Walk -> Thread.Sleep(WalkingDelayAfterEachAction)
                    | Run -> ()
                    r

            let processActionResult result = 
                match result with
                | ActionSuccess -> ()
                | ActionError (context, e) ->
                    printfn "Error: %s\n  %s" e.Message context
                    match startupArgs.character with
                    | Coward -> failwith "I'm a coward and stop at the first error, make me brave with --brave."
                    | Brave -> ()
            
            actions 
            |> Player.play player
            |> Seq.iter processActionResult

    let processRelativePath (startupArgs: StartupArguments) (config: Configuration) (path: RelativePath) = 

        let ifVerbose f = 
            match startupArgs.chattiness with
            | Verbose -> f()
            | Silent -> ()

        ifVerbose (fun () -> printfn "==== scanning %s" ("/" + path.string))

        let actions = 
            JobBuilder.forRelativePath config path
            |> ActionBuilder.fromJobs config
            |> List.toArray

        match actions with
        | [||] ->
            ifVerbose (fun () -> printfn "==== nothing to do")
        | actions ->
            ifVerbose (fun () -> 
                let info = 
                    match startupArgs.mode with
                    | DryRun -> "showing"
                    | Convert -> "processing"
                printfn "==== %s %d change(s)" info actions.Length)
            actions |> processActions startupArgs config

    let processWatchEvent (startupArgs: StartupArguments) (config: Configuration) (event: Watcher.WatchEvent) = 
        assert(startupArgs.watch = true)
        let processName name = 
            let path = RelativePath.parse name
            processRelativePath startupArgs config path

        match event with
        | Watcher.Error _ -> failwith "internal error"
        | Watcher.Created name -> processName name // Nested
        | Watcher.Changed name -> processName name // Flat
        | Watcher.Deleted name -> processName name // Nested
        | Watcher.Renamed (oldName, name) ->
            processName oldName // Nested
            processName name // Nested

    type ProcessingResult = 
        | WatcherCrashed of exn
        | NotWatching

    let processAndWatch (startupArgs: StartupArguments) (config: Configuration) =

        do
            let destPath = config.destination.path 
        
            match startupArgs.mode with
            | DryRun ->
                if not <| Directory.Exists(destPath.value) then
                    destPath.value
                    |> failwithf "destination path does not exist (required for dry runs):\n  %s"
            | Convert ->
                config.destination.path
                |> Path.ensureDirectoryExists
            
        // start up watcher before scanning the directory, so that we
        // don't miss any changes while we scan.
        let queue = Synchronized.Queue<Watcher.WatchEvent>()
        use watcher = Watcher.watch config.source.path queue.enqueue

        processRelativePath startupArgs config RelativePath.empty
        
        if not startupArgs.watch then 
            NotWatching
        else

        let rec watchLoop() = 
            let event = queue.dequeue()
            match event with
            | Watcher.Error e -> WatcherCrashed e
            | e ->
            e |> processWatchEvent startupArgs config 
            watchLoop()
        
        watchLoop()


    let protectedMain argv = 
        let currentDir = Path.currentDirectory()
        let startupArgs = StartupArguments.fromCommandLine currentDir argv

        if startupArgs.chattiness = Verbose then
            if startupArgs.mode = DryRun then
                printfn "info: operating dry, use --convert to actually do something"
            if startupArgs.character = Coward then
                printfn "info: operating as a coward, use --brave to avoid stopping at the first error"
            if startupArgs.speed = Walk then
                printfn "info: operating at heavily reduced speed, use --run to stop walking"
            if startupArgs.chattiness = Verbose then
                printfn "info: operating with verbose chattiness, use --silent to avoid too much talking (and the annoying info lines)"

        let config = startupArgs |> readConfiguration

        let rec processAndWatchLoop() = 
            match processAndWatch startupArgs config with
            | NotWatching -> ()
            | WatcherCrashed e ->
            printfn "watcher crashed:\n%s" e.Message
            if startupArgs.character = Coward 
            then ()
            else 
            printfn "rescanning in 2 seconds" 
            Thread.Sleep(TimeSpan.FromSeconds(2.))
            processAndWatchLoop()

        processAndWatchLoop()
    
    [<EntryPoint>]
    let main argv = 
        try
            protectedMain argv
            0
        with e ->
            Console.WriteLine("failed:\n" + e.Message)
            Debug.WriteLine("failed:\n" + (string e))
            1


