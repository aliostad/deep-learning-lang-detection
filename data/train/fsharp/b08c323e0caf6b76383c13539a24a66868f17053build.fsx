// include Fake lib
#r @"D:\apps\fake\FakeLib.dll"
open Fake 

// Properties
let buildDir = "."

// Default target
Target "BuildApp" (fun _ ->
    !! "NPloy.Samples.sln"
      |> MSBuildRelease buildDir "Build"
      |> Log "AppBuild-Output: "
)

Target "CreatePackage" (fun _ ->
    // Copy all the package files into a package folder
//    CopyFiles packagingDir allPackageFiles

    NuGet (fun p -> 
        {p with
            OutputPath = @"d:\temp\packages"
            WorkingDir = @"NPloy.Samples.WindowsService"
        }) 
            "NPloy.Samples.WindowsService\NPloy.Samples.WindowsService.nuspec"
)

// start build
RunTargetOrDefault "BuildApp" 



