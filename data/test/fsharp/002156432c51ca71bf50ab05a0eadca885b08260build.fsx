// include Fake libs
#r "packages/FAKE.Core/tools/FakeLib.dll"
open Fake
open Fake.FscHelper
open Fake.FileUtils

let outputDir = "output/"
let nunitDll = "packages/NUnit.Runners.2.6.3/tools/lib/nunit.core.dll"
let nunitFrameworkDll = "packages/NUnit.Runners.2.6.3/tools/nunit.framework.dll"
let fsunitDll = "packages/FsUnit.1.3.0.1/Lib/Net20/FsUnit.NUnit.dll"

let moveDllsToOutputDir = fun _ -> !! ("*.dll")
                                    |> Seq.iter (fun file -> 
                                                            cp file outputDir
                                                            rm file)

Target "Restore" RestorePackages

Target "fizzbuzz.dll" (fun _ -> 
  ["fizzbuzz.fs"]
  |> Fsc (fun p -> { p with Output = "fizzbuzz.sll"
                            References = []
                            FscTarget = Library})
)

Target "fizzbuzzTests.dll" (fun _ ->
  ["fizzbuzzTests.fs"]
  |> Fsc (fun p -> 
              { p with Output = "fizzbuzzTests.dll"
                       References = [ nunitDll 
                                      fsunitDll
                                      outputDir @@ "fizzbuzz.dll" ]
                       FscTarget = Library})
)


Target "RunTests" (fun _ ->
    !! (outputDir @@ "*Tests.dll")
        |> NUnit (fun p -> { p with
              OutputFile = "TestResult.xml"})
)

Target "CopyTestsToOutput" (fun _ ->
  moveDllsToOutputDir()
)

Target "CopyLibraryToOutput" (fun _ ->
  moveDllsToOutputDir()
)

Target "CopyReferencesToOutput" (fun _ ->
  [nunitDll
   fsunitDll
   nunitFrameworkDll]
    |> Copy outputDir
)

Target "Clean" (fun _ -> 
  CleanDirs [outputDir]
)

"Clean"
  ==> "Restore" 
  ==> "fizzbuzz.dll"
  ==> "CopyLibraryToOutput"
  ==> "fizzbuzzTests.dll"
  ==> "CopyReferencesToOutput"
  ==> "CopyTestsToOutput"
  ==> "RunTests"

RunTargetOrDefault "RunTests"
