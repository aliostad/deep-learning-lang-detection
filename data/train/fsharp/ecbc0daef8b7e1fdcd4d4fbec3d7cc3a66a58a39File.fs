namespace FSharp.IO.FileSystem

/// Provides methods for accessing files.
module File = 

    type ExistingHandling =
    | Overwrite
    | Fail
    | Skip

    let exists path =
        IOFile.Exists path

    let readAllText path =
        tryCatch (fun () -> 
            IOFile.ReadAllText path)

    let readAllTextWithEncoding path encoding =
        tryCatch (fun () -> 
            IOFile.ReadAllText(path, encoding))

    let writeAllText path contents =
        tryCatch (fun () -> 
            IOFile.WriteAllText(path, contents))

    let writeAllTextWithEncoding path contents encoding =
        tryCatch (fun () -> 
            IOFile.WriteAllText(path, contents, encoding))

    let copyTo source destination existingHandling =
        tryCatch (fun () -> 
            match existingHandling with
            | Overwrite ->
                IOFile.Copy(source, destination, true)
            | Fail ->
                IOFile.Copy(source, destination, false)
            | Skip ->
                if not (exists destination) then
                    IOFile.Copy(source, destination))

    let moveTo source destination =
        tryCatch (fun () -> 
            IOFile.Move(source, destination))

    let delete path = 
        tryCatch (fun () -> IOFile.Delete(path))