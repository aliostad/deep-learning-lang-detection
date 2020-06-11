#r "lib/FAKE/tools/FakeLib.dll"

open Fake

// -----------------------------------------------------------------
let [<Literal>] artifacts = ".artifacts"
let [<Literal>] publishFile = "publish-dir"
// -----------------------------------------------------------------

Target "Clean" (fun _ -> 
    trace "cleaning artifacts folder ..."
    CleanDir artifacts)

Target "CopyDependencies" (fun _ ->
    !! "lib/*.dll"
    |> Copy artifacts)

Target "Compile" (fun _ ->
    !! "src/**/*.fsx"
    |> Seq.iter (fun fsx ->
        trace <| "compiling " + fsx

        let asmInfo = "src" @@ "AssemblyInfo.fs"
        let output = artifacts @@ (fsx |> filename |> changeExt ".exe")
        let options = [ "-I lib"
                        "-o " + output ] 

        let args = asmInfo::fsx::options 

        Shell.Exec("fsc", args |> String.concat " ") 
        |> ignore ))

Target "Publish" (fun _ ->
    let target = ReadLine publishFile
    XCopy artifacts target)

Target "All" DoNothing

"Clean"
    ==> "CopyDependencies"
    ==> "Compile"
    =?> ("Publish", fileExists publishFile)
    ==> "All"

RunTargetOrDefault "All"
