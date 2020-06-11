#r @"packages/build/FAKE/tools/FakeLib.dll"
open Fake
open System
open System.Diagnostics
open System.IO

let basePath p =
  __SOURCE_DIRECTORY__ @@ p

let deployDir = basePath "fake_deploy"
let buildDir = basePath "bin"

Target "RestorePackages" (fun _ ->
    RestorePackages()
)

Target "Clean" (fun _ ->
    ensureDirectory buildDir
    ensureDirectory deployDir
    CleanDirs ["bin"]
)

Target "Build" (fun _ ->
  !! "MailTester.sln"
  |> MSBuildRelease "" "Rebuild"
  |> ignore
)

Target "CopyBinaries" (fun _ ->
    !! "**/*.??proj"
    -- "**/*.shproj"
    |>  Seq.map (fun f -> ((Path.GetDirectoryName f) @@ "bin/Release", "bin" @@ (Path.GetFileNameWithoutExtension f)))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))
)

Target "BuildAll" DoNothing

let packFakeDeploy () =
  XCopyHelper.XCopy (__SOURCE_DIRECTORY__ @@ "packages" @@ "build" @@ "FSharp.Data" @@ "lib" @@ "net40") (buildDir @@ "packages" @@ "FSharp.Data")
  XCopyHelper.XCopy (__SOURCE_DIRECTORY__ @@ "packages" @@ "build" @@ "FAKE" @@ "tools") (buildDir @@ "packages" @@ "FAKE")
  (__SOURCE_DIRECTORY__ @@ "Deployment" @@ "deployService.fsx") |> CopyFile (buildDir @@ "deploy.fsx")
  (__SOURCE_DIRECTORY__ @@ "Deployment" @@ "ServiceManifest.json") |> CopyFile (buildDir @@ "ServiceManifest.json")

  WriteFile (buildDir @@ "refs.fsx")
    [ """#r @"packages/FAKE/FakeLib.dll" """
      """#r @"packages/FSharp.Data/FSharp.Data.dll" """ ]
  NuGet (
    fun p ->
      { p with
          Authors = ["rflechner"]
          Project = "MailTest"
          Title = "MailTest"
          Description = "REST service checking email validity on their SMTP"
          OutputPath = deployDir
          WorkingDir = buildDir
          Version = "1.0" //TODO: get version of sprint
          Publish = false
          Files =
            [
              "**", Some "/", None
              //"MailTester/**", Some "/", None
              //"_deploy/**", Some "/", None
            ]
          Dependencies = [ ]
        })
      (__SOURCE_DIRECTORY__ @@ "Deployment" @@ "deploy.nuspec")

let uploadPackage url nupkg =
   ExecProcess (fun info ->
        info.FileName <- (__SOURCE_DIRECTORY__ @@ "packages" @@ "build" @@ "FAKE" @@ "tools" @@ "Fake.Deploy.exe")
        info.Arguments <- (sprintf "/deployRemote %s %s" url nupkg)
        info.WorkingDirectory <- __SOURCE_DIRECTORY__
    ) (System.TimeSpan.FromMinutes 5.) |> ignore

Target "Local-Pack-Service" (fun _ ->
  packFakeDeploy ()
)

Target "Local-Install-Service" (fun _ ->
  let nupkg = deployDir |> directoryInfo |> filesInDirMatching "*.nupkg" |> Seq.head
  uploadPackage "http://localhost:8080/fake" nupkg.FullName
)

"RestorePackages"
  ==> "Clean"
  ==> "Build"
  ==> "CopyBinaries"
  ==> "BuildAll"
  ==> "Local-Pack-Service"
  ==> "Local-Install-Service"

RunTargetOrDefault "BuildAll"
