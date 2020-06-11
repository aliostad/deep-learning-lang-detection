#r @"packages/FAKE/tools/FakeLib.dll"

open System
open Fake

let buildDir = "build"
let tempDir = "temp"
let outputDir = "output"
let version = FileVersion ("packages" @@ "Alea.CUDA" @@ "lib" @@ "net40" @@ "Alea.CUDA.dll")
let suffix = match ((getBuildParam "suffix").Trim()) with "" -> None | suffix -> Some suffix

Target "Clean" <| fun _ ->
    [ buildDir; tempDir ] |> CleanDirs
    match (hasBuildParam "no-clean-output") with
    | false -> [ outputDir ] |> CleanDirs
    | true -> ()

Target "Build" <| fun _ ->
    !! "AleaGPUTest.sln"
    |> MSBuildRelease buildDir "Build"
    |> Log "Build-Output: "

Target "Test" <| fun _ ->
    !! "*.exe"
    |> SetBaseDir buildDir
    |> NUnitParallel (fun defaults ->
        { defaults with
            Framework = "net-4.0"
            TimeOut = TimeSpan.FromMinutes 10.0 } )

Target "Package" <| fun _ ->
    CleanDir tempDir
    
    let packageFileName =
        match suffix with
        | Some suffix -> sprintf "AleaGPUTest.%s.%s.zip" version suffix
        | None -> sprintf "AleaGPUTest.%s.zip" version

    // copy alea gpu tools (license manager)
    CopyDir (tempDir @@ "tools") ("packages" @@ "Alea.CUDA" @@ "tools") (fun _ -> true)

    // copy application assemblies (to both jit and aot)
    let assemblies =
        !! "*.dll"
        ++ "*.exe"
        ++ "*.config"
        |> SetBaseDir buildDir
    CopyFiles (tempDir @@ "test.jit") assemblies
    CopyFiles (tempDir @@ "test.aot") assemblies

    // copy native resources for jit test
    !! "Alea.CUDA.CT.*/**/*"
    |> SetBaseDir buildDir
    |> Seq.iter (CopyFileWithSubfolder buildDir (tempDir @@ "test.jit"))

    // copy misc stuff
    !! "paket.lock"
    ++ "posix.sh"
    |> CopyFiles tempDir

    // zip
    !! (tempDir + "/**/*")
    |> Zip tempDir (outputDir @@ packageFileName)

Target "All" DoNothing 

"Clean"
    ==> "Build"
    =?> ("Test", not <| hasBuildParam "no-test")
    ==> "Package"
    ==> "All"

RunTargetOrDefault "All"
