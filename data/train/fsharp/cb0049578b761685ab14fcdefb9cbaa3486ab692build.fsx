// --------------------------------------------------------------------------------------
// FAKE build script
// --------------------------------------------------------------------------------------

#r @"packages/build/FAKE/tools/FakeLib.dll"
#r @"packages/build/FSharp.Data/lib/net40/FSharp.Data.dll"

#r "System.Management.Automation"
#r "System.Core.dll"
#r "System.Xml.Linq.dll"

open System
open System.IO
open System.Xml.Linq

open Fake
open Fake.Git
open Fake.AssemblyInfoFile
open Fake.ReleaseNotesHelper
open Fake.UserInputHelper
open Fake.Testing.Expecto
open Fake.Testing.NUnit3
open System.Management.Automation

let project = "Glomulish"

let summary = "Glomulishing is the key!"

let description = summary

let configuration = "Release"
let glomulishPath = "./src/Glomulish.Host.Batch" |> FullName

let serverTestsPath = "./test/ServerTests" |> FullName
let clientTestsPath = "./test/UITests" |> FullName

let dotnetcliVersion = "2.0.0"

let mutable dotnetExePath = "dotnet"

let deployDir = "./deploy"

// Pattern specifying assemblies to be tested using expecto
let clientTestExecutables = "test/UITests/**/bin/**/*Tests*.exe"

let dockerUser = "arthis"
let dockerImageName = "glomulish"

//dockerUser shoudl be the same as dockerStoreUser
let dockerStoreUser = "artissae"
let dockerStoreOrganisation = "papeeteconsulting"
let dockerVolume = "configGlomulishAlpha"
let dockerPort = 8080

let run' timeout cmd args dir =
    if execProcess (fun info ->
        info.FileName <- cmd
        if not (String.IsNullOrWhiteSpace dir) then
            info.WorkingDirectory <- dir
        info.Arguments <- args
    ) timeout |> not then
        failwithf "Error while running '%s' with args: %s" cmd args

let run = run' System.TimeSpan.MaxValue

let runDotnet workingDir args =
    let result =
        ExecProcess (fun info ->
            info.FileName <- dotnetExePath
            info.WorkingDirectory <- workingDir
            info.Arguments <- args) TimeSpan.MaxValue
    if result <> 0 then failwithf "dotnet %s failed" args

let platformTool tool winTool =
    let tool = if isUnix then tool else winTool
    tool
    |> ProcessHelper.tryFindFileOnPath
    |> function Some t -> t | _ -> failwithf "%s not found" tool

let nodeTool = platformTool "node" "node.exe"
let npmTool = platformTool "npm" "npm.cmd"
let yarnTool = platformTool "yarn" "yarn.cmd"


do if not isWindows then
    // We have to set the FrameworkPathOverride so that dotnet sdk invocations know
    // where to look for full-framework base class libraries
    let mono = platformTool "mono" "mono"
    let frameworkPath = IO.Path.GetDirectoryName(mono) </> ".." </> "lib" </> "mono" </> "4.5"
    setEnvironVar "FrameworkPathOverride" frameworkPath


// Read additional information from the release notes document
let release =
     ReadFile "RELEASE_NOTES.md"
     |> ReleaseNotesHelper.parseReleaseNotes
let packageVersion = SemVerHelper.parse release.NugetVersion

let vboxManagePath  = "\"C:\\Program Files\\Oracle\\VirtualBox\\vBoxManage\""


let startingVM nameVM (x: Diagnostics.ProcessStartInfo)  =
    x.FileName <- vboxManagePath
    x.Arguments <- sprintf "startvm %s --type headless" nameVM
    ()

let listingVm (x: Diagnostics.ProcessStartInfo)  = 
    x.FileName <- vboxManagePath
    x.Arguments <- "list runningvms"
    ()  

let startVM nameVM =
    ExecProcessAndReturnMessages (startingVM nameVM) (TimeSpan.FromSeconds(float <| 30)) 
    |> printfn "returns %A" 

let isVmStarted nameVm =
    let result = ExecProcessAndReturnMessages listingVm (TimeSpan.FromSeconds(float <| 30)) 
    result.Messages
    |> Seq.exists (fun x-> x.Contains(nameVm))
    
let docker instruction =
    if not <| isVmStarted "default" then
        startVM "default"
    
    PowerShell.Create()
        .AddScript("$env:DOCKER_HOST=\"tcp://192.168.99.100:2376\"")
        .AddStatement().AddScript("$env:DOCKER_CERT_PATH = \"C:\\Users\\remyy\\.docker\\machine\\machines\\default\"")
        .AddStatement().AddScript("$env:DOCKER_TLS_VERIFY = 1")
        .AddStatement().AddScript("$env:NO_PROXY=\"192.168.99.100\"")
        .AddStatement().AddScript(sprintf "docker %s" instruction)
        .Invoke()
        
     
let isSuccessOr message result =
    if not <| Seq.isEmpty result then  
        printfn message
        result |> Seq.iter (printfn "-> Powershell result  : %O")
    ()

let isSuccess result =
    if not <| Seq.isEmpty result then  
        result |> Seq.iter (printfn "-> Powershell result  : %O")
    ()    

