module SnapshotModule

open System.IO
open System.IO.Abstractions
open System.Reflection
open Chauffeur

type FileMetadata =
    { Path : string
      DestinationPath : string }

type DirectoryMetadata =
    { FullName : string }

let findExports (fileSystem : IFileSystem) folder =
    fileSystem.Directory.GetFiles(folder, "*.config", SearchOption.AllDirectories)
    |> Seq.map fileSystem.FileInfo.FromFileName

let outputFolder combine dest =
    let now = System.DateTimeOffset.Now
    let timestamp = now.ToString "yyyy-MM-dd-hh-mm"
    combine (dest, timestamp)

let mapFiles combine rootFolder dest files  =
    let pathResolver (fullName : string) =
        let relativePath = fullName.Replace(rootFolder, "")
        combine (dest, relativePath)
    files
    |> Seq.map (fun (file:FileInfoBase) ->
        { Path = file.FullName
          DestinationPath = combine (dest, pathResolver file.FullName) })

let copyExportedFiles copy createFolder files =
    files
    |> Seq.map (fun file ->
        createFolder file.DestinationPath
        file)
    |> Seq.iter (fun file -> copy (file.Path, file.DestinationPath))

let usyncSnapshot uSyncRoot (fileSystem : IFileSystem) outputFolder (out : TextWriter) (in' : TextReader) chauffeurFolder =
    async {
        let createFolder path =
            let f = fileSystem.FileInfo.FromFileName path
            fileSystem.Directory.CreateDirectory f.Directory.FullName |> ignore

        let deliverableFolder = outputFolder fileSystem.Path.Combine chauffeurFolder
        uSyncRoot.FullName
        |> findExports fileSystem
        |> mapFiles fileSystem.Path.Combine uSyncRoot.FullName deliverableFolder
        |> copyExportedFiles fileSystem.File.Copy createFolder
        do! out.WriteLineAsync(sprintf "uSync files copied to %s" deliverableFolder) |> Async.AwaitTask
        return { FullName = deliverableFolder }
    }
