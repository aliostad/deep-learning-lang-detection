[<RequireQualifiedAccess>]
module CommandFactory

open System;

type CommandCreationError = 
    | CommandNotDefined of string
    | CommandNotProvided
    | EnvironmentVariableNotSet of string
    

type Result<'TSuccess, 'TError> = 
     | Success of 'TSuccess
     | Error of 'TError


let getEnvironmentVariables key = 
    match Environment.GetEnvironmentVariable(key) with
    | v when v = null -> Error (EnvironmentVariableNotSet key)
    | v -> Success v



let normalize result =
    Error (
            [for item in  result do
                match item with
                |Error e ->  yield e
                |_ -> ()])

let buildParameterEnvironmentVarriables = ["GUT_URI"; "BRANCH"; "BUILD_SCRIPT"; "TARGETS"]


let extractParameter i results = match results |> Seq.nth i  with
                                 | Success s -> s
                                 | _ -> (failwith "Unexpected Error")

let extractGitUri (s :string) : BuildProcess.GitUri = s
let extractBranch (s :string) : BuildProcess.Branch = s
let extractScript (s :string) : BuildProcess.Script = s
let extractTarget (s :string) : BuildProcess.Target seq = s.Split([|','|]) |> Array.toSeq



let createBuildParameters = match buildParameterEnvironmentVarriables |> Seq.map getEnvironmentVariables with
                            | r when r |> Seq.filter (fun c -> match c with | Error _ -> true | _ -> false) |> Seq.isEmpty |> (not) -> normalize r
                            | r -> Success (extractGitUri(r |> extractParameter 0),  extractBranch(r |> extractParameter 1), extractScript(r |> extractParameter 2), extractTarget(r |> extractParameter 3))                             


let bind a b = 
    match a with 
    | Success s     -> b s
    | Error r       -> Error r

let createBuild parameters =
    Success (BuildProcess.Build parameters) 

let createBuildCommand =
    bind createBuildParameters createBuild

let create argv = 
    match argv with 
    | a when a |> Seq.isEmpty -> Error [CommandNotProvided]
    | a when a |> Seq.head = "Build" -> createBuildCommand
    | _ -> Error [(CommandNotDefined (argv |> Seq.head))]
    