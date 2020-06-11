// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake
open Fake.Testing

// Directories
let buildDir  = "./build/"
let deployDir = "./deploy/"
let testDir   = "./test/"


// Filesets
let appReferences  =
    !! "/**/*.csproj"
    ++ "/**/*.fsproj"

// version info
let version = "0.1"  // or retrieve from CI server

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; deployDir; testDir]
)

Target "GenerateFiles" (fun _ ->
    DeleteFiles [ "../vbacop/src/vbacop/VbaLexer.fs";"../vbacop/src/vbacop/VbaParser.fs";"../vbacop/src/vbacop/VbaParser.fsi"]
    printfn "Generating lexer"
    let timeout = System.TimeSpan.FromSeconds 10.0
    let lexResult = ProcessHelper.ExecProcessAndReturnMessages(fun info -> 
                                         info.FileName <- "packages/FsLexYacc/build/fslex.exe"
                                         info.WorkingDirectory <- "."
                                         info.Arguments <- "../vbacop/src/vbacop/VbaLexer.fsl --unicode -o ../vbacop/src/vbacop/VbaLexer.fs") timeout
    printfn "Lex Result: Errors: %A Messages: %A" lexResult.Errors lexResult.Messages
    printfn "Generating parser"
    let parseResult = ProcessHelper.ExecProcessAndReturnMessages(fun info -> 
                                         info.FileName <- "../vbacop/packages/FsLexYacc/build/fsyacc.exe"
                                         info.WorkingDirectory <- "."
                                         info.Arguments <- "../vbacop/src/vbacop/VbaParser.fsy --module VbaParser -o ../vbacop/src/vbacop/VbaParser.fs") timeout
    printfn "Parse Result: Errors: %A Messages: %A" parseResult.Errors parseResult.Messages
    //ProcessHelper.Shell.Exec("", "", null) |> ignore
)

Target "BuildApp" (fun _ ->
    // compile all projects below src/app/
    MSBuildDebug buildDir "Build" appReferences
    |> Log "AppBuild-Output: "

    printfn "running chmod..."
    ProcessHelper.Shell.Exec("chmod", "u+x " + System.IO.Path.Combine(buildDir, "vbacop.exe"),null) |> ignore
)

Target "BuildTest" (fun _ -> 
        !! "src/test/*.fsproj"
          |> MSBuildDebug testDir "Build"
          |> Log "TestBuild-Output: ")

Target "Test" (fun _ -> 
        !! (testDir + "/*.tests.dll")
           |> NUnit3 (fun p -> 
                    { p with 
                            ToolPath = "packages/NUnit.ConsoleRunner/tools/nunit3-console.exe"; }))

Target "Deploy" (fun _ ->
    !! (buildDir + "/**/*.*")
    -- "*.zip"
    |> Zip buildDir (deployDir + "ApplicationName." + version + ".zip")
)

// Build order
"Clean"
  ==> "GenerateFiles"
  ==> "BuildApp"
  ==> "Deploy"

"Clean" 
  ==> "GenerateFiles"
  ==> "BuildTest" 
  ==> "Test"

// start build
RunTargetOrDefault "BuildApp"
