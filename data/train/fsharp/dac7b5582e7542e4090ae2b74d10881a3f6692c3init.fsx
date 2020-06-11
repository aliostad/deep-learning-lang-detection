#r "FakeLib.dll"

open System
open Fake

let slnFile = environVarOrFail "sln-path"
let rootPath = directory slnFile

Target "CreatePushScriptLink" <| fun() ->
    let fakePath =
        !! @"..\..\FAKE.*\tools\FAKE.exe"
        |> SetBaseDir __SOURCE_DIRECTORY__
        |> Seq.head
        |> FullName

    let scriptPath =
        match __SOURCE_DIRECTORY__ @@ "push-all.fsx" with
        | dir when dir.StartsWith rootPath -> ".\\" + dir.Substring(rootPath.Length + 1)
        | x -> x


    let content = """$fakeExe = (gci .\packages\FAKE.*\tools\FAKE.exe)[0]
$scriptPath = (gci .\packages\PackProj.*\scripts\push-all.fsx)[0]

# If you use `nuget setApiKey` then set
$apiKey = ""
# else
# $apikey = "XXXXXXXXXXX"
if ($apiKey) { $apiKeyArg = "-ev api-key $apiKey" } else { $apiKeyArg = "" }

$source = "https://api.nuget.org/v3/index.json"

& $fakeExe $scriptPath -ev source $source $apiKeyArg
"""
    let linkPath = rootPath @@ "PackProj.PushPackages.ps1"
    if not <| System.IO.File.Exists linkPath
    then WriteStringToFile false linkPath content

RunTargetOrDefault "CreatePushScriptLink"
