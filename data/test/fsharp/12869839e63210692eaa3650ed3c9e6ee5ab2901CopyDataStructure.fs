module CopyDataStructure

open Newtonsoft.Json
open System.IO
open System.Collections.Generic 
open System
//open System.Threading

type Files = {
    SourceFolder : string
    DestinationFolder : string
    CopySubFolder: bool 
}


//--------------------------------- 
//DeleteFolderFiles
//* rec -> it is a recursive function
// there are many ways to delete the files/folder, no need to get a parameter by includeSubFolder but this is a recursive test.
//--------------------------------- 
let rec DeleteFolderFiles destinationPath pattern includeSubFolder =

      if not <| Directory.Exists(destinationPath) then
          let msg = String.Format("Folder [{0}] does not exist!", destinationPath)
          raise (DirectoryNotFoundException(msg))
  
      for file in Directory.EnumerateFiles(destinationPath, pattern) do
          let destinationPath = Path.Combine(destinationPath, file)
          
          // problem encountered all files were read only
          File.SetAttributes(destinationPath, FileAttributes.Normal)   
          File.Delete(destinationPath)
 
      if includeSubFolder then
         let destinationFolderInfo = new DirectoryInfo(destinationPath)

         for subFolder in destinationFolderInfo.GetDirectories() do
             //Thread.Sleep(500)
             DeleteFolderFiles subFolder.FullName pattern includeSubFolder

      Directory.Delete(destinationPath)


//--------------------------------- 
//CopyFolderFiles
//--------------------------------- 
let rec CopyFolderFiles sourceFolder destinationFolder copySubFolder = 

    //create folder always
    Directory.CreateDirectory(destinationFolder) |> ignore

    //start copying files 
    let sourceFolderInfo = new DirectoryInfo(sourceFolder)


    for file in sourceFolderInfo.GetFiles() do
        let destinationPath = Path.Combine(destinationFolder, file.Name)
        file.CopyTo(destinationPath, true) |> ignore

    if copySubFolder then
            for subfolder in sourceFolderInfo.GetDirectories() do
                let destinationSubFolder = Path.Combine(destinationFolder, subfolder.Name)

//                try
                printfn "Copying source folder %A" subfolder.FullName 
                CopyFolderFiles subfolder.FullName destinationSubFolder copySubFolder
//                with
//                    | :? System.InsufficientMemoryException -> (printfn "insufficient memory")
//                    | :? System.ArgumentException -> (printfn "exception")
//                    | :? System.OutOfMemoryException -> (printfn "out of memory")
//                    | _ -> ()
                            

let BackupFiles  =

    //testing phase
    let path = @"FoldersToBeCopied.json"
 
    let serializer = new JsonSerializer()
    let reader = new StreamReader(path) 

    //thought to get it going
    let contents = serializer.Deserialize(reader, typeof<Files list>) :?> Files list

    reader.Close()

    let destinationFolders = contents|> List.map(fun x -> x.DestinationFolder)
    let copySubFolders = contents|> List.map(fun x -> x.CopySubFolder)
    let sourceFolders = contents|> List.map(fun x -> x.SourceFolder)

    for count in 0 .. sourceFolders.Length - 1 do
        let sourceFolder = sourceFolders.[count]
        let destinationFolder = destinationFolders.[count]
        let copySubFolder = copySubFolders.[count]

        //check folders
        if not <| Directory.Exists(sourceFolder) then
            raise (DirectoryNotFoundException(String.Format("Source folder [{0}] does not exist!", sourceFolder)))

        if Directory.Exists(destinationFolder) then
            DeleteFolderFiles destinationFolder "*.*" true

        CopyFolderFiles sourceFolder destinationFolder copySubFolder



////////////////////
//playing around
///////////////////
//    let sourceDirectoryRoot = sourceFolder + @"\"
//    let destinationDirectory = destinationFolder
//
//    if Directory.Exists(destinationFolder) then
//        DeleteFolderFiles destinationFolder "*.*" true
//
//    //create folder always
//    Directory.CreateDirectory(destinationFolder) |> ignore
//
//    //cool feature, check variable declaration and how it works when debugging
//    let getFileName sourceFile = FileInfo(sourceFile).Name
//    let getSourceFiles = Directory.GetFiles(sourceDirectoryRoot, "*.*") // example
//    let getDestinationFileName sourceFile destinationDirectory = destinationDirectory + getFileName sourceFile 
//
//    //FUNCTION - That's an overdose for a C# person :)
//    let copyFile sourceFile destinationDirectory = File.Copy(sourceFile, getDestinationFileName sourceFile destinationDirectory, true) |> ignore  
//    
//    for sourceFile in getSourceFiles do
//        if not <| Directory.Exists(Path.GetDirectoryName(sourceFile)) then
//            Directory.CreateDirectory(Path.GetDirectoryName(sourceFile)) |> ignore
//        copyFile sourceFile destinationDirectory

