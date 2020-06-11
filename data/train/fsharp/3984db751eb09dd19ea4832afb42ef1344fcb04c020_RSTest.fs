namespace QiniuFSTest

open System
open System.IO
open System.Net
open NUnit.Framework
open QiniuFS
open Base

[<TestFixture>]
type RSTest() =
    [<Test>]
    member this.StatTest() =
        putString c ("stat.txt", "statstat") |> ignoreRetSynchro
        let e = entry tc.BUCKET "stat.txt"
        RS.stat c e |> ignoreRetSynchro
        RS.delete c e |> ignoreRetSynchro

    [<Test>]
    member this.DeleteTest() =
        putString c ("deleteMe.txt", "deleteMe") |> ignoreRetSynchro
        RS.delete c (entry tc.BUCKET "deleteMe.txt") |> ignoreRetSynchro

    [<Test>]
    member this.CopyTest() =
        let content = "orig"
        putString c ("copySrc.txt", content) |> ignoreRetSynchro
        let src = entry tc.BUCKET "copySrc.txt"
        let dst = entry tc.BUCKET "copyDst.txt"
        RS.copy c src dst |> ignoreRetSynchro
        let ret = getString c "copyDst.txt"
        Assert.AreEqual(content, ret)
        RS.delete c src |> ignoreRetSynchro
        RS.delete c dst |> ignoreRetSynchro

    [<Test>]
    member this.MoveTest() =
        putString c ("beforeMove.txt", "content") |> ignoreRetSynchro
        let src = entry tc.BUCKET "beforeMove.txt"
        let dst = entry tc.BUCKET "afterMove.txt"
        RS.move c src dst |> ignoreRetSynchro
        RS.delete c dst |> ignoreRetSynchro

    [<Test>]
    member this.BatchTest() =
        let entryOf (key : String) = entry tc.BUCKET key
        putString c ("a.txt", "a") |> ignoreRetSynchro
        putString c ("b.txt", "b") |> ignoreRetSynchro
        [|
            RS.OpMove(entryOf "a.txt", entryOf "temp.txt")
            RS.OpMove(entryOf "b.txt", entryOf "a.txt")
            RS.OpMove(entryOf "temp.txt", entryOf "b.txt")
        |]
        |> RS.batch c
        |> Async.RunSynchronously
        |> Array.map pickRet
        |> ignore
        Assert.AreEqual("b", getString c "a.txt")
        Assert.AreEqual("a", getString c "b.txt")
        RS.delete c (entryOf "a.txt") |> ignoreRetSynchro
        RS.delete c (entryOf "b.txt") |> ignoreRetSynchro

    [<Test>]
    member this.ChangeMimeTest() =
        putString c ("changeMime.txt", "changeMime") |> ignoreRetSynchro
        RS.changeMime c "text/html" (entry tc.BUCKET "changeMime.txt") |> ignoreRetSynchro
        RS.delete c (entry tc.BUCKET "changeMime.txt") |> ignoreRetSynchro
