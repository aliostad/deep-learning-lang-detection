module FileCopy
open System.Text.RegularExpressions
open System.IO
open FileAccess

let copyFile dir files =
    let newDir = (createDir dir).FullName
    let destinationFile (FileName file) = 
        let m = Regex.Match(file, "(\d{1,}.*\.\w+$)")
        if (m.Success) then Some (FileName file, (FileName (sprintf "%s\%s" newDir m.Groups.[1].Value)))
        else None

    let copyToNewDestination filesToCopy = 
        filesToCopy
        |> List.iter (fun (FileName oldFile, FileName newFile) -> File.Copy(oldFile, newFile, true))
        printfn "%d files were copied." filesToCopy.Length

    files 
    |> List.choose destinationFile
    |> copyToNewDestination