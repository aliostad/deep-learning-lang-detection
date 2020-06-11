open System
open System.IO
open System.Linq
open System.Text.RegularExpressions
open System.Diagnostics

let backupPath = @"C:\Users\tan.yong.heng\Desktop\stuffs\New folder\"

let logFileGroupToProcess =
    let logFileGroups = 
        let rec allFilesUnder baseFolder = 
            seq {
                yield! Directory.GetFiles(baseFolder)
                for subDir in Directory.GetDirectories(baseFolder) do
                    yield! allFilesUnder subDir 
                }
        let regexFormat = "201[2-3][0-9][0-9][0-9][0-9]"
        let files = allFilesUnder __SOURCE_DIRECTORY__
        let filesToProcess = files |> Seq.filter (fun i-> Regex.IsMatch(i,regexFormat))
        filesToProcess |> Seq.groupBy (fun i-> Regex.Match(i,regexFormat).Value) |> Seq.map (fun (key,value) -> (Path.Combine(__SOURCE_DIRECTORY__, key)), value |> Seq.filter (fun j-> j.ToString().EndsWith(".log")) )
    let todayDate = DateTime.Now.ToString("yyyyMMdd")
    logFileGroups |> Seq.filter (fun (key,value) -> key <> todayDate)

let tryMoveFileToDir src destDir =
    try
        let destinationFile = 
            let fileName = Path.GetFileName(src) 
            Path.Combine(destDir, fileName)
        File.Move(src, destinationFile)
    with
        | ex -> printfn "%s" ex.Message
        
logFileGroupToProcess |> Seq.map (fun (key,_)-> key) |> Seq.iter (fun p-> if not <| Directory.Exists(p) then Directory.CreateDirectory p |> ignore)

logFileGroupToProcess  |> Seq.iter (fun (folder,files) -> (for file in files do tryMoveFileToDir file folder))

let winRarZip path =
    let winRarPath = Path.Combine(__SOURCE_DIRECTORY__,"Rar.exe")
    let args = String.Format("a -df -ep -r {0} {1}",path, path)
    let p = Process.Start(winRarPath,args)
    p.WaitForExit()

logFileGroupToProcess |> Seq.map (fun (key,_) -> key) |> Seq.map (fun i-> async { winRarZip i}) |> Async.Parallel |> Async.RunSynchronously

logFileGroupToProcess |> Seq.map (fun (key,_) -> key + ".rar") |> Seq.iter (fun i-> tryMoveFileToDir i backupPath)




