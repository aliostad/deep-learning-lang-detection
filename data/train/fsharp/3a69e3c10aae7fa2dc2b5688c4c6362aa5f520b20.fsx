#r "System.Data.dll"
#r "FSharp.Data.TypeProviders.dll"
#r "System.Data.Linq.dll"

open System
open System.IO
open System.Collections.Generic

let today = DateTime.Now.Date
let outputPath = @"D:\\backup\\" + String.Format("{0}-{1}-{2}", today.Year, today.Month, today.Day)

let rec directoryCopy srcPath dstPath copySubDirs =

    if not <| System.IO.Directory.Exists(srcPath) then
        let msg = System.String.Format("Source directory does not exist or could not be found: {0}", srcPath)
        raise (System.IO.DirectoryNotFoundException(msg))

    if not <| System.IO.Directory.Exists(dstPath) then
        System.IO.Directory.CreateDirectory(dstPath) |> ignore

    let srcDir = new System.IO.DirectoryInfo(srcPath)

    for file in srcDir.GetFiles() do
        let temppath = System.IO.Path.Combine(dstPath, file.Name)
        file.CopyTo(temppath, true) |> ignore

    if copySubDirs then
        for subdir in srcDir.GetDirectories() do
            let dstSubDir = System.IO.Path.Combine(dstPath, subdir.Name)
            directoryCopy subdir.FullName dstSubDir copySubDirs

let getLogs (kvp:KeyValuePair<string,string>) = 
    async  {
        let np = Path.Combine(outputPath, kvp.Key)
        Directory.CreateDirectory kvp.Value |> ignore
        directoryCopy kvp.Value np true
    }

let rec deleteFiles srcPath =
    
    if not <| System.IO.Directory.Exists(srcPath) then
        let msg = System.String.Format("Source directory does not exist or could not be found: {0}", srcPath)
        raise (System.IO.DirectoryNotFoundException(msg))

    for file in System.IO.Directory.EnumerateFiles(srcPath) do
        let tempPath = System.IO.Path.Combine(srcPath, file)
        System.IO.File.Delete(tempPath)

    let srcDir = new System.IO.DirectoryInfo(srcPath)
    for subdir in srcDir.GetDirectories() do
        deleteFiles subdir.FullName 


let backupFolders = new System.Collections.Generic.Dictionary<string, string>()
backupFolders.Add("folder-name", @"Z:\some-folder-name") |> ignore

let backup() = (
    try
        if System.IO.Directory.Exists(outputPath) then
            deleteFiles outputPath 
        else
            Directory.CreateDirectory(outputPath) |> ignore
    with
    | exn -> printfn "An exception occurred: %s" exn.Message

    backupFolders 
    |> Seq.map getLogs 
    |> Async.Parallel 
    |> Async.RunSynchronously
    |> ignore

    printfn "backup complete"
)

backup()