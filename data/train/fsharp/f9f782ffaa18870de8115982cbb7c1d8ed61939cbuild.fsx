#r @"packages/FAKE/tools/FakeLib.dll"
open Fake

RestorePackages()

let buildDir = "./JavaWordCountTest/multilang/"
Target "Clean" (fun _ ->    
    CleanDir buildDir
)
Target "BuildAll" (fun _ ->
   
    
    !! "/**/*.csproj"
    -- "StormMultiLangTests/*"
        |> MSBuildRelease buildDir "Build"
        |> Log "AppBuild-Output: "
)
"Clean"
    ==> "BuildAll"
    
RunTargetOrDefault "BuildAll"

//Target "BuildApp" (fun _ ->
//   !! "src/app/**/*.csproj"
//     |> MSBuildRelease buildDir "Build"
//     |> Log "AppBuild-Output: "
//)
//

//"Clean"
//  ==> "BuildApp"

// 


//  <PropertyGroup>
//    <PostBuildEvent>copy /y "$(TargetDir)WordCountTest.exe" "..\..\..\JavaWordCountTest\multilang\resources\WordCountTest.exe"
//copy /y "$(TargetDir)StormMultiLang.dll"  "..\..\..\JavaWordCountTest\multilang\resources\StormMultiLang.dll"
//copy /y "$(TargetDir)ServiceStack.Text.dll"  "..\..\..\JavaWordCountTest\multilang\resources\ServiceStack.Text.dll"</PostBuildEvent>
//  </PropertyGroup>