module Directories
open System.IO

[<CompiledName("CopyDirectory")>]
let rec copyDirectory (source:DirectoryInfo, destination:DirectoryInfo)=
    if not destination.Exists then
        destination.Create()
    else
        ()

    // Copy all files.
    let files = source.GetFiles()
    for file in files do
        file.CopyTo(Path.Combine(destination.FullName, file.Name)) |> ignore

    // Process subdirectories.
    let dirs = source.GetDirectories()
    for dir in dirs do
        // Get destination directory.
        let destinationDir = Path.Combine(destination.FullName, dir.Name);

        // Call CopyDirectory() recursively.
        copyDirectory (dir, new DirectoryInfo(destinationDir))
