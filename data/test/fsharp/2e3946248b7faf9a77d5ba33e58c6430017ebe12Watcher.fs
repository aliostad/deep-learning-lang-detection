namespace MassConvert.Core

open System
open System.IO

open FunToolbox
open FunToolbox.FileSystem

module Watcher = 

    type WatchEvent = 
        | Error of exn
        | Created of string
        | Changed of string
        | Deleted of string
        | Renamed of string * string

    let watch (path: Path) (notify: WatchEvent -> unit) : IDisposable = 
        // note that the pattern in the second argument is also applied to directories, so we
        // can't use it and watch every change for now.
        let watcher = new FileSystemWatcher(path.value)
        watcher.IncludeSubdirectories <- true
        watcher.NotifyFilter <- NotifyFilters.DirectoryName ||| NotifyFilters.FileName ||| NotifyFilters.LastWrite
        // set internal buffer size to the maximum size possible.
        watcher.InternalBufferSize <- 0x10000
    
        let changed = FileSystemEventHandler(fun _ args -> Changed args.Name |> notify)
        let created = FileSystemEventHandler(fun _ args -> Created args.Name |> notify)
        let deleted = FileSystemEventHandler(fun _ args -> Deleted args.Name |> notify)
        let renamed = RenamedEventHandler(fun _ args -> Renamed (args.OldName, args.Name) |> notify)
        let error = ErrorEventHandler(fun _ args -> Error (args.GetException()) |> notify)
        watcher.Created.AddHandler(created)
        watcher.Changed.AddHandler(changed)
        watcher.Deleted.AddHandler(deleted)
        watcher.Renamed.AddHandler(renamed)
        watcher.Error.AddHandler(error)

        // let's go
        watcher.EnableRaisingEvents <- true

        let destructor() = 

            watcher.Error.RemoveHandler(error)
            watcher.Renamed.RemoveHandler(renamed)
            watcher.Deleted.RemoveHandler(deleted)
            watcher.Changed.RemoveHandler(changed)
            watcher.Created.RemoveHandler(created)

            watcher.EnableRaisingEvents <- false
            watcher.Dispose()

        destructor
        |> asDisposable
