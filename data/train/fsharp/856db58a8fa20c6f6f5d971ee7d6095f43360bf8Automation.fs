namespace Process.ToolSet.GitHub

open System

open Process.ToolSet
open Common

[<RequireQualifiedAccess>]
module Automation =

    let private ensureAttachLabelsRequest repo labels obj =
        match obj with
        | Composite o -> let isFound = o |> Array.exists(function
                                           | LabelsAttachRequest _ | RequestSetInBody(LabelsAttachRequest _, _) -> true
                                           | _ -> false)
                         (if isFound then obj else obj |> resultBeside (Request.attachLabels repo)) |> Request.pAttachLabels (labels |> set)
        | o -> o

    let rec private detachLabelsRequests repo (labels : string list) obj =
        match obj, labels with
        | Composite _, head :: tail -> obj |> resultBeside (Request.dettachLabel repo head) |> detachLabelsRequests repo tail
        | _, _ -> obj

    let private attachDettachLabels (ad: string list * string list) repo obj =
        obj |> match ad with
               | a, d -> (match a with
                          |_::_ -> ensureAttachLabelsRequest repo (a |> Set.ofList)
                          | _ -> fun x -> x) >> 
                         (match d with
                          |_::_ -> detachLabelsRequests repo (d)
                          | _ -> fun x -> x)

    let private getIntTresholdAttachDettachLabels (table: (int * string) list) (i: int) =
        table |> List.sortByDescending (fun (x, _) -> x)
              |> List.partition (fun (x, _) -> i > x)
              |> function 
                 | ((_, hs) :: t, d) -> [hs], t |> List.append d |> List.map (fun (_, s) -> s)
                 | (_, d) -> [], d |> List.map (fun (_, s) -> s)

    let private dettachAllLabelsInTable (table: ('a * string) list) repo obj =
        obj |> detachLabelsRequests repo (table |> List.map (fun (_, s) -> s))

    /// ... use composite : manage conflict labels
    let rec manageConflictLabels repo labelName obj =
        match obj with
        | Composite o -> let traversed = Composite(o |> Array.map (manageConflictLabels repo labelName))
                         match (Analysis.mergeable traversed) with
                         | Some false -> traversed |> ensureAttachLabelsRequest repo (set [labelName])
                         | Some true -> traversed |> detachLabelsRequests repo [labelName]
                         | None -> traversed
        | o -> o

    /// ... use composite : manage labels by file name marker to label name table
    let rec manageFileNameMarkerLabels repo (table: (string * string) list) obj =
        let getAttachDettachLabels (s: string Set) =
            table |> List.partition (fun (m,_) -> s |> Set.exists (fun x -> x |> String.contains m))
                  |> fun (a, d) -> a |> List.map (function | _, l -> l),
                                   d |> List.map (function | _, l -> l)

        match obj with
        | Composite o -> let traversed = Composite(o |> Array.map (manageFileNameMarkerLabels repo table))
                         match (Analysis.fileNames traversed) with
                         | s when s.IsEmpty -> traversed
                         | s -> attachDettachLabels (getAttachDettachLabels s) repo traversed
        | o -> o

    /// ... use composite : manage iteration labels by iteration threshold to label name teble
    let rec manageIterationLabels repo (table: (int * string) list) obj =
        match obj with
        | Composite o -> let traversed = Composite(o |> Array.map (manageIterationLabels repo table))
                         match (Analysis.iteration traversed) with
                         | Some i -> attachDettachLabels (getIntTresholdAttachDettachLabels table i) repo traversed
                         | None -> traversed
        | o -> o

    /// ... use composite : manage gap labels by gap duration threshold (days) to label name
    /// table and reviewer logins list.
    /// exclusion list is for labels that allow pr escape gap labeling.
    let rec manageGapLabels repo (table: (int * string) list) (exclusion: string list) (reviewers: string list) obj =
        match obj with
        | Composite o -> let traversed = Composite(o |> Array.map (manageGapLabels repo table exclusion reviewers))
                         match Analysis.gap reviewers exclusion traversed with
                         | Some d -> attachDettachLabels (getIntTresholdAttachDettachLabels table (d|> fun x -> x.TotalDays |> int)) repo traversed
                         | None -> traversed

        | o -> o

    /// ... use composite : manage delay labels by delay threshold (days) to label name
    /// table and reviewer logins list.
    /// exclusion list is for labels that allow pr escape delay labeling.
    let rec manageDelayLabels repo (table: (int * string) list) (exclusion: string list) (reviewers: string list) obj =
        match obj with
        | Composite o -> let traversed = Composite(o |> Array.map (manageDelayLabels repo table exclusion reviewers))
                         match Analysis.delay reviewers exclusion traversed with
                         | Some d -> attachDettachLabels (getIntTresholdAttachDettachLabels table (d |> fun x -> x.TotalDays |> int)) repo traversed
                         | None -> traversed
        | o -> o