// include Fake libs
#r "./packages/build/FAKE/tools/FakeLib.dll"

open Fake
open Fake.Testing.Expecto

// version info
let version = "0.1"  // or retrieve from CI server

Target "All" DoNothing

// Targets
Target "Clean" (fun _ ->
    CleanDirs ["bin"]
)

Target "Build" (fun _ ->
    !! "MyTypeProvider.sln"
    |> MSBuildRelease "" "Rebuild"
    |> Log "AppBuild-Output: "
)

Target "CopyBinaries" (fun _ ->
    !! "src/**/*.??proj"
    |>  Seq.map (fun f -> ((System.IO.Path.GetDirectoryName f) @@ "bin/Release", "bin" @@ (System.IO.Path.GetFileNameWithoutExtension f)))
    |>  Seq.iter (fun (fromDir, toDir) -> CopyDir toDir fromDir (fun _ -> true))

    // All Type Providers components should be in the same directory
    CopyDir "bin/MyTypeProvider" "bin/MyTypeProvider.DesignTime" (fun _ -> true)
    CopyDir "bin/MyTypeProvider" "bin/MyTypeProvider.Runtime" (fun _ -> true)
)

Target "BuildTests" (fun _ ->
    !! "MyTypeProvider.Tests.sln"
    |> MSBuildRelease "" "Rebuild"
    |> Log "AppBuild-Tests-Output: "
)

Target "Test" (fun _ ->
    !! "tests/**/bin/Release/*Tests.exe"
    |> Expecto (fun p ->
        { p with
            Parallel = false} )
)

Target "NuGet" (fun _ ->
    Paket.Pack(fun p ->
        { p with
            OutputPath = "bin"
            Version = version})
)

// Build order
"Clean"
  ==> "Build"
  ==> "CopyBinaries"
  ==> "BuildTests"
  ==> "Test"
  ==> "NuGet"
  ==> "All"

// start build
RunTargetOrDefault "NuGet"
