module FSharp.IO.FileSystem.Tests.FileTests

open Xunit

open Chessie.ErrorHandling

open FSharp.IO.FileSystem
open FSharp.IO.FileSystem.Path


let create() =
    let p = Path.tempFile()
    File.writeAllText (p) "placeholder" |> returnOrFail
    p

let check path =
    let contents = File.readAllText path |> returnOrFail
    if contents <> "placeholder" then
        failwith "contents were not \"placeholder\""

let checkNot path =
    let contents = File.readAllText path |> returnOrFail
    if contents = "placeholder" then
        failwith "contents were \"placeholder\""

let createEmpty() =
    Path.tempFile()

let tempFile() =
    Path.tempPath() @@ System.Guid.NewGuid().ToString()

[<Fact>]
let ``copy skip - no exist`` () =
    let source = create()
    let dest = tempFile()
    File.copyTo source dest File.Skip |> returnOrFail
    check dest

[<Fact>]
let ``copy skip - exist`` () =
    let source = create()
    let dest = createEmpty()
    File.copyTo source dest File.Skip |> returnOrFail
    checkNot dest

[<Fact>]
let ``copy overwrite - no exist`` () =
    let source = create()
    let dest = tempFile()
    File.copyTo source dest File.Skip |> returnOrFail
    check dest

[<Fact>]
let ``copy overwrite - exist`` () =
    let source = create()
    let dest = createEmpty()
    File.copyTo source dest File.Overwrite |> returnOrFail
    check dest


[<Fact>]
let ``copy fail - no exist`` () =
    let source = create()
    let dest = tempFile()
    File.copyTo source dest File.Skip |> returnOrFail
    check dest

[<Fact>]
let ``copy fail - exist`` () =
    let source = create()
    let dest = createEmpty()
    let res = File.copyTo source dest File.Fail
    match res with
    | Bad messages ->
        let message = messages |> Seq.exactlyOne
        printfn "%s" message 
        Assert.Equal(sprintf @"The file '%s' already exists." dest,message)
    | _ -> failwith "should have failed"