// include Fake lib
#r "packages/FAKE/tools/FakeLib.dll"
open Fake
open TypeScript
open System.IO
open Fake.Azure.Kudu
// Properties
let buildDir = "./build"
let packages = "./packages"
let assets = "./assets"
let deployDir = "../wwwroot"

let foldDir dir () = 
    let parentDirs = Directory.EnumerateDirectories(dir) |> Seq.toList
    parentDirs 
    |> Seq.collect (Directory.EnumerateDirectories)
    |> Seq.collect(fun subDir -> Directory.EnumerateDirectories(subDir, "content"))
    |> Seq.iter (fun content -> 
        printfn "From %s to %s" content dir
        Fake.FileUtils.cp_r content dir)
    FileHelper.DeleteDirs parentDirs
Target "Clean" (fun _ ->
    CleanDirs [buildDir;deployDir;assets]
)


Target "Default" (fun _ ->
    !! "./**/*.fsproj"
        |> MSBuildRelease buildDir "Build"
        |> Log "HostBuild-Output: "
)
Target "CopyAssets" (fun _ ->
    [!! (packages @@ "/**/*")
     -- (packages </> "**/admin/**")
     -- (packages </> "**/dashboard/**")]
        |> FileHelper.CopyWithSubfoldersTo assets
    //foldDir @"C:\Users\diese\Source\Repos\GreyTide\assets" ()
    foldDir assets ()
    FileHelper.DeleteDir (assets @@ "App_Start")
    [(!! "./GreyTideAssets/**/*.html"
      ++ "./GreyTideAssets/**/*.ts"
      ++ "./GreyTideAssets/**/*.css"
      ++ "./GreyTideAssets/**/*.js"
      ++ "./GreyTideAssets/**/*.png"
      ++ "./GreyTideAssets/**/*.svg"
      ).SetBaseDirectory("./GreyTideAssets/")]
        |> FileHelper.CopyWithSubfoldersTo assets
    !! "paket-files/**/*.js" |> FileHelper.CopyTo (assets </> "Scripts")
)

Target "CompileTypeScript" (fun _ ->
    (!! (assets </> "**/*.ts")).SetBaseDirectory(assets)
        |> TypeScriptCompiler (fun p -> { p with  ECMAScript = ES5; EmitSourceMaps= true }) 
   // !! (assets </> "**/*.ts") |> FileHelper.DeleteFiles
)

Target "StageWebsiteAssets" (fun _ ->
    stageFolder buildDir (fun _ -> true)
    stageFolder assets (fun _ -> true)
)

Target "Deploy" kuduSync



// Dependencies
"Clean"
  ==> "Default"
  ==> "CopyAssets"
  ==> "CompileTypeScript" 
  ==> "StageWebsiteAssets" 
  ==> "Deploy"

// start build
RunTargetOrDefault "CompileTypeScript"