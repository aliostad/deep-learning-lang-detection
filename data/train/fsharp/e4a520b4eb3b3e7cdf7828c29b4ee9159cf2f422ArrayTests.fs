namespace XeSoft.Utilities.Tests

open Microsoft.VisualStudio.TestTools.UnitTesting
open XeSoft.Utilities
open System

[<TestClass>]
type ArrayTests () =

    let orig = [|'a';'b';'c'|]

    [<TestMethod>]
    member __.``Array hasIndex 0 in 3 item array`` () =
        Assert.AreEqual(true, Array.hasIndex 0 orig)

    [<TestMethod>]
    member __.``Array hasIndex 1 in 3 item array`` () =
        Assert.AreEqual(true, Array.hasIndex 1 orig)

    [<TestMethod>]
    member __.``Array hasIndex 2 in 3 item array`` () =
        Assert.AreEqual(true, Array.hasIndex 2 orig)

    [<TestMethod>]
    member __.``Array hasIndex -1 in 3 item array`` () =
        Assert.AreEqual(false, Array.hasIndex -1 orig)

    [<TestMethod>]
    member __.``Array hasIndex 3 in 3 item array`` () =
        Assert.AreEqual(false, Array.hasIndex 3 orig)

    [<TestMethod>]
    member __.``Array hasIndex int minvalue in 3 item array`` () =
        Assert.AreEqual(false, Array.hasIndex Int32.MinValue orig)

    [<TestMethod>]
    member __.``Array hasIndex int maxvalue in 3 item array`` () =
        Assert.AreEqual(false, Array.hasIndex Int32.MaxValue orig)
    
    [<TestMethod>]
    member __.``Array swapUnsafe 0 and 1 in 3 item array`` () =
        let arr = Array.copy orig
        arr |> Array.swapUnsafe 0 1
        Assert.AreEqual(orig.[0], arr.[1])
        Assert.AreEqual(orig.[1], arr.[0])
        Assert.AreEqual(orig.[2], arr.[2])
    
    [<TestMethod>]
    member __.``Array swapUnsafe 1 and 0 in 3 item array`` () =
        let arr = Array.copy orig
        arr |> Array.swapUnsafe 1 0
        Assert.AreEqual(orig.[0], arr.[1])
        Assert.AreEqual(orig.[1], arr.[0])
        Assert.AreEqual(orig.[2], arr.[2])

    [<TestMethod>]
    member __.``Array swapUnsafe 1 and 2 in 3 item array`` () =
        let arr = Array.copy orig
        arr |> Array.swapUnsafe 1 2
        Assert.AreEqual(orig.[0], arr.[0])
        Assert.AreEqual(orig.[1], arr.[2])
        Assert.AreEqual(orig.[2], arr.[1])

    [<TestMethod>]
    member __.``Array swapUnsafe 0 and 2 in 3 item array`` () =
        let arr = Array.copy orig
        arr |> Array.swapUnsafe 0 2
        Assert.AreEqual(orig.[0], arr.[2])
        Assert.AreEqual(orig.[1], arr.[1])
        Assert.AreEqual(orig.[2], arr.[0])

    [<TestMethod>]
    member __.``Array swapUnsafe -1 and 2 in 3 item array`` () =
        let arr = Array.copy orig
        arr |> Array.swapUnsafe -1 2
        Assert.AreEqual(orig.[0], arr.[0])
        Assert.AreEqual(orig.[1], arr.[1])
        Assert.AreEqual(orig.[2], arr.[2])

    [<TestMethod>]
    member __.``Array swapUnsafe 0 and 3 in 3 item array`` () =
        let arr = Array.copy orig
        arr |> Array.swapUnsafe 0 3
        Assert.AreEqual(orig.[0], arr.[0])
        Assert.AreEqual(orig.[1], arr.[1])
        Assert.AreEqual(orig.[2], arr.[2])

    [<TestMethod>]
    member __.``Array swapUnsafe 0 1 in 0 item array`` () =
        let arr = [||]
        arr |> Array.swapUnsafe 0 1
        // basically, just don't crash
        Assert.AreEqual(0, arr.Length)

    [<TestMethod>]
    member __.``Array swapUnsafe 0 0 in 3 item array`` () =
        let arr = Array.copy orig
        arr |> Array.swapUnsafe 0 0
        Assert.AreEqual(orig.[0], arr.[0])
        Assert.AreEqual(orig.[1], arr.[1])
        Assert.AreEqual(orig.[2], arr.[2])
