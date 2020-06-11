#r "packages/FAKE/tools/FakeLib.dll"; open Fake 
#load "build-tools/version.fsx"; open Version
#load "build-tools/pact.fsx"; open Pact
open System.IO
open Fake.VSTest

let nugetPath = findNuget (".." @@ ".nuget")
let apiClientBuildNumber = environVarOrDefault "BUILD_NUMBER" "0"
let apiClientVersion = getBuildParamOrDefault "API_CLIENT_VERSION" (sprintf "0.0.%s" apiClientBuildNumber)
let apiClientVersionSuffix = getBuildParamOrDefault "API_CLIENT_VERSION_SUFFIX" ""
let branchName = getBuildParamOrDefault "branch" "master"
let outputDir = "../out"
let pactDir = "../pact"
let srcDir = "../src"
let pactVersion = generatePactVersionNumber
let solutionDir = srcDir + "/JobStreet.AdPostingApi.Client.sln"
let testDir = srcDir + "/JobStreet.AdPostingApi.Client.Tests"
let clientDir = srcDir + "/JobStreet.AdPostingApi.Client"
let assemblyInfoFile = clientDir + "/Properties/AssemblyInfo.cs"
let packagingRoot = outputDir + "/artifacts"

Target "Clean" (fun _ ->
    CleanDirs [outputDir; pactDir; testDir + @"/bin/"]
)

Target "RestorePackages" (fun _ -> 
     solutionDir
     |> RestoreMSSolutionPackages (fun p ->
         { p with
             ToolPath = nugetPath
             OutputPath = srcDir + "/packages"
             Retries = 4 })
)

Target "UpdateVersion" (fun _ ->
    let replaceInfoVersion = [
        ( "\"0.15.630.1108-commitHashPlaceholder-commitBranchPlaceholder\"", ("\"" + apiClientVersion + apiClientVersionSuffix + "\""));
        ( "\"0.15.630.1108\"", ("\"" + apiClientVersion + "\"")) ]
    ReplaceInFiles replaceInfoVersion [ assemblyInfoFile ]
)

Target "Build" (fun _ ->
    !! solutionDir
      |> MSBuildRelease "" "Build"
      |> Log "AppBuild-Output: "
)

Target "Test" (fun _ ->
   !! (testDir + "/bin/**/*.Tests.dll")
      |> VSTest (fun p -> { p with TestAdapterPath = "../src/packages/xunit.runner.visualstudio.2.1.0/build/_common/" })
)

Target "NuGet" (fun _ ->
    let nugetVersion = apiClientVersion + apiClientVersionSuffix
    CreateDir packagingRoot

    NuGet (fun p -> 
        {p with
            ToolPath = nugetPath
            OutputPath = packagingRoot
            WorkingDir = clientDir
            Version = nugetVersion
            Files = [ (@"bin/Release/JobStreet.AdPostingApi.Client.dll", Some "lib/net452", None) ]
            Publish = false }) 
            (srcDir + "/JobStreet.AdPostingApi.Client/JobStreet.AdPostingApi.Client.nuspec")

    trace (sprintf "##teamcity[buildNumber '%s']" nugetVersion)
)

Target "PactMarkdown" (fun _ ->
   let pact = tryFindFileOnPath "pact.bat"
   let errorCode = match pact with
                   | Some p -> Shell.Exec(p, "docs --pact-dir=" + pactDir + " --doc-dir=" + outputDir)
                   | None -> -1

   if errorCode <> 0 then failwithf "pact.bat returned with a non-zero exit code"

   CopyFile (pactDir + "/README.md") (outputDir + "/markdown/Ad Posting API Client - Ad Posting API.md")
)

Target "UploadPact" (fun _ ->
    (!! (pactDir + "/*.json")) |> PublishPact (pactVersion, branchName)
)

"Clean"
   ==> "RestorePackages"
   ==> "UpdateVersion"
   ==> "Build"
   ==> "Test"

"Test"
   ==> "PactMarkdown"
   ==> "UploadPact"

"Test"
   ==> "NuGet"

RunTargetOrDefault "NuGet"
