// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open Fake

// Directories
let buildDir  = "./build/"
let deployDir = "./deploy/"


// Filesets
let appReferences  =
    !! "/**/*.csproj"
      ++ "/**/*.fsproj"

// version info
let version = "0.1"  // or retrieve from CI server

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; deployDir]
)

Target "Server Build" (fun _ ->
    // compile all projects below src/app/
    MSBuildDebug buildDir "Build" appReferences
        |> Log "AppBuild-Output: "
)

Target "Client Build" (fun _ ->
    Shell.Exec ("elm-make", "app/Main.elm", "src/Client") |> ignore
    Copy buildDir [ "src/Client/index.html" ]
    ()
)

Target "Dashboard Build" (fun _ ->
    Shell.Exec ("elm-make", "app/Dashboard.elm --output dashboard.html", "src/Client") |> ignore
    Copy buildDir [ "src/Client/dashboard.html" ]
    ()
)

Target "Deploy" (fun _ ->
    !! (buildDir + "/**/*.*")
        -- "*.zip"
        |> Zip buildDir (deployDir + "ApplicationName." + version + ".zip")
)

// Build order
"Clean"
  ==> "Server Build"
  ==> "Client Build"
  ==> "Dashboard Build"
  ==> "Deploy"

// start build
RunTargetOrDefault "Dashboard Build"
