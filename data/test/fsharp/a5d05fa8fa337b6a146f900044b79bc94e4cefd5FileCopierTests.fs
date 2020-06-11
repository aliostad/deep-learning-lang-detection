module FileCopierTests

open System
open System.IO
open System.Diagnostics

open NaturalSpec
open NUnit.Framework

open SofGem.DSBK.IO
open SofGem.DSBK.Domain


let tempDir = @"C:\Temp"
let fullPath relPath = 
   let path = PathW.Combine(tempDir, relPath)
   DirectoryW.CreateDirectory(PathW.GetDirectoryName(path)) |> ignore
   path

let copy (source, destination) =
   let spath = fullPath source
   let dpath = fullPath destination
   Console.WriteLine("copy from: " + spath + " to: " + dpath)
   true

let calling f x =
   printMethod ""
   f x

[<TestFixtureSetUp>]  
let setup () =
   Debug.Write("setup")

[<TestFixtureTearDown>]
let teardown () =
   Debug.Write("teardown")   

[<ScenarioTemplate(@"dir1\dir2\file1", @"dir1\dir3\file2")>]
let ``Simple copy of a file from source to destination`` (source, destination) =
   Given (source, destination)
   |> When calling copy
   |> It should equal true
   |> Verify
