namespace R4nd0mApps.TddStud10.Common

open System
open System.IO
open System.Reactive.Linq

module FileSystem = 
    type FileSystemEvent = 
        | Created of FileInfo
        | Changed of FileInfo
        | Deleted of FileInfo
        | Renamed of FileInfo * FileInfo
    
    let watch nf so filter path = 
        Observable.Create<_>(fun (o : IObserver<_>) -> 
            let fsw = new FileSystemWatcher(path, filter)
            fsw.Created.AddHandler(fun _ args -> o.OnNext(Created(FileInfo(args.FullPath))))
            fsw.Changed.AddHandler(fun _ args -> o.OnNext(Changed(FileInfo(args.FullPath))))
            fsw.Deleted.AddHandler(fun _ args -> o.OnNext(Deleted(FileInfo(args.FullPath))))
            fsw.Renamed.AddHandler
                (fun _ args -> o.OnNext(Renamed(FileInfo(args.FullPath), FileInfo(args.OldFullPath))))
            fsw.Error.AddHandler(fun _ args -> o.OnError(args.GetException()))
            fsw.IncludeSubdirectories <- (so = SearchOption.AllDirectories)
            nf |> Option.iter (fun e -> fsw.NotifyFilter <- e)
            fsw.EnableRaisingEvents <- true
            fsw :> IDisposable)
