namespace FSharp.IO.FileSystem

open Path

open Chessie.ErrorHandling

/// Provides methods for accessing directories.
module Directory = 
    
    let exists path =
        IODirectory.Exists path

    let create path =
        tryCatch (fun() -> 
            IODirectory.CreateDirectory path |> ignore )
    let fullName path =
        tryCatch(fun () ->
            System.IO.DirectoryInfo(path).FullName)

    let getFiles path = 
        tryCatch (fun() -> 
            IODirectory.GetFiles(path)
            |> Seq.ofArray)

    let getDirectories path = 
        tryCatch (fun() -> 
            IODirectory.GetDirectories(path) 
            |> Seq.ofArray)

    let moveToDir source destination =
        tryCatch(fun () ->
            IODirectory.Move(source, destination))

    /// copyToDir "/foo" "/bar" copy the contents of "/foo" into "/bar"
    let rec copyContentsToDir source destination existingHandling =
        trial {
            if not (exists destination) then
                do! create destination

            let! files = getFiles source
            let! dirs = getDirectories source
            
            for file in files do
                let file = Path.fileName file
                do! File.copyTo (source @@ file) (destination @@ file) existingHandling
            for dir in dirs do
                let dir = Path.fileName dir
                do! copyContentsToDir (source @@ dir) (destination @@ dir) existingHandling
        }
                       
    /// copyToDir "/foo" "/bar" would create "/bar/foo" and copy the contents of "/foo" into it.
    let copyToDir source destination existingHandling =
        let name = source |> Path.fileName

        copyContentsToDir source (destination @@ name) existingHandling


    /// Will delete an empty directory. If `path` is not empty then a failure will be returned.
    let delete path =
        tryCatch(fun () -> IODirectory.Delete(path))

    /// Will delete a directory. All contents are deleted recursivly.
    let deleteRecursive path =
        tryCatch(fun () -> IODirectory.Delete(path, true))

    /// Deletes the contents of a directory recursivly.
    let deleteContents path =
        trial {
            let! dirs = getDirectories path
            let! files = getFiles path
            
            for file in files do
                do! File.delete file

            for dir in dirs do
                do! deleteRecursive dir
        }