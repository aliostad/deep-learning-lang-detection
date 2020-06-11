#I "./packages/FAKE.1.64.14/tools"
#r "FakeLib.dll"

open Fake 
open System.IO

let now = System.DateTime.UtcNow
let projectName = "Xaye.Math"
let version = now.ToString("yyyy.MM.dd.") + int(now.TimeOfDay.TotalMinutes).ToString()
let projectSummary = "F# math library using Intel's MKL."
let author = ["Marcus Cuda"]
let mail = "marcus@cuda.org"
let homepage = "https://github.com/cuda/Xaye"

// directories
let libDir = "./lib/MKL"
let testDir = "./test/"
let buildDir = "./build/"
let docsDir = "./docs/"
let srcDir = "./"
let deployDir = "./deploy/"
let packageDir = srcDir + "packages/"
let xmlDir = "../xml/"

let targetPlatformDir = getTargetPlatformDir "4.0.30319"

// params
let target = getBuildParamOrDefault "target" "All"

// tools
let fakePath = packageDir + "FAKE.1.64.15/tools"
let nunitPath = packageDir + "NUnit.Runners.2.6.2/tools"

let mathReferences =
    !+ (srcDir + "Xaye.Math/Xaye.Math.fsproj")
        |> Scan

let testReferences =
    !+ (srcDir + "Xaye.Math.Tests/Xaye.Math.Tests.fsproj")
      |> Scan


// targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; testDir; docsDir; deployDir; "./xml"]
)

Target "CreateAssemblyInfo" (fun p ->
    AssemblyInfo (fun p ->
        {p with 
            CodeLanguage = FSharp
            AssemblyVersion = version
            AssemblyTitle = "Xaye.Math.dll"
            AssemblyProduct = projectName 
            AssemblyDescription = projectSummary
            Guid = "4b671664-f8c2-4be5-b537-cab709128e1c"
            OutputFileName = srcDir + "Xaye.Math/AssemblyInfo.fs" })
)

Target "Build" (fun _ ->
    MSBuild buildDir "Build" 
      ["Configuration", "Release";
       "Platform", "AnyCpu";
       "DocumentationFile", xmlDir + "Xaye.Math.xml"] mathReferences
    |> Log "AppBuild-Output: "
)

Target "BuildTest" (fun _ ->
    MSBuild testDir "Build" ["Configuration","Debug";"Platform","AnyCpu";] testReferences  
        |> Log "TestBuild-Output: "
)

Target "Test32" (fun _ ->
    !+ (testDir + "/*.Tests.dll")
        |> Scan
        |> NUnit (fun p ->
            {p with
                ToolName = "nunit-console-x86.exe"
                ToolPath = nunitPath
                DisableShadowCopy = true
                OutputFile = testDir + "TestResults.xml" })
)

Target "Test64" (fun _ ->
    !+ (testDir + "/*.Tests.dll")
        |> Scan
        |> NUnit (fun p ->
            {p with
                ToolName = "nunit-console.exe"
                ToolPath = nunitPath
                DisableShadowCopy = true
                OutputFile = testDir + "TestResults.xml" })
)

Target "CopyNative32Test" (fun _ ->
   [ libDir + "/Windows/x86/libiomp5md.dll"; libDir + "/Windows/x86/xayenative.dll"] |> CopyTo testDir
)

Target "CopyNative64Test" (fun _ ->
   [ libDir + "/Windows/x64/libiomp5md.dll"; libDir + "/Windows/x64/xayenative.dll"] |> CopyTo testDir
)

Target "GenerateDocs" (fun _ ->
    ["./xml/Xaye.Math.xml"] |> CopyTo buildDir

    let args = " --namespacefile index.html  --outdir " + docsDir + " " + buildDir + "Xaye.Math.dll"
    tracefn "Generating documentation"
    let result = ExecProcess (fun info ->  
        info.FileName <- "./lib/FsHtmlDoc-2.0/fshtmldoc.exe"
        info.Arguments <- args) System.TimeSpan.MaxValue
    if result <> 0 then failwithf "Error generating docs"
    CopyFile docsDir "./lib/FsHtmlDoc-2.0/msdn.css"
)

Target "CopyFiles" (fun _ ->
  CopyDir (buildDir + "/docs") docsDir allFiles
  ["./xml/Xaye.Math.xml"] |> CopyTo buildDir
  let txt = ["LICENSE.txt"; "README.txt"]
  txt |> CopyTo buildDir
  CopyDir (libDir + "/docs") docsDir allFiles
  CreateDir (buildDir + "/x86")
  CreateDir (buildDir + "/x64")
  [ libDir + "/Windows/x86/libiomp5md.dll"; libDir + "/Windows/x86/xayenative.dll" ] |> CopyTo (buildDir + "/x86")
  [ libDir + "/Windows/x64/libiomp5md.dll"; libDir + "/Windows/x64/xayenative.dll"] |> CopyTo (buildDir + "/x64")
)

Target "Zip" (fun _ ->
  let files = ["Xaye.Math.dll"; "Xaye.Math.xml"; "README.txt"; "LICENSE.txt"; @"/docs*/**/*.*"; @"/x86*/*.*"; @"/x64*/*.*" ]
  
  let all = { BaseDirectories = [buildDir]; 
                 Includes = files;
                 Excludes = [] }
  

  all
    |> Scan
    |> Zip buildDir (deployDir + "xaye.math.zip")
)

Target "Default" DoNothing

// Build order
"Clean"
  ==> "CreateAssemblyInfo"
  ==> "Build" <=> "BuildTest" 
  ==> "CopyNative32Test" <=> "Test32"
  ==> "CopyNative64Test" <=> "Test64"
  ==> "GenerateDocs" <=> "CopyFiles" <=> "Zip"
  ==> "Default"

// Start build
RunParameterTargetOrDefault "target" "Default"

