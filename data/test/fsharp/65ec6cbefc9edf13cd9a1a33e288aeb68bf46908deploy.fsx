#r @"packages/FAKE/tools/FakeLib.dll"
open System
open System.IO
open Fake
open Fake.Git

let buildDir = "./build"
let specsDir = "./build/specs"
let docDir = "./doc"
let repoDir = "."

Target "DeployWebApp" (fun _ ->
    pushBranch repoDir "azure" "master"
)

Target "DeployWindowsDesktopAppToAzure" (fun _ ->
    let azureKey = File.ReadAllText "./azure.key"

    let result =
        ExecProcess (fun info ->
            info.FileName <- "C:/Program Files (x86)/Microsoft SDKs/Azure/AzCopy/AzCopy.exe"
            info.Arguments <- "/Source:build\\Releases /Dest:http://mufflonosoft.blob.core.windows.net/standuptimer /DestKey:" + azureKey + " /S /XO /Y /NC:1"
        ) (TimeSpan.FromMinutes 5.)

    if result <> 0 then failwith "azCopy returned with a non-zero exit code"
)

Target "UpdateDocumentation" (fun _ ->
    CleanDir docDir

    cloneSingleBranch repoDir "https://github.com/PapaMufflon/StandUpTimer.git" "gh-pages" docDir

    CopyFile (docDir + "/concordion-logo.png") (specsDir + "/results/image/concordion-logo.png")
    let indexHtml = docDir + "/Index.html"
    Copy docDir !! (specsDir + "/results/StandUpTimer/Specs/**")

    let index = File.ReadAllText indexHtml
    let modifiedIndex = index.Replace("..\..\image\concordion-logo.png", "concordion-logo.png")
    File.WriteAllText(indexHtml, modifiedIndex)

    StageAll docDir

    Commit docDir "Updated documentation"

    push docDir
)

Target "PushToOrigin" (fun _ ->
    pushBranch repoDir "origin" "master"
)

Target "Tag" (fun _ ->
    let version = GetAssemblyVersion "build\\StandUpTimer.exe"
    let versionTag = "v" + version.ToString()

    tag repoDir versionTag

    pushTag repoDir "origin" versionTag
)

Target "Default" (fun _ ->
    trace "Have fun deploying the Stand-Up Timer!!!"
)

Target "CreateInstaller" (fun _ ->
    trace "Creating installer..."
)

"DeployWebApp"
  ==> "DeployWindowsDesktopAppToAzure"
  ==> "UpdateDocumentation"
  ==> "PushToOrigin"
  ==> "Tag"
  ==> "Default"

RunTargetOrDefault "Default"