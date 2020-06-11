module Storage
open System.IO
open System
open Extensions

let personalDir = Environment.GetFolderPath(Environment.SpecialFolder.Personal)
let data_directory = Path.Combine(personalDir,"data")

let ensureDir dir =
    if Directory.Exists dir |> not then
        Directory.CreateDirectory dir |> ignore

let copyFile ctx uictx f =
    try
        let files = 
            if Directory.Exists data_directory then
                Directory.GetFiles(data_directory)
            else
                [||]
        if files |> Array.isEmpty then
            AndroidExtensions.notifyAsync ctx uictx "" "No files to copy" f
        else
            let extPath = "/sdcard/Download"
            ensureDir extPath
            files
            |> Array.map (fun f ->
                let fn = Path.GetFileName(f)
                let toPath = Path.Combine(extPath,fn)
                try
                    logI (sprintf "copying %s to %s" f toPath)
                    File.Copy(f,toPath)
                    File.Delete f
                    1
                with ex ->
                    logE ex.Message
                    0
                )
            |> Array.sum
            |> fun count ->
                AndroidExtensions.notifyAsync ctx uictx "" (sprintf "%d files copied out of %d" count files.Length) f
    with ex ->
        logE ex.Message

