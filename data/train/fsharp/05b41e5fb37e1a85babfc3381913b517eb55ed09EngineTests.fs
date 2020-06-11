module EngineTests

open System
open System.IO
open System.Diagnostics

open NaturalSpec
open NUnit.Framework

open GabeSoft.FOPS.Core
open GabeSoft.FOPS.Test

// TODO: 
//  - test copy-file
//  - test copy-dir
//  - test copy
//  - test link-file
//  - test link-dir
//  - test link
//  - test yank
//  - test excludes

let running_job (server: IOServer, job: Job) =
  printMethod "\n"
  let engine = new Engine(server)
  engine.Run job
  server.Provider

let writeln text = Console.WriteLine (text:string)

let mkJob item = new Job([item], "j1")
let mkTestProvider paths =
  new TestIOProvider(paths) :> IOProvider
let mkServer paths = 
  let providerImpl = mkTestProvider paths
  let mockProvider = 
    mock<IOProvider> "fake"
    |> setup<@fun x -> x.GetFiles@> providerImpl.GetFiles
    |> setup<@fun x -> x.GetDirectories@> providerImpl.GetDirectories
    |> setup<@fun x -> x.FileExists@> providerImpl.FileExists
    |> setup<@fun x -> x.DirectoryExists@> providerImpl.DirectoryExists
    |> setup<@fun x -> x.CreateDirectory@> (fun x -> sprintf "\tCreateFolder %A" x |> writeln)
    |> setup<@fun x -> x.DeleteFile@> (fun x -> sprintf "\tDeleteFile %A" x |> writeln)
    |> setup<@fun x -> x.Copy@> (fun x -> sprintf "\tCopy %A" x |> writeln)
    |> setup<@fun x -> x.Link@> (fun x -> sprintf "\tLink %A" x |> writeln)
  new IOServer(mockProvider)  

[<Scenario>]
let ``Yank should delete the selected files`` () = 
  let src = @"C:\a\b\c\f*.doc"
  let job = src |> Item.yank PatternMode |> mkJob
  let paths = [   @"C:\a\b\f1.doc"
                  @"C:\a\b\c\f2.doc"
                  @"C:\a\b\c\f3.doc"
                  @"C:\a\b\c\foo.doc"
                  @"C:\a\b\c\d\f3.doc" ]
  
  Given (mkServer paths, job)
  |> When running_job
  |> Called <@fun x -> x.DeleteFile @>(paths.[1])
  |> Called <@fun x -> x.DeleteFile @>(paths.[2])
  |> Called <@fun x -> x.DeleteFile @>(paths.[3])
  |> Verify

let deleted path (provider: IOProvider) =
  printMethod path
  let impl = provider :?> TestIOProvider
  impl.DeletedFiles.Contains(path)

[<Scenario>]
let ``Yank should not delete unselected files`` () =
  let src = @"C:\a\b\c\f*.doc"
  let job = src |> Item.yank PatternMode |> mkJob
  let paths = [   @"C:\a\b\f1.doc"
                  @"C:\a\b\c\f2.doc"
                  @"C:\a\b\c\f3.doc"
                  @"C:\a\b\c\foo.doc"
                  @"C:\a\b\c\p3.doc"
                  @"C:\a\b\c\e3.doc"
                  @"C:\a\b\c\f4.pdf"
                  @"C:\a\b\c\d\f5.doc" ]
  let provider = mkTestProvider paths
  let server = new IOServer(provider)

  Given (server, job)
  |> When running_job
  |> It shouldn't have (deleted paths.[0])
  |> It shouldn't have (deleted paths.[4])
  |> It shouldn't have (deleted paths.[5])
  |> It shouldn't have (deleted paths.[6])
  |> It shouldn't have (deleted paths.[7])
  |> Verify

[<Scenario>]
let ``Yank folder should delete entire folder`` () =
  let src = @"C:\a\b"
  let job = src |> Item.yank DirectoryMode |> mkJob
  let paths = [   @"C:\a\c\f1.doc"
                  @"C:\a\d\f\f1.doc"
                  @"C:\a\b\f1.doc"
                  @"C:\a\b\c\f2.doc"
                  @"C:\a\b\c\f3.doc"
                  @"C:\a\b\c\foo.doc"
                  @"C:\a\b\c\p3.doc"
                  @"C:\a\b\c\e3.doc"
                  @"C:\a\b\c\f4.pdf"
                  @"C:\a\b\c\d\f5.doc" ]

  let provider = mkTestProvider paths
  let server = new IOServer(provider)

  Given (server, job)
  |> When running_job
  |> It shouldn't have (deleted @"C:\a\c")
  |> It shouldn't have (deleted @"C:\a\d")
  |> It shouldn't have (deleted @"C:\a\f")
  |> It should have (deleted @"C:\a\b")
  |> Verify

