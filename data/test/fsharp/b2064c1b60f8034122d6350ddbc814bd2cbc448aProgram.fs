namespace ProcessSample.GitHub

open System
open System.Configuration
open System.IO

open FSharpSnippets
open Newtonsoft.Json
open Newtonsoft.Json.Linq
open RestSharp
open RestSharp.Authenticators

open Process.ToolSet
open Process.ToolSet.GitHub
open Process.ToolSet.GitHub.Common

module Program =

    [<EntryPoint>]
    let main argv =

        let configPath = ConfigurationManager.AppSettings.["configJsonPath"]
        let config = JObject.Parse(File.ReadAllText(configPath))
        let repo = config.SelectToken("$.repository") |> string
        let user = config.SelectToken("$.user") |> string
        let reviewers = config.SelectToken("$.reviewers") |> string |> JArray.Parse |> Seq.map string |> List.ofSeq
        let fileNameMarkerLabelsTable = config.SelectToken("$.filename_marker_labels") |> string |> JArray.Parse
                                         |> Seq.map (fun o -> o.SelectToken("$.marker") |> string, o.SelectToken("$.label") |> string)
                                         |> List.ofSeq
        let iterThresholdTable = config.SelectToken("$.iteration_labels") |> string |> JArray.Parse
                                         |> Seq.map (fun o -> o.SelectToken("$.threshold") |> int, o.SelectToken("$.label") |> string)
                                         |> List.ofSeq
        let gapThresholdTable = config.SelectToken("$.gap_labels") |> string |> JArray.Parse
                                         |> Seq.map (fun o -> o.SelectToken("$.threshold") |> int, o.SelectToken("$.label") |> string)
                                         |> List.ofSeq
        let gapDelayExclusionLabels = config.SelectToken("$.gap_delay_exclusion_labels") |> string |> JArray.Parse |> Seq.map string |> List.ofSeq
        let delayThresholdTable = config.SelectToken("$.delay_labels") |> string |> JArray.Parse
                                         |> Seq.map (fun o -> o.SelectToken("$.threshold") |> int, o.SelectToken("$.label") |> string)
                                         |> List.ofSeq
        let conflictLabel = config.SelectToken("$.conflict_label") |> string

        let client = new RestClient("https://api.github.com")
        client.Authenticator <- new HttpBasicAuthenticator(user, (printf "User password: "; Console.readPassword()))

        let showAnalysis o =
            let rec show = function
                | Composite s as c -> s |> Array.iter show
                                      match Analysis.issueNumber c with
                                      | Some i -> printf "#%s " i
                                                  match Analysis.iteration c with
                                                  | Some i -> printf "iter %i; " i
                                                  | None -> () 
                                                  match Analysis.mergeable c with
                                                  | Some m -> printf "%s; " (if m then "mergeable" else "conflict")
                                                  | None -> printf "busy; "
                                                  match Analysis.gap reviewers gapDelayExclusionLabels c, Analysis.delay reviewers gapDelayExclusionLabels c with
                                                  | Some i, _ when i.TotalHours > 0. -> printf "gap %i hours; " (i.TotalHours |> int)
                                                  | _, Some i when i.TotalHours > 0. -> printf "delay %i hours; " (i.TotalHours |> int)
                                                  | _ -> ()
                                                  match Analysis.labelNames c with
                                                  | Some l -> printf "%s" (String.Join ("; ", l |> Set.intersect (gapDelayExclusionLabels |> set)))
                                                  | None -> ()
                                                  printfn ""
                                      | None -> ()
                | _ -> ()
            show o
            o

        let scenario = Request.readPrs repo >> Request.pOpen
                       >> Request.allPages (Json.toIssueNumbers reviewers)
                       >> Request.execute client
                       >> resultInComposite (resultBeside (Request.readLabels repo))
                       >> resultBeside (Request.readPr repo)
                       >> resultBeside (Request.readFiles repo)
                       >> resultBeside (Request.readCommits repo)
                       >> resultBeside (Request.readPrComments repo)
                       >> resultBeside (Request.readIssueComments repo)
                       >> Request.execute client
                       >> Json.toLabelNames
                       >> Json.toLastCommitDate
                       >> Json.toFileNames
                       >> resultBeside (Json.toPrMergeable)
                       >> resultBeside (Json.toPrIteration)
                       >> resultBeside (Json.toLastCommentLoginDate)
                       >> Automation.manageConflictLabels repo conflictLabel
                       >> Automation.manageFileNameMarkerLabels repo fileNameMarkerLabelsTable
                       >> Automation.manageIterationLabels repo iterThresholdTable
                       >> Automation.manageGapLabels repo gapThresholdTable gapDelayExclusionLabels reviewers
                       >> Automation.manageDelayLabels repo delayThresholdTable gapDelayExclusionLabels reviewers
                       >> Request.pLabelsCleanup
                       >> Request.execute client

        let res = (scenario >> showAnalysis) ()

        printf "Finished. Press any key..."
        Console.ReadKey() |>  ignore
        0 // exit code
