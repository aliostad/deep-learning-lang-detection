module DevRT.Tests.FileUtilTests

open NUnit.Framework
open Swensen.Unquote
open Common
open DevRT.FileUtil

let doCopyTest elements =
    let mockAdd, mockResult = mock()
    let createPath x =
        mockAdd (sprintf "createPath %s" x)
        "y"
    let copy x y = mockAdd (sprintf "copy %s %s" x y)
    let get = fun () -> elements
    doCopy createPath get copy
    mockResult()

[<Test>]
let ``doCopy when nothing to copy`` () =
    [] |> doCopyTest =! []

[<Test>]
let ``doCopy when one element`` () =
    ["1"] |> doCopyTest =! ["createPath 1"; "copy 1 y"]

let copyAllFilesTest recLevel =
    let mutable rl = recLevel
    let mockAdd, mockResult = mock()
    let createDirectory dest = mockAdd (sprintf "createdirectory %d" dest)
    let copyFiles source dest = mockAdd (sprintf "copyFiles %d %d" source dest)
    let copySubdirectories cf source dest =
        match rl with | l when l > 0 -> rl <- (rl - 1); cf rl rl | _ -> ()
    copyAllFiles createDirectory copyFiles copySubdirectories 44 66
    mockResult()

[<Test>]
let ``copyAllFiles when rec level 0`` () =
    copyAllFilesTest 0 =! ["createdirectory 66"; "copyFiles 44 66"]

[<Test>]
let ``copyAllFiles when rec level 1`` () =
    copyAllFilesTest 1 =!
        [
            "createdirectory 66"; "copyFiles 44 66";
            "createdirectory 0"; "copyFiles 0 0"
        ]

[<Test>]
let ``deleteAllFiles when target does not exists`` () =
    let exists _ = false
    deleteAllFiles exists shouldNotBeCalled ()

[<Test>]
let ``deleteAllFiles when target does exists`` () =
    let mockAdd, mockResult = mock()
    let exists _ = true
    let deleteRecursive _ = mockAdd "delete"
    deleteAllFiles exists deleteRecursive ()
    mockResult() =! ["delete"]
