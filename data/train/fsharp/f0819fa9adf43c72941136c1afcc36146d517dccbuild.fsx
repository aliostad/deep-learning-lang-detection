#I @"tools\FAKE"
#r "FakeLib.dll"

open Fake
 
// properties 
let projectName = "FastAgile"
let projectSummary = "FastAgile - Lightweight application for fast agile planning"
let projectDescription = "FastAgile -  Lightweight application for fast agile planning"
let authors = ["Kamil Wojciechowski"]
let mail = "netkmal@gmail.com"
let homepage = "http://github.com/aph5/fastagile"

TraceEnvironmentVariables()  
  
let buildDir = @"build\"
let testDir = @"test\"
let metricsDir = @"artifacts\metrics\"
let deployDir = @"artifacts\publish\"
let docsDir = @"artifacts\docs\" 
let xunitPath = @"tools\xunit\xunit.gui.clr4.exe"
let docuPath = @"tools\Docu\docu.exe"
// let nugetDir = @"nuget\" 
let reportDir = @"artifacts\report\" 
let templatesSrcDir = @"tools\Docu\templates\"
let deployZip = deployDir @@ sprintf "%s-%s.zip" projectName buildVersion

// files
let appReferences  = !! @"app\**\*.*csproj"
let testReferences = !! @"tests\**\*.*csproj"

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; testDir; deployDir; docsDir; metricsDir; reportDir]

    ["tools/FSharp/FSharp.Core.optdata"
     "tools/FSharp/FSharp.Core.sigdata"]
      |> CopyTo buildDir
)

Target "SetAssemblyInfo" (fun _ ->
    AssemblyInfo 
        (fun p -> 
        {p with
            CodeLanguage = CSharp;
            AssemblyVersion = buildVersion;
            AssemblyTitle = "FastAgile - ApplicationServices";
            Guid = "fb2b540f-d97a-4660-972f-5eeff8120fba";
            OutputFileName = @"app\FastAgile.ApplicationServices\Properties\AssemblyInfo.cs"})
                   
    AssemblyInfo 
        (fun p -> 
        {p with
            CodeLanguage = CSharp;
            AssemblyVersion = buildVersion;
            AssemblyTitle = "FastAgile - DomainModel";
            Guid = "d6dd5aec-636d-4354-88d6-d66e094dadb5";
          OutputFileName = @"app\FastAgile.DomainModel\Properties\AssemblyInfo.cs"})
          
    AssemblyInfo 
        (fun p -> 
        {p with
            CodeLanguage = CSharp;
            AssemblyVersion = buildVersion;
            AssemblyTitle = "FastAgile - ReadModel";
            Guid = "d6dd5aec-636d-4354-88d6-d66e094dadb5";
            OutputFileName = @"app\FastAgile.ReadModel\Properties\AssemblyInfo.cs"})
              
    AssemblyInfo 
        (fun p -> 
        {p with
            CodeLanguage = CSharp;
            AssemblyVersion = buildVersion;
            AssemblyTitle = "FastAgile - Web";
            Guid = "d6dd5aec-636d-4354-88d6-d66e094dadb5";
          OutputFileName = @"app\FastAgile.Web\Properties\AssemblyInfo.cs"})

     
)

Target "BuildApp" (fun _ ->                     
    MSBuildRelease buildDir "Build" appReferences
        |> Log "AppBuild-Output: "
)

Target "GenerateDocumentation" (fun _ ->
    !! (buildDir + "FastAgile*.dll")
    |> Docu (fun p ->
        {p with
            ToolPath = docuPath
            TemplatesPath = templatesSrcDir
            OutputPath = docsDir })
)

Target "CopyDocu" (fun _ -> 
    ["tools/Docu/docu.exe"
     "tools/Docu/DocuLicense.txt"]
       |> CopyTo buildDir
)

Target "CopyLicense" (fun _ -> 
    ["License.txt"
     "readme.markdown"
     "changelog.markdown"]
       |> CopyTo buildDir
)

Target "BuildZip" (fun _ ->     
    !+ (buildDir + @"\**\*.*") 
    -- "*.zip" 
    -- "**/*.pdb"
      |> Scan
      |> Zip buildDir deployZip
)

Target "BuildTest" (fun _ -> 
    MSBuildDebug testDir "Build" testReferences
        |> Log "TestBuild-Output: "
)

Target "Test" (fun _ ->  
    !! (testDir @@ "Test.*.dll") 
      |> xUnit (fun p -> 
            {p with 
                ToolPath = xunitPath;
                OutputDir = reportDir}) 
)
(*
Target "ZipFastAgile" (fun _ ->
    !! (buildDir + "\**\*.*") 
      |> CopyTo "./Samples/Calculator/tools/FAKE/"
        
    !+ @"Samples\Calculator\**\*.*" 
        -- "**\*Resharper*\**"
        -- "**\bin\**\**"
        -- "**\obj\**\**"
        |> Scan
        |> Zip @".\Samples\Calculator" (deployDir @@ sprintf "CalculatorSample-%s.zip" buildVersion)
)
*)
Target "ZipDocumentation" (fun _ ->    
    !! (docsDir + @"\**\*.*")  
      |> Zip docsDir (deployDir @@ sprintf "Documentation-%s.zip" buildVersion)
)

(*
Target "CreateNuGet" (fun _ -> 
    let nugetDocsDir = nugetDir @@ "docs/"
    let nugetToolsDir = nugetDir @@ "tools/"

    XCopy docsDir nugetDocsDir
    XCopy buildDir nugetToolsDir

    NuGet (fun p -> 
        {p with               
            Authors = authors
            Project = projectName
            Description = projectDescription                               
            OutputPath = nugetDir
            AccessKey = getBuildParamOrDefault "nugetkey" ""
            Publish = hasBuildParam "nugetkey" }) "fake.nuspec"
)
*)
Target "Deploy" DoNothing

// Dependencies
"Clean"
    ==> "BuildApp" <=> "BuildTest"
    ==> "Test"
 //   ==> "CopyLicense" <=> "CopyDocu"
    ==> "BuildZip"
    ==> "GenerateDocumentation"
//    ==> "ZipDocumentation" <=> "ZipFastAgile"
 //   ==> "CreateNuGet"
    ==> "Deploy"
  
if not isLocalBuild then
    "Clean" ==> "SetAssemblyInfo" ==> "BuildApp" |> ignore

// start build
RunParameterTargetOrDefault "target" "Deploy"