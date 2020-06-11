#r "packages/FAKE/tools/FakeLib.dll"

open Fake

let buildDir = "./build/"
let staticDir = "./static/"
let templateDir = "./templates/"

Target "Clean" (fun _ ->
    CleanDir buildDir
)

Target "CopyStatic" (fun _ ->
    CopyDir (buildDir + "static") staticDir
            (function | EndsWith ".css"
                      | EndsWith ".js"
                      | EndsWith ".png" -> true
                      | _ -> false)
)

Target "CopyTemplates" (fun _ ->
    CopyDir (buildDir + "templates") templateDir
            (function | EndsWith ".html" -> true
                      | _ -> false)
)

Target "Web" (fun _ ->
    !! "FSWeb/*.fsproj"
    |> MSBuildRelease buildDir "Build"
    |> ignore
)

Target "Default" (fun _ ->
    trace "Deploy"
)

"Clean"
==> "Web"
==> "CopyStatic"
==> "CopyTemplates"
==> "Default"

RunTargetOrDefault "Default"
