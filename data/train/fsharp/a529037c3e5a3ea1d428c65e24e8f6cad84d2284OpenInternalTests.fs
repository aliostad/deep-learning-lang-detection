namespace PopFs.Tests

open NUnit.Framework
open FsUnit
open System.Diagnostics
open Pop
open PopOpen
open System

[<TestFixture>]
type ``OpenInternal Tests`` ()=
    
    let FakeStart i = i
    let FakeFindProcHandle _ = nativeint 0
    let FakeFindLockHandle _ = nativeint 0
    let Log (f: string) = Console.WriteLine f  

    [<Test>] 
    member x. ``It should use the locking handle, if found`` ()=
        let start f = { File = f; Prc = new Process() }
        let FakeFindProcHandle f = Failure "not found"
        let FakeFindLockHandle p = Success 10n

        OpenInternal start 0 FakeFindLockHandle FakeFindProcHandle "file" |> should equal 10n

    [<Test>] 
    member x. ``It should use the process handle, if lock handle isn't available`` ()=
        let start f = { File = f; Prc = new Process() }
        let FakeFindLockHandle _  = Failure "not found"
        let FakeFindProcHandle _  = Success 20n

        OpenInternal start 1 FakeFindLockHandle FakeFindProcHandle "file" |> should equal 20n

