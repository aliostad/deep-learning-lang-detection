#I @"packages/FAKE/tools/"
#r @"packages/FAKE/tools/FakeLib.dll"

open Fake
open System
open Fake.Azure
open System.IO

Environment.CurrentDirectory <- __SOURCE_DIRECTORY__
let solutionFile  = "SameGame.sln"
let testAssemblies = "tests/**/bin/Release/*Tests*.dll"
let buildDir = "./bin/"

let (|Fsproj|Csproj|Vbproj|) (projFileName:string) = 
    match projFileName with
    | f when f.EndsWith("fsproj") -> Fsproj
    | f when f.EndsWith("csproj") -> Csproj
    | f when f.EndsWith("vbproj") -> Vbproj
    | _                           -> failwith (sprintf "Project file %s not supported. Unknown project type." projFileName)

Target "CopyBinaries" (fun _ ->
    !! "src/**/*.??proj"
    |>  Seq.map (fun f -> 
                    let fromDir = (System.IO.Path.GetDirectoryName f) @@ "bin/Release"
                    let toDir = "bin" @@ (System.IO.Path.GetFileNameWithoutExtension f)

                    if System.IO.Directory.Exists(fromDir)
                    then (fromDir, toDir)
                    else ((System.IO.Path.GetDirectoryName f) @@ "bin", toDir))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))
)


Target "Clean" (fun _ ->
    CleanDirs ["bin"; "temp"]
)

Target "Build" (fun _ ->
    solutionFile
    |> MSBuildHelper.build (fun defaults ->
        { defaults with
            Verbosity = Some Minimal
            Targets = [ "Build" ]
            Properties = [ "Configuration", "Release"
                           "OutputPath", Kudu.deploymentTemp ] })
    |> ignore)

Target "RunTests" (fun _ ->
    !! testAssemblies
    |> NUnit (fun p ->
        { p with
            DisableShadowCopy = true
            TimeOut = TimeSpan.FromMinutes 20.
            OutputFile = "TestResults.xml" })
)

Target "StageWebsiteAssets" (fun _ ->
    let blacklist =
        [ "typings"
          ".fs"
          ".config"
          ".references"
          "tsconfig.json" ]
    let shouldInclude (file:string) =
        blacklist
        |> Seq.forall(not << file.Contains)
    Kudu.stageFolder (Path.GetFullPath @"src\SameGame.Suave\web") shouldInclude)

Target "Deploy" Kudu.kuduSync

"Clean"
  ==> "StageWebsiteAssets"
  ==> "Build"
  //==> "CopyBinaries"
  //==> "RunTests"
  ==> "Deploy"

RunTargetOrDefault "Deploy"
