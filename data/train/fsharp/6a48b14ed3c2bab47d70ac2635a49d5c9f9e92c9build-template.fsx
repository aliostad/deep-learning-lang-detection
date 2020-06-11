#r @"FAKE\tools\FakeLib.dll"
#r @"AltLanDS.Fake\lib\net45\AltLanDS.Fake.dll"

// 
open Fake
open AltLanDS.Fake.ALtLanBuild
open System
open System.IO

#load "common-targets.fsx"

Target "Build" (fun _ ->
    trace "-- Build ---"
    //add your build targets here
)

"Start"
    ==> "Clean"
    ==> "Build"            
    =?> ("CopyToDrop", dropDirDefined)
    ==> "Default"
 
RunTargetOrDefault "Default"



// Example nuget target

//Target "Copy_nuspec_To_Artifacts" (fun _ ->
//    CopyFile artifactsDir "nuspec\AltLanDS.Build.nuspec"
//    SetReadOnly false (!! (artifactsDir @@ "AltLanDS.Build.nuspec"))
//)
//
//Target "Nuget AltLanDS.Build" (fun _ ->
//    AltLanDS.Fake.NuGetHelper.NuGet (fun p -> 
//        {p with                       
//            Version = fileVersion
//            Project = "AltLanDS.Build"
//            WorkingDir = artifactsDir
//            OutputPath = artifactsDir
//            PublishUnc=nugetPublishDir
//            Publish = true}) 
//            (Path.Combine(artifactsDir,"AltLanDS.Build.nuspec"))
//)