#r "./packages/FAKE/tools/FakeLib.dll"

open Fake

let libsDir = "./libs"

Target "Clean" (fun _ ->
    CleanDirs [libsDir]
)

Target "Build" (fun _ ->
    !! "./src/**/*.fsproj"
    |> MSBuildRelease "" "Build"
    |> ignore

    // !! "./src/FsAutocomplete.Functions/bin/Release/FsAutoComplete.Functions.dll"
    // |> Copy "./FsAutoComplete"

    !! "./src/FsAutocomplete.Functions/bin/Release/*.dll"
    |> Copy "./FsAutoComplete"

    !! "./src/FsAutocomplete.Functions/bin/Release/*.dll"
    |> Copy "./bin"

)


"Clean"
  ==> "Build"

RunTargetOrDefault "Build"