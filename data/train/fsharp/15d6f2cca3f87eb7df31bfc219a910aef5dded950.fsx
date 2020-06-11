open System.IO
open System

let inline Parallel2 (job1, job2) = async {
        let! task1 = Async.StartChild job1
        let! task2 = Async.StartChild job2
        let! res1 = task1
        let! res2 = task2
        return (res1, res2) }


let fastCopy (source:System.IO.Stream) (destination:System.IO.Stream) = async {
        source.Position <- 0L
        destination.Position <- 0L

        let buffer = Array.init 2 (fun _ -> Array.zeroCreate<byte> 4096)
        let index = ref 1
        let! read = source.AsyncRead(buffer.[!index])
        if read > 0 then 
            let rec copyAsync (s:Stream) (d:Stream) (buff:byte[][]) read = async {
                let! (_, read') = Async.Parallel2(d.AsyncWrite(buff.[!index], 0, read), 
                                       s.AsyncRead(buff.[(!index ^^^ 1)]))
                if read' > 0 then 
                    index := !index ^^^ 1
                    return! copyAsync s d buff read' }
            return! copyAsync source destination buffer read
        return (source, destination)}

let fileSource = @"c:\Temp\sourceFile.jpg"
let fileDest = @"c:\Temp\destinationFile.jpg"

let streamSource = new FileStream(fileSource, FileMode.Open,
      FileAccess.Read,FileShare.Read,0x1000, true)
let streamDest = new FileStream(fileDest, FileMode.Create,
      FileAccess.Write, FileShare.Write,0x1000,true)
    
Async.StartWithContinuations(fastCopy streamSource streamDest,
    (fun comp -> 
        let source, dest = comp
        source.Dispose()
        dest.Dispose()),
    (fun _ -> ()),
    (fun _ -> ()))