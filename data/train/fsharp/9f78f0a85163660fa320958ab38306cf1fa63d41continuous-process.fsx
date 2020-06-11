open System
open System.IO
open System.Threading

let handler(x:FileSystemEventArgs) = printfn "%A" (x.FullPath, x.ChangeType)

let watchPath() = begin

    let fileChanged = new Event<FileSystemEventArgs>()

    let path = "."
    let filter = "*.*"
    use watcher = new FileSystemWatcher(path, filter)
    watcher.NotifyFilter <- NotifyFilters.LastAccess ||| NotifyFilters.LastWrite
    //watcher.Changed.Add(fun e -> fileChanged.Trigger(e))

    watcher.Changed.Add(handler)
    watcher.EnableRaisingEvents <- true
    fileChanged.Publish
end

Async.RunSynchronously <| 
    async {
        let handler(x:FileSystemEventArgs) = printfn "%A" (x.FullPath, x.ChangeType)

        let event = watchPath()
        use result = event.Subscribe(handler)

        for i in 1..10 do
            do! Async.Sleep(1000)
            printfn "Async waiting %i" i
        ()
    }

