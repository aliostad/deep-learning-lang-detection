#r "tools/FAKE/tools/FakeLib.dll"

open Fake

let configuration = getBuildParamOrDefault "Configuration" "Release"
let version = getBuildParamOrDefault "Version" "1.0.0.0"

let packagingDir = __SOURCE_DIRECTORY__ @@ "nugetPackage"
let stubborniumDir = __SOURCE_DIRECTORY__ @@ "Stubbornium/bin" @@ configuration
let toolsDir = __SOURCE_DIRECTORY__ @@ "tools"
let nuspecFile = __SOURCE_DIRECTORY__ @@ "nugetPackage/stubbornium.nuspec"

let runMsbuild (project: string) (target: string) =
    let setParams (p: MSBuildParams) = 
        { p with
            Verbosity = Some(MSBuildVerbosity.Minimal)
            Targets = [ target ]
            Properties = 
            [
                ( "Configuration", configuration )                
            ]            
        }

    MSBuildHelper.build setParams project

Target "Build" (fun _ ->
    runMsbuild (__SOURCE_DIRECTORY__ @@ "Stubbornium.sln") "Build"    
)

Target "CopyForPackaging" (fun _ ->
    !! (stubborniumDir @@ "Stubbornium.dll")
    |> Copy packagingDir        

    !! (__SOURCE_DIRECTORY__ @@ "stubbornium.nuspec")
    |> Copy packagingDir        
)

Target "CreatePackage" (fun _ ->
           
    NuGet (fun p -> 
        {p with         
                   
            OutputPath = __SOURCE_DIRECTORY__          
            WorkingDir = packagingDir
            Version = version            
            Publish = false
             
            Dependencies =  // fallback - for all unspecified frameworks
                ["Selenium.WebDriver", GetPackageVersion "./packages/" "Selenium.WebDriver"
                 "Selenium.Support", GetPackageVersion "./packages/" "Selenium.Support"]

        }) 
        nuspecFile
)

"Build"
    ==> "CopyForPackaging"
    ==> "CreatePackage"

RunTargetOrListTargets ()