// --------------------------------------------------------------------------------------
// Clean build results

Target "Clean" (fun _ ->
    !!"src/**/bin" ++ "src/**/obj/"
        ++ "test/**/bin" ++ "test/**/obj/"
    |> CleanDirs
    CleanDirs ["bin"; "temp"; "docs/output"; deployDir; ]
)

Target "AssemblyInfo" (fun _ ->
    CreateFSharpAssemblyInfo "src/Common/AssemblyInfo.fs"
       [ Attribute.Title project
         Attribute.Product project
         Attribute.Description summary
         Attribute.Version release.AssemblyVersion
         Attribute.FileVersion release.AssemblyVersion]
)

Target "InstallDotNetCore" (fun _ ->
    dotnetExePath <- DotNetCli.InstallDotNetSDK dotnetcliVersion
)

Target "Installglomulish" (fun _ ->
    runDotnet glomulishPath "restore"
)

Target "Buildglomulish" (fun _ ->
    runDotnet glomulishPath "build"
)

Target "Run" (fun _ ->
    runDotnet glomulishPath "run"
)


// --------------------------------------------------------------------------------------
// Running and reparing docker containers
Target "StartDocker" (fun _->
    if not <| isVmStarted "default" then
        startVM "default"
)

Target "Publish" (fun _ ->
    let result =
        ExecProcess (fun info ->
            info.FileName <- dotnetExePath
            info.WorkingDirectory <- glomulishPath
            info.Arguments <- "publish -c Release -r win10-x64 -o \"" + FullName deployDir + "/win10-x64\"") TimeSpan.MaxValue
    if result <> 0 then failwith "Publish failed"

    let result =
        ExecProcess (fun info ->
            info.FileName <- dotnetExePath
            info.WorkingDirectory <- glomulishPath
            info.Arguments <- "publish -c Release -r debian-x64 -o \"" + FullName deployDir + "/xdebian-64\"") TimeSpan.MaxValue
    if result <> 0 then failwith "Publish failed"
)

Target "CreateDockerImage" (fun _ ->
    let cmdBuild = sprintf "build -t %s/%s ." dockerStoreOrganisation dockerImageName
    Console.WriteLine cmdBuild

    cmdBuild
    |> docker
    |> isSuccessOr "Docker build failed"

    let cmdClean = sprintf "rmi $(docker images -f \"dangling=true\" -q)" 
    Console.WriteLine  cmdClean

    cmdClean
    |> docker
    |> isSuccess
)

Target "RunDocker" (fun _ ->
    let cmdStopRemove = sprintf "rm $(docker stop $(docker ps -a -q --filter ancestor=%s/%s --format=\"{{.ID}}\"))" dockerStoreOrganisation dockerImageName
    Console.WriteLine  cmdStopRemove
    
    cmdStopRemove
    |> docker
    |> isSuccessOr "Docker stop and remove previous container from image failed"

    let cmdRun = sprintf "run -it -d --volumes-from %s -p %i:%i %s/%s" dockerVolume dockerPort dockerPort dockerStoreOrganisation dockerImageName
    Console.WriteLine  cmdRun

    cmdRun
    |> docker
    |> isSuccess

)


// --------------------------------------------------------------------------------------
// Release Scripts
Target "PrepareRelease" (fun _ ->
    Git.Branches.checkout "" false "master"
    Git.CommandHelper.directRunGitCommand "" "fetch origin" |> ignore
    Git.CommandHelper.directRunGitCommand "" "fetch origin --tags" |> ignore

    StageAll ""
    Git.Commit.Commit "" (sprintf "Bumping version to %O" release.NugetVersion)
    Git.Branches.pushBranch "" "origin" "master"

    let tagName = string release.NugetVersion
    Git.Branches.tag "" tagName
    Git.Branches.pushTag "" "origin" tagName

    sprintf "tag %s/%s %s/%s:%s" dockerStoreOrganisation dockerImageName dockerStoreOrganisation dockerImageName release.NugetVersion
    |> docker 
    |> isSuccessOr "Docker tag failed"
    
)




Target "Deploy" (fun _ ->
    // info.WorkingDirectory <- deployDir
    //artissae/Cerf2017
    sprintf "login --username \"%s\" --password \"%s\"" dockerStoreUser (getBuildParam "DockerPassword")
    |> docker
    |> isSuccessOr "Docker login failed"
    

    // info.WorkingDirectory <- deployDir
    sprintf "push %s/%s:%s" dockerStoreOrganisation dockerImageName release.NugetVersion
    |> docker 
    |> isSuccessOr "Docker push failed"
)

// -------------------------------------------------------------------------------------
Target "All" DoNothing

"Clean"
    ==> "InstallDotNetCore"
    ==> "Installglomulish"
    ==> "Buildglomulish"
    ==> "All"

"ALL"    
    ==> "Run"

"ALL"
    ==> "Publish"
    ==> "CreateDockerImage"
    //==> "RunDocker"    

"CreateDockerImage"
    ==> "PrepareRelease"
    ==> "Deploy"    
    


RunTargetOrDefault "All"