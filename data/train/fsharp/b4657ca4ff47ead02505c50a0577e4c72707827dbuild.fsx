#r "./packages/FAKE/tools/FakeLib.dll"
open Fake
 
let buildDir = "./bin/"
let targetSln = ["./MvvmCross.FSharp.sln"]

let coreDll = "./bin/Release/MvvmCross.FSharp.dll"
let iOSDll = "./bin/Release/MvvmCross.FSharp.iOS.dll"
let droidDll = "./bin/Release/MvvmCross.FSharp.Droid.dll"

let copyOperations = [
  ("./build/lib/portable-net45+win+wpa81+wp80/", [ coreDll ])
  ("./build/lib/Xamarin.iOS10/", [ coreDll ; iOSDll ])
  ("./build/lib/MonoAndroid10/", [ coreDll ; droidDll ])
]
 
// Targets
Target "Clean" (fun _ -> CleanDir buildDir)
Target "Build" (fun _ -> MSBuildRelease "" "" targetSln |> Log "Build: ")
Target "Copy" (fun _ ->
  copyOperations
  |> Seq.iter (fun tuple ->
    let destination = fst tuple 
    CreateDir destination
    let copyFn = CopyFile destination
    tuple
    |> snd
    |> Seq.iter copyFn
  )
)

// Dependencies
"Clean"
==> "Build"
==> "Copy"

RunTargetOrDefault "Build"