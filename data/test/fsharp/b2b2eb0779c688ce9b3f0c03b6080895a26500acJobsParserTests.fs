module JobsParserTests

open System
open System.Diagnostics

open NaturalSpec
open NUnit.Framework

open GabeSoft.FOPS.Core

let paths = 
   [  "Files\jobs1.xml"; "Files\jobs2.xml"; 
      "Files\jobs3.xml"; "Files\jobs4.xml"; "Files\jobs5.xml" ] 
   |> Seq.map (fun p -> Path.full p)

let file2 = paths |> Seq.skip 1 |> Seq.head
let file3 = paths |> Seq.skip 2 |> Seq.head
let file4 = paths |> Seq.skip 3 |> Seq.head
let file5 = paths |> Seq.skip 4 |> Seq.head

let checking_existence paths =
  let provider = new IOProviderImpl() :> IOProvider
  printMethod ""
  paths |> Seq.map provider.FileExists

let all_found seq =
   printMethod (Seq.toList seq)
   Seq.forall (fun p -> p) seq

let parsing file =
   printMethod file
   JobsParser.parseFile file

let expected_ids (l: Job list) =
   let ids = l |> List.map (fun j -> j.Id)
   
   printMethod ids
   ids = ["j1"; "j2"; "j3" ]

let expected_item_count (l: Job list) =
   let counts = l |> List.map (fun j -> j.Items.Length)

   printMethod counts
   counts = [3; 4; 3]

let expected_item_count_by_type (l: Job list) =
   let isCopy = function Copy _ -> true | _ -> false
   let isLink = function Link _ -> true | _ -> false
   let isYank = function Yank _ -> true | _ -> false
   let intOfBool = function | true -> 1 | false -> 0
   let countsByType (job: Job) =
      job.Items
      |> List.map (fun e -> 
            e |> isCopy |> intOfBool, 
            e |> isLink |> intOfBool, 
            e |> isYank |> intOfBool)
      |> List.fold (fun (cacc,lacc,yacc) (c,l,y) -> cacc+c, lacc+l, yacc+y) (0,0,0)
   let counts = l |> List.map countsByType

   printMethod counts
   counts = [0, 3, 0; 1, 0, 3; 3, 0, 0]

let expected_exclude_items (l: Job list) =
   let len = function 
   | Copy (_, _, _, e, _)  -> e.Length
   | Link (_, _, _, e, _)  -> e.Length
   | _                     -> 0
   let excludeCounts (job: Job) = job.Items |> List.map len |> List.sum
   let actual = l |> List.map excludeCounts
   let expected = [1; 2; 5]

   printMethod (expected, actual)
   expected = actual

let get_job_with_id id (jobs: Job list) =
   jobs |> List.find (fun j -> j.Id = id)

let expected_item_types jobs =
   let job = get_job_with_id "j3" jobs
   let actual = job.Items 
                  |> List.map (function
                     | Copy (_, _, _, e, c) -> c, e.Length
                     | Link (_, _, _, e, c) -> c, e.Length
                     | Yank (_, c)          -> c, 0)
                  |> List.sort
   let expected = [FileMode, 0; PatternMode, 2; DirectoryMode, 3] |> List.sort

   printMethod (expected, actual)
   expected = actual

let expected_src_paths jobs =
   let job = get_job_with_id "j3" jobs
   let actual = job.Items
                  |> List.map (function
                     | Copy (s, _, _, _, c)  -> s, c
                     | Link (s, _, _, _, c)  -> s, c
                     | Yank (s, _)            -> s, PatternMode)
                  |> List.sort
   let expected = [ 
      @"C:\Source\f1.txt", FileMode
      @"C:\Source\*\cache\*.doc", PatternMode
      @"C:\Source\a\b", DirectoryMode ] |> List.sort

   printMethod (expected, actual)
   expected = actual

let check_start_with items src dst =
  let srcOk (path:string) = path.StartsWith(@"C:\source")
  let dstOk (path:string) = path.StartsWith(@"C:\dest")
  items 
    |> List.map (function 
        | Copy (s, d, _, e, _)  -> srcOk s && dstOk d && List.forall srcOk e
        | Link (s, d, _, e, _)  -> srcOk s && dstOk d && List.forall srcOk e
        | Yank (s, _)           -> srcOk s)

let expected_base_paths jobs =
  let job = get_job_with_id "j4" jobs
  let ok = check_start_with job.Items @"C:\source" @"C:\dest"
  printMethod (ok)
  List.forall id ok

let expected_full_paths jobs =
  let job = get_job_with_id "j2" jobs
  let ok = check_start_with job.Items Path.cwd Path.cwd
  printMethod (ok)
  List.forall id ok

let expected_order jobs = 
  let job = get_job_with_id "j4" jobs
  let actual = job.Items |> List.map (function 
    | Copy (_, _, _, _, m)  -> "copy", m
    | Link (_, _, _, _, m)  -> "link", m
    | Yank (_, m)           -> "yank", m)
  let expected = [
    "yank", PatternMode; "yank", PatternMode; "yank", DirectoryMode;
    "copy", FileMode; "copy", DirectoryMode; "copy", PatternMode;
    "link", PatternMode;
    "copy", FileMode; "yank", FileMode;
    "copy", DirectoryMode; "yank", DirectoryMode]
  printMethod (expected.Length, actual.Length)
  expected = actual

[<Scenario>]
let ``Can find the jobs files`` () =
   Given paths
   |> When checking_existence
   |> It should be all_found
   |> Verify

[<Scenario>]
let ``Can read all jobs in file`` () =
   Given file2
   |> When parsing
   |> It should have (length 3)
   |> Verify

[<Scenario>]
let ``Can populate the ids of all parsed jobs`` () =
   Given file2
   |> When parsing
   |> It should have expected_ids
   |> Verify

[<Scenario>]
let ``Can populate the copy items for each parsed job`` () =
   Given file2
   |> When parsing
   |> It should have expected_item_count
   |> Verify

[<Scenario>]
let ``Can populate the correct copy item type`` () =
   Given file2
   |> When parsing
   |> It should have expected_item_count_by_type
   |> Verify

[<Scenario>]
let ``Can populate the copy exclude items`` () =
   Given file4
   |> When parsing
   |> It should have expected_exclude_items
   |> Verify

[<Scenario>]
let ``Can populate the copy types`` () =
   Given file4
   |> When parsing
   |> It should have expected_item_types
   |> Verify

[<Scenario>]
let ``Can populate the source paths`` () =
   Given file4
   |> When parsing
   |> It should have expected_src_paths
   |> Verify

[<Scenario>]
let ``Can populate the source and destination base paths`` () =
  Given file5
  |> When parsing
  |> It should have expected_base_paths
  |> Verify

let ``Can complete the relative paths`` () =
  Given file4
  |> When parsing
  |> It should have expected_full_paths
  |> Verify

[<Scenario>]
[<FailsWithType (typeof<ParseException>)>]
let ``Job id is a required attribute`` () =
   Given file3
   |> When parsing
   |> Verify

[<Scenario>]
let ``Can populate the items in order`` () =
  Given file5
  |> When parsing
  |> It should have expected_order
  |> Verify