// Learn more about F# at http://fsharp.net
open Microsoft.FSharp.Control
open System.Collections.Generic
open System.Threading
open System.IO

type RequestGate(n:int) = 
    let semaphore = new Semaphore(initialCount=n,maximumCount=n);
    member x.AcquireAsync(?timeout) = 
        async {
            let! ok = Async.AwaitWaitHandle (semaphore ,?millisecondsTimeout=timeout)
            if ok then 
                return 
                    { new System.IDisposable with 
                        member x.Dispose() = semaphore.Release() |> ignore }
            else
                return! failwith "couldn't adquire a semaphore"
        }

let requestGate = RequestGate(5)

let copyStream (input:Stream) (output:Stream) = 
    let buffer = Array.zeroCreate 32768;
    let mutable flag = true
    while flag do
        let read = input.Read (buffer, 0, buffer.Length);
        if (read <= 0) then
            flag <- false;
        else
            output.Write (buffer, 0, read);
            output.Flush()

let copy (s,t) = async { 
    //limit the amount of copy operations happening simultaneously
    use! holder = requestGate.AcquireAsync()
    printf "'%s' -> '%s'\n" s t 
    use sourceStream = new FileStream(s,FileMode.Open,FileAccess.Read,FileShare.Read)
    use targetStream = new FileStream(t,FileMode.Create,FileAccess.ReadWrite,FileShare.None) 
    do! async { copyStream sourceStream targetStream }
    }

let synch (s,t) = async { 
    try
        do! copy (s,t) 
        //copy attributes
        File.SetCreationTime (t,File.GetCreationTime(s))
        File.SetLastWriteTime(t,File.GetLastWriteTime(s))
        //File.SetAccessControl(t,File.GetAccessControl(s))
        //File.SetAttributes   (t,File.GetAttributes(s))
    with ex -> printf "ERROR: copy failed with: %s\n" ex.Message
    }

let createDirectory (source,target) = async {
    if Directory.Exists target then return Some(target)
    else
        use! holder = requestGate.AcquireAsync()
        try
            Directory.CreateDirectory(target) |> ignore
            Directory.SetCreationTime (target,Directory.GetCreationTime(source))
            Directory.SetLastWriteTime(target,Directory.GetLastWriteTime(source))
            //Directory.SetAccessControl(target,Directory.GetAccessControl(source))
            return Some(target)
        with ex ->
            printf "ERROR: create directory '%s' failed with %s\n" target ex.Message
            return None
    }

let synchFolder filter mirror (source,target) = async { 
    let! target = createDirectory (source,target) 
    match target with 
    |Some(_) ->
        Directory.EnumerateFiles(source) 
        |> Seq.map(fun x -> (x,mirror x)) 
        |> Seq.filter filter 
        |> Seq.iter ( fun x ->  Async.Start (synch x) )
    |_ -> ()
    }

//filter files to copy over
let filter (s,t) =
    if File.Exists(t) then
        let source = new FileInfo(s)
        let target = new FileInfo(t)
        source.LastWriteTime > target.LastWriteTime
    else true

let folderCollector (sourceDir,targetDir)=
    
    let mirror (f:string) = 
        if f.StartsWith(sourceDir) then
            let dif = f.Substring(sourceDir.Length)
            targetDir + dif
        else failwith "Invalid argument: %s" f

    MailboxProcessor.Start( fun self ->
        let rec loop _ =
            async {
                let! (a,_) as msg = self.Receive()
                //Spawn a new task for the new folder
                printf "processing %s\n" a
                let q  =  async { 
                                  try
                                  let! folders = synchFolder filter mirror msg 
                                  for folder in Directory.EnumerateDirectories(a) do 
                                    do self.Post(folder,mirror folder) 
                                  with ex -> printf "ERROR: %s" ex.Message }
                do Async.Start q
                return! loop ()

            }
        loop ())

let synchronizeFolders (s, t) = 
    let collector = folderCollector (s,t)
    collector.Post(s,t)

synchronizeFolders (@"\\server-001\shared", @"\\server-002\shared")

System.Console.ReadLine() |> ignore