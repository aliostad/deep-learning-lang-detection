module FSharp.IO.FileSystem.Tests.DirectoryTests

open Xunit

open Chessie.ErrorHandling

open FSharp.IO.FileSystem
open FSharp.IO.FileSystem.Path

let tempFolder() = 
    tempPath() @@ System.Guid.NewGuid().ToString()

let createDir (spec : string seq) =
    let root = tempFolder()
    for file in spec do
        Directory.create (root @@ (file |> Path.directoryName)) |> returnOrFail
        File.writeAllText (root @@ file) file |> returnOrFail
    root

let checkDir (spec : string seq) path =
    printfn "path %s" path
    for file in spec do
        printfn "file %s" file
        let contents = (path @@ file) |> File.readAllText |> returnOrFail
        if contents <> file then
            failwith "contents dont match"

[<Fact>]
let ``copyToDir`` () =
    let spec = [ "foo/bar1/baz" 
                 "foo/bar2/baz"
                 "foo/bar2/bill"
                 "bog/bid" ]
    let source = createDir spec
    let dest = tempFolder()
    let dirName = source |> Path.fileName
    Directory.copyToDir source dest File.Fail |> returnOrFail
    checkDir spec (dest @@ dirName)


[<Fact>]
let ``copyContentsToDir`` () =
    let spec = [ "foo/bar1/baz" 
                 "foo/bar2/baz"
                 "foo/bar2/bill"
                 "bog/bid" ]
    let source = createDir spec
    let dest = tempFolder()
    Directory.copyContentsToDir source dest File.Fail |> returnOrFail
    checkDir spec (dest)