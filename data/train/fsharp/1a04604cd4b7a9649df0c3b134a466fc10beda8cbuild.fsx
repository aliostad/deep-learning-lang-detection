// include Fake lib
#r @"packages/FAKE/tools/FakeLib.dll"
open Fake

Target "Clean" (fun _ ->
    DeleteDirs ["./src/Frobnicator/Frobnicator.UI/bin/Release"; "./src/Frobnicator/Frobnicator.UI/obj/Release"]
)

// Default target
Target "Build" (fun _ ->
    MSBuildRelease "" "Build" ["./src/Frobnicator/Frobnicator.sln"] |> Log "AppBuild-Output: "
)


Target "CopyXaml" (fun _ ->
    Copy "./src/Frobnicator/Frobnicator.UI/bin/Release/Views" !!"./src/Frobnicator/Frobnicator.UI/Views/*.xaml"
)

"Clean"
    ==> "CopyXaml"
    ==> "Build"

// start build
Run "Build"