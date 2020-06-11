#load @"..\Repository.fsx"
#load @"..\Config.fsx"
#load @"..\Common.fsx"

open Repository
open Config
open Common
open System
open System.IO
open System.Text.RegularExpressions
open System.Diagnostics

Directory.SetCurrentDirectory __SOURCE_DIRECTORY__

let curDir = Directory.GetCurrentDirectory()
let repoDir = curDir @@ getConfigPathValue config.Repository.Path
let targetProcessUrl = getConfigValue config.TargetProcessUrl

if not (Uri.IsWellFormedUriString(targetProcessUrl, UriKind.Absolute)) then
    configFailure <| sprintf "Invalid TargetProcessUrl value '%s'." targetProcessUrl

let buildTpEntityUrl entityId = sprintf "%s/entity/%s" targetProcessUrl entityId

match getActiveBranchRemoteName repoDir with
| Success(branchName) ->
    let branchNameMatch = Regex.Match(branchName, @"^feature\/(bug|us|task)(?<EntityId>\d+).*$")
    let entityIdGroup = branchNameMatch.Groups.["EntityId"]
    if not entityIdGroup.Success then
        failure <| sprintf "Can't retrieve TargetProcess entity id for branch '%s'." branchName
    
    let entityId = entityIdGroup.Value
    let url = buildTpEntityUrl entityId
    url |> Process.Start |> ignore
| Failure(Some(message)) -> failure message
| Failure(None) -> failure "Can't get remote branch name for current repository state."