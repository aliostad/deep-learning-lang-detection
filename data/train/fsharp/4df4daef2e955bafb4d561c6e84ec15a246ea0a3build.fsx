// include Fake lib
#r @"./packages/FAKE/tools/FakeLib.dll"

open Fake
open System.IO

RestorePackages()

let apiKey = getBuildParam "apiKey"
File.WriteAllText(@"./WebToEpub/ReadabilityAuthenticationToken.txt", apiKey)

// Directories
let buildAppDir = "./build/app/"
let appSrcDir = "./WebToEpub.Website/"

Target "CleanApp" (fun _ -> CleanDir buildAppDir)

Target "BuildApp" (fun _ -> 
    !!(appSrcDir + "**/*.fsproj")
    |> MSBuildRelease buildAppDir "Build"
    |> Log "AppBuild-Output: ")

// Dependencies
"CleanApp" ==> "BuildApp"

// start build
RunTargetOrDefault "BuildApp"
