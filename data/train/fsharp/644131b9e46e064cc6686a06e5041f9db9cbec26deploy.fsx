// include Fake lib
#r @"tools/FAKE/tools/FakeLib.dll"
open Fake
open OctoTools

Target "Release" (fun _ ->
    let release = { releaseOptions with Project = "FileNewProject IIS" }
    let deploy  = { deployOptions with
                        Project = "FileNewProject IIS"
                        DeployTo = "Staging" }

    Octo (fun octoParams ->
        { octoParams with
            ToolPath = "./tools/octopustools"
            Server = { Server = "http://r2octopus.cloudapp.net/api"; ApiKey = "API-LLTNNXWW5OQLD6CAWBSDJJONCNW" };
            Command  = CreateRelease (release, Some deploy) }
    )
)

// start build
RunTargetOrDefault "Release"