module OptionsValidatorTests

open System
open System.IO
open System.Diagnostics

open NaturalSpec
open NUnit.Framework

open GabeSoft.FOPS.Core
open GabeSoft.FOPS.Test

let opts args = new Options(args)
let validating opts =
  printMethod "\n"
  let log = new LogImpl()
  let validator = new OptionsValidator(log)
  validator.CreateJobs opts

let expected_jobs expected (jobs:Job list) =
  let actual = jobs |> List.map (fun j -> j.Id) |> List.sort
  printMethod actual  
  actual = expected

let expected_base_paths src dst (jobs:Job list) =
  let job = List.head jobs
  let srcOk (path:string) = path.StartsWith(src)
  let dstOk (path:string) = path.StartsWith(dst)
  let actual = 
    job.Items 
    |> List.map (function
      | Copy (s, d, _, _, _)  -> s, d
      | Link (s, d, _, _, _)  -> s, d
      | Yank (s, _)           -> s, dst)
    |> List.map (fun (s, d) -> srcOk s && dstOk dst)
  printMethod actual
  actual |> List.forall id

let check_yank src mode = function
  | Yank (s, c)   -> s = src && c = mode 
  | _             -> false

let check_copy src dst force mode = function
  | Copy (s, d, f, _, c)  -> s = src && d = dst && f = force && c = mode
  | _                     -> false

let check_link src dst force mode = function
  | Link (s, d, f, _, c)  -> s = src && d = dst && f = force && c = mode
  | _                     -> false

let expected_type (check: list<Item -> bool>) (jobs: Job list) = 
  let items = (List.head jobs).Items
  printMethod String.Empty
  List.map2 (fun f e -> f e) check items |> List.forall id

[<Scenario>]
let ``File - creates all jobs`` () =
  Given (opts ["-f=Files/jobs2.xml"])
  |> When validating
  |> It should have (expected_jobs ["j1"; "j2"; "j3"])
  |> Verify

[<Scenario>]
let ``File - filters on job id`` () =
  Given (opts ["-f=Files/jobs2.xml"; "-j=j2"])
  |> When validating
  |> It should have (expected_jobs ["j2"])
  |> Verify

[<Scenario>]  
let ``File - overrides base-src and base-dst`` () =
  Given (opts ["-f=Files/jobs5.xml"; @"-b=C:\Temp1"; @"-B=C:\Temp2"])
  |> When validating
  |> It should have (expected_base_paths @"C:\Temp1" @"C:\Temp2")
  |> Verify

[<Scenario>]
let ``Delete - has expected type and source`` () =
  let src = @"C:\a\b\*\c.txt"
  Given (opts ["-d"; src])
  |> When validating
  |> It should have (expected_type [check_yank src PatternMode])
  |> Verify

[<Scenario>]
let ``Delete dir - has expected type and source`` () =
  let src = @"C:\a\b"
  Given (opts ["-D"; src])
  |> When validating
  |> It should have (expected_type [check_yank src DirectoryMode])
  |> Verify

[<ScenarioTemplate("-c")>]
[<ScenarioTemplate("-l")>]
let ``Copy - has expected type and paths`` (arg) =
  let check_funs = Map.ofList ["-c", check_copy; "-l", check_link]
  let fn = check_funs.[arg]
  let src = @"C:\a\?*\b\f?.p*"
  let dst = @"F:\Temp"
  Given (opts [arg; src; dst; "-F"])
  |> When validating
  |> It should have (expected_type [fn src dst true PatternMode])
  |> Verify

[<ScenarioTemplate("--copyf")>]
[<ScenarioTemplate("--linkf")>]
let  ``Copy file - has expected type and paths`` (arg) =
  let check_funs = Map.ofList ["--copyf", check_copy; "--linkf", check_link]
  let fn = check_funs.[arg]
  let src = @"C:\a\b\f1.doc"
  let dst = @"C:\a\c\f2.txt"
  Given (opts [arg; src; dst])
  |> When validating
  |> It should have (expected_type [fn src dst false FileMode])
  |> Verify

[<ScenarioTemplate("-C")>]
[<ScenarioTemplate("-L")>]
let ``Copy dir - has expected type and paths`` (arg) =
  let check_funs = Map.ofList ["-C", check_copy; "-L", check_link]
  let fn = check_funs.[arg]
  let src = @"C:\a\b\"
  let dst = @"C:\a\c\"
  Given (opts [arg; src; dst])
  |> When validating
  |> It should have (expected_type [fn src dst false DirectoryMode])
  |> Verify
  
[<ScenarioTemplate("-m")>]
[<ScenarioTemplate("-M")>]
let ``Move file - has expected job items`` (arg) =
  let cmodes = Map.ofList ["-m", FileMode; "-M", DirectoryMode]
  let ymodes = Map.ofList ["-m", PatternMode; "-M", DirectoryMode]
  let src = @"C:\a\b\f1"
  let dst = @"C:\a\c\f2"
  Given (opts [arg; src; dst; "-F"]) 
  |> When validating
  |> It should have (expected_type [ check_copy src dst true cmodes.[arg]
                                     check_yank src ymodes.[arg] ])
  |> Verify  
