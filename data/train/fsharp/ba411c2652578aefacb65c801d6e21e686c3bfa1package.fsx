#r @"../packages/FAKE/tools/FakeLib.dll"

#load "./config.fsx"
#load "./userInput.fsx"
#load "./version.fsx"

open Fake
open Fake.FileSystem

open Config
open Version

module Package =

    let packagingDir = "packaging   "

    Target "Package:Epoch" (fun _ ->
        // Copy all the package files into a package folder
        let prjFolder = "main/MavenThought.Commons.Epoch"
        let prj = prjFolder @@ "MavenThought.Commons.Epoch.csproj"
        
        MSBuildRelease "" "Rebuild" [ prj ] |> ignore

        FileUtils.rm_rf packagingDir

        FileUtils.mkdir packagingDir

        CopyFiles (packagingDir @@ "lib" @@ "net35") [prjFolder @@ "bin/release/MavenThought.Commons.Epoch.dll"]

        NuGet (fun p -> 
            {p with
                Authors = ["Amir Barylko"]
                Project = "MavenThought.Commons.Epoch"
                Description = "Utilities to create and manipulate dates and times"                              
                OutputPath = "."
                Summary = "Set of classes and extensions that make date creation much easier and clear"
                WorkingDir = packagingDir
                Version = Version.Current
                Publish = true }) 
                "template.nuspec"
    )