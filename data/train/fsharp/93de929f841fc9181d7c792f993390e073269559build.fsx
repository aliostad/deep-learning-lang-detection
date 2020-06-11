// include Fake lib
#r @"tools\FAKE\tools\FakeLib.dll"
open Fake
 
RestorePackages()

// Properties
let buildDir = @".\build\"
let packagesDir = @".\packages"
let releaseDir = @".\release"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; releaseDir]
)

Target "Build" (fun _ ->
    !! @"FlickrDemo/*.csproj"
      |> MSBuildRelease buildDir "Build"
      |> Log "AppBuild-Output: "
)

Target "Deploy" (fun _ ->
    !! (buildDir + "*.xap")         
        |> Copy releaseDir
)

Target "Default" (fun _ ->
    trace "Build completed"
)

// Dependencies
"Clean"  
  ==> "Build"  
  ==> "Deploy"
  ==> "Default" 
 
// start build
Run "Default"