[<Scenario>]
let ``Copy file should use correct paths`` () =
  let src = @"C:\a\b\f1.txt"
  let dst = @"C:\e\f\g\f2.doc"
  let job = Item.copy FileMode (src, dst, true, []) |> mkJob

  Given (mkServer [@"C:\a\b\f1.txt"], job)
  |> When running_job
  |> Called <@fun x -> x.Copy@> (src, dst)
  |> Verify

[<Scenario>]
let ``Copy dir should create directory structure`` () =
  let src = @"C:\a\b"
  let dst = @"C:\e\f"
  let srcPath path = Path.combine src path
  let dstPath path = Path.combine dst path
  let job = Item.copy DirectoryMode (src, dst, true, []) |> mkJob
  let paths = [ @"f1.txt"
                @"c\f2.txt"
                @"d\f3.txt"
                @"c\d\f4.txt" ]                   
  Given (paths |> List.map srcPath |> mkServer, job)
  |> When running_job
  |> Called <@fun x -> x.Copy@>(srcPath paths.[0], dstPath paths.[0])
  |> Called <@fun x -> x.Copy@>(srcPath paths.[1], dstPath paths.[1])
  |> Called <@fun x -> x.Copy@>(srcPath paths.[2], dstPath paths.[2])
  |> Called <@fun x -> x.Copy@>(srcPath paths.[3], dstPath paths.[3])
  |> Verify

[<Scenario>]
let ``Copy dir should copy source inside existing directory`` () =
  let src = @"C:\a\b"
  let dst = @"C:\e\f"
  let job = Item.copy DirectoryMode (src, dst, true, []) |> mkJob
  let paths = [ @"C:\a\b\f1.txt"
                @"C:\a\b\c\f2.txt"
                @"C:\e\f\" ]
  Given (mkServer paths, job)
  |> When running_job
  |> Called <@fun x -> x.Copy@>(paths.[0], @"C:\e\f\b\f1.txt")
  |> Called <@fun x -> x.Copy@>(paths.[1], @"C:\e\f\b\c\f2.txt")
  |> Verify
  
[<Scenario>]
let ``Copy dir should copy source as non-existing directory`` () =
  let src = @"C:\a\b"
  let dst = @"C:\e\f"
  let job = Item.copy DirectoryMode (src, dst, true, []) |> mkJob
  let paths = [ @"C:\a\b\f1.txt"
                @"C:\a\b\c\f2.txt" ]
  Given (mkServer paths, job)
  |> When running_job
  |> Called <@fun x -> x.Copy@>(paths.[0], @"C:\e\f\f1.txt")
  |> Called <@fun x -> x.Copy@>(paths.[1], @"C:\e\f\c\f2.txt")
  |> Verify

[<Scenario>]
let ``Copy should copy all matched files to destination directory`` () =
  let src = @"C:\a\b\*\g\f?.p*"
//  let src = @"C:\a\b"
  let dst = @"C:\e\f"
  let job = Item.copy PatternMode (src, dst, true, []) |> mkJob 
  let paths = [ @"C:\a\b\c\g\f1.pdf"
                @"C:\a\b\c\f\g\f2.pdb"
                @"C:\a\b\c\f\g\h\g\f3.tmp"  // n
                @"C:\a\b\c\f\g\h\h\f4.pdf"  // n
                @"C:\a\b\c\f\g\h\g\f5.pdf"
                @"C:\e\f\f5.pdf" ]
  let fdst path = Path.combine dst (Path.file path)
  
  Given (mkServer paths, job)
  |> When running_job
  |> Called <@fun x -> x.Copy@>(paths.[0], fdst paths.[0])
  |> Called <@fun x -> x.Copy@>(paths.[1], fdst paths.[1])
  |> Called <@fun x -> x.Copy@>(paths.[4], fdst paths.[4])
  |> Verify
  

  


