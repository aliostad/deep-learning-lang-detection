#r "packages/FAKE/tools/FakeLib.dll" // include Fake lib
#load "../build-common.fsx"

open Fake
open System
open build.common

let projectName = "Widgets"
let buildDir = "./build/"
let testDir = "./tests/"
let packageDir = "./dist/"

let apiHostName = projectName + "-Web-API"

let apiHostFolder = buildDir + apiHostName

let zipPath name = packageDir + name + "-" + version + ".zip"

Target "Clean" (fun _ ->
    CleanDirs [buildDir; testDir; packageDir]
)

Target "Build-API" 
    (build "ConsoleApiHost/**.csproj" apiHostFolder)

Target "Package-API" (fun _ -> 
    let nugetPackageName = projectName + ".ApiHost"
    let nugetDescription = "Topshelf & NancyFX service for the " + projectName + " API"

    zipPackage apiHostFolder (zipPath apiHostName)
    nugetPackage apiHostFolder nugetPackageName nugetDescription packageDir
)

Target "Build-Tests" 
    (build "**/*.Tests.csproj" testDir)

Target "Test" 
    (runTests (testDir + "/*.Tests.dll") testDir (projectName + ".TestResults.xml"))

Target "Package" DoNothing
Target "Build" DoNothing
Target "Default" DoNothing

// Dependencies

"Clean"
    ==> "RestorePackages"
    ==> "Build-API"
    ==> "Build"

"Build"
    ==> "Test"
    ==> "Package-API"
    ==> "Package"

"Clean"    
    ==> "Build-Tests"
    ==> "Test"

"Package"
    ==> "Default"

RunTargetOrDefault "Default"