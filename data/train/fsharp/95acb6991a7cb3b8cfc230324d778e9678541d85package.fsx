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

    Target "Package" (fun _ ->
        // Copy all the package files into a package folder
        
        run "Version:Set"

        MSBuildRelease "" "Rebuild" [ prj ] |> ignore

        FileUtils.rm_rf packagingDir

        FileUtils.mkdir packagingDir

        CopyFiles 
            (packagingDir @@ "lib" @@ "net35") 
            [prjFolder @@ "bin" @@ "release" @@ prjName + ".dll"]

        NuGet (fun p -> 
            {p with
                Authors = ["Amir Barylko"]
                Project = "MavenThought.Epoch"
                Description = "Utility classes to create and manipulate dates and times"                              
                OutputPath = "."
                Summary = "Set of classes and extensions that make date creation much easier and clear"
                WorkingDir = packagingDir
                Version = Version.Current
                Publish = true }) 
                "template.nuspec"
    )