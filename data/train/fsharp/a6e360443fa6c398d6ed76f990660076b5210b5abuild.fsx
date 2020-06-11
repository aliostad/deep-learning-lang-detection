#r @"packages/FAKE/tools/FakeLib.dll"
open Fake
open Fake.Testing

let outputFolder = "artifacts"

let getConfiguration = fun () ->
    match getBuildParam "target" with
    | "Release" | "Publish" -> "Release"
    | _                     -> "Debug"

Target "Clean" (fun _ ->
    CleanDir outputFolder
)

Target "Copy" (fun _ ->
    [ "LICENSE.txt"; "README.md"; 
      "Icon.png"; "Icon.svg";
      "Nuget/Install.ps1"; "Nuget/Uninstall.ps1" ]
    |> CopyFiles outputFolder
)

Target "Restore" (fun _ ->
    RestorePackages ()
)

Target "Build" (fun _ ->
    !! "*.sln"
    |> MSBuild outputFolder "Rebuild" [ "Configuration", getConfiguration () ] |> ignore
)

Target "UnitTests" (fun _ ->
    !! (outputFolder + "/*.Tests.dll")
    |> xUnit2 (fun p -> { p with Parallel = ParallelMode.All
                                 XmlOutputPath = outputFolder @@ "Tests.xml" |> Some
                                 HtmlOutputPath = outputFolder @@ "Tests.html" |> Some })
)

Target "IntegrationTests" (fun _ ->
    !! (outputFolder + "/*.IntegrationTests.dll")
    |> xUnit2 (fun p -> { p with Parallel = ParallelMode.All
                                 XmlOutputPath = outputFolder @@ "IntegrationTests.xml" |> Some
                                 HtmlOutputPath = outputFolder @@ "IntegrationTests.html" |> Some })
)

Target "NugetPackage" (fun _ ->
    !! "Nuget/*.nuspec"
    |> Seq.iter (NuGet (fun p -> { p with Version = outputFolder @@ "CodeContracts.Fody.dll" |> GetAssemblyVersionString
                                          WorkingDir = outputFolder
                                          OutputPath = outputFolder }))
)

Target "NugetPublish" (fun _ ->
    ()
)

Target "Debug" ignore

Target "Release" ignore

Target "Publish" ignore

"Clean" ==> "Build"
"Clean" ==> "Copy"

"Copy" ==> "Build"

"Restore" ==> "Build"

"Build" ==> "UnitTests"
"Build" ==> "integrationTests"

"UnitTests" ==> "NugetPackage"
"UnitTests" ==> "Debug"

"IntegrationTests" ==> "NugetPackage"
"IntegrationTests" ==> "Debug"

"NugetPackage" ==> "NugetPublish"
"NugetPackage" ==> "Release"

"NugetPublish" ==> "Publish"

RunTargetOrDefault "Debug"
