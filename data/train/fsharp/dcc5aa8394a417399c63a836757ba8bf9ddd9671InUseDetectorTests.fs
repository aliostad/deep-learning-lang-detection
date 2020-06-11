namespace PopFs.Tests

open Pop.Cs
open Pop
open NUnit.Framework
open FsUnit
open System
open System.IO
open System.Threading
open System.Diagnostics

[<TestFixture>]
type ``Given InUseDetection`` () =
    let directory = Environment.CurrentDirectory

//    let openFile = 
//        let file = Path.Combine(Environment.CurrentDirectory, "IAmTextFile.txt")
//        Process.Start (file) |> ignore
//        Thread.Sleep(2000)
//        InUseDetection.GetProcessesUsingFiles [file]
//
//    let openFiles1 = 
//        let file1 = Path.Combine(directory, "Word 1.docx")
//        let file2 = Path.Combine(directory, "Word 2.docx")
//
//        file1 |> Process.Start |> ignore
//        file2 |> Process.Start |> ignore
//
//        let processes1 = InUseDetection.GetProcessesUsingFiles [file1]
//        let processes2 = InUseDetection.GetProcessesUsingFiles [file2]
//        processes2

    let openFiles2 = 
        let file1 = Path.Combine(directory, "Word 1.docx")
        let file2 = Path.Combine(directory, "Word 2.docx")

        file1 |> Process.Start |> fun p -> (printfn "Handle: %i, Title: %s" p.MainWindowHandle p.MainWindowTitle)
        file2 |> Process.Start |> fun p -> (printfn "Handle: %i, Title: %s" p.MainWindowHandle p.MainWindowTitle)

        [file1; file2]
        
        

//    [<Test>] member t.
//        ``It can't find the locking handle for text file`` ()=
//            openFile |> should haveCount 0

//    [<Test>] member t.
//        ``It should find the last file when multiple files were opened1`` ()=
//            openFiles1 |> should haveCount 1

//    [<Test>] member t.
//        ``It should find the last file when multiple files were opened2`` ()=
//            openFiles2 |> should haveCount 2

            
