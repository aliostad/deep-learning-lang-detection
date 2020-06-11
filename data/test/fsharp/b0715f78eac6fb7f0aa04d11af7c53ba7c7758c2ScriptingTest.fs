// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.ShellTest

open NUnit.Framework
open FsUnit
open Yaaf.Shell
open Yaaf.Shell.Scripting
open System.IO

[<TestFixture>]
type ``Given the Shell Scripting Module``() = 

    let file1 = "file1.test"
    let file2 = "file2.test"
    let testdir = "testdir"
    let desttestdir = "desttestdir"
    let testDirStructure = 
        [
            "testdir", null
            "testdir/subdir", null
            "testdir/file1.test", "Blub"
            "testdir/subdir/file1.test", "subdir"
            "testdir/file2.test", "secound file" ]

    let setupDir dir = 
        dir 
            |> Seq.iter 
                (fun (path,contents) -> 
                    if contents = null then
                        Directory.CreateDirectory path |> ignore
                    else
                        File.WriteAllText(path, contents))
    [<TearDown>]
    [<SetUp>]
    member this.Init() = 
        File.Delete file1
        File.Delete file2
        let cleanDir dir =
            if Directory.Exists dir then
                Directory.Delete(dir, true)
        cleanDir testdir
        cleanDir desttestdir

    [<Test>]
    member this.``check if cp works for files`` () = 
        File.WriteAllText(file1, "Debug")
        cp NO file1 file2
        let result = File.ReadAllText file2
        result |> should be (equal ("Debug"))
        ()

    [<Test>]
    member this.``check if cp works when overriding`` () = 
        File.WriteAllText(file1, "Debug")
        cp NO file1 file2
        File.WriteAllText(file1, "Blub")
        cp (NO |+ CopyOptions.Overwrite) file1 file2
        let result = File.ReadAllText file2
        result |> should be (equal ("Blub"))
        ()    
    [<Test>]
    member this.``check if cp throws when not overriding`` () = 
        File.WriteAllText(file1, "Debug")
        cp NO file1 file2
        File.WriteAllText(file1, "Blub")
        (fun () ->
            cp NO file1 file2)
            |> should throw typeof<System.IO.IOException>
        let result = File.ReadAllText file2
        result |> should be (equal ("Debug"))
        ()
        
    [<Test>]
    member this.``check if cp works for directories`` () = 
        setupDir testDirStructure
        cp (NO |+ CopyOptions.Rec) testdir desttestdir
        File.ReadAllText (Path.Combine(desttestdir, "file1.test")) 
            |> should be (equal ("Blub"))
        File.ReadAllText (Path.Combine(desttestdir, "subdir", "file1.test")) 
            |> should be (equal ("subdir"))
        ()

    [<Test>]
    member this.``check if cp works for directories when they exits (integrate)`` () = 
        setupDir testDirStructure
        Directory.CreateDirectory desttestdir |> ignore
        cp (NO |+ CopyOptions.IntegrateExisting |+ CopyOptions.Rec) testdir desttestdir
        File.ReadAllText (Path.Combine(desttestdir, "file1.test")) 
            |> should be (equal ("Blub"))
        File.ReadAllText (Path.Combine(desttestdir, "subdir", "file1.test")) 
            |> should be (equal ("subdir"))
        ()
    [<Test>]
    member this.``check if cp works for directories when they exits`` () = 
        setupDir testDirStructure
        Directory.CreateDirectory desttestdir |> ignore
        cp (NO |+ CopyOptions.Rec) testdir desttestdir
        File.ReadAllText (Path.Combine(desttestdir, testdir, "file1.test")) 
            |> should be (equal ("Blub"))
        File.ReadAllText (Path.Combine(desttestdir, testdir, "subdir", "file1.test")) 
            |> should be (equal ("subdir"))
        ()

    [<Test>]
    member this.``check if cp works with useexisting`` () = 
        setupDir testDirStructure
        Directory.CreateDirectory desttestdir |> ignore
        File.WriteAllText(Path.Combine(desttestdir, file1), "OtherContent")
        cp (NO |+ CopyOptions.Rec |+ CopyOptions.IntegrateExisting |+ CopyOptions.UseExisitingFiles) testdir desttestdir
        File.ReadAllText (Path.Combine(desttestdir, "file1.test")) 
            |> should be (equal ("OtherContent"))
        File.ReadAllText (Path.Combine(desttestdir, "subdir", "file1.test")) 
            |> should be (equal ("subdir"))
        ()
        
    [<Test>]
    member this.``check if cp throws without useexisting`` () = 
        setupDir testDirStructure
        Directory.CreateDirectory desttestdir |> ignore
        File.WriteAllText(Path.Combine(desttestdir, file1), "OtherContent")
        (fun () -> cp (NO |+ CopyOptions.Rec |+ CopyOptions.IntegrateExisting) testdir desttestdir)
            |> should throw typeof<System.IO.IOException>
        ()