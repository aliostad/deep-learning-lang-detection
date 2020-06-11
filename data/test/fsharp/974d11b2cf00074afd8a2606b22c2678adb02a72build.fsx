// include Fake lib
#r @"packages/FAKE.3.33.0/tools/FakeLib.dll"
open Fake

// Properties
let buildDir = "./build/"
let appX86 = "Dommy.Console.x86"
let appX64 = "Dommy.Console"
let apps =
     [appX86
      appX64]
let packagesX64 =
     ["Dommy.Extensions.Kinect.Sdk1" 
      "Dommy.Extensions.Kinect.Sdk2"
      "Dommy.Extensions.UsbUirt"]

let packagesX86 =
     ["Dommy.Extensions.UsbUirt.X86"]

let packages = Seq.concat [packagesX64; packagesX86]

// Clean target
Target "Clean" (fun _ ->
    CleanDir buildDir
)

Target "BuildApp" (fun _ ->
    !! "Dommy.sln"
      |> MSBuildRelease null "Build"
      |> Log "AppBuild-Output: "
)

Target "Apps" (fun _ ->
    for app in apps do
        !! ("./" + app + "/bin/release/*.*")
        |> Copy (buildDir + "/apps/" + app) 
)

Target "Package" (fun _ ->
    for package in packages do
        !! ("./" + package + "/bin/release/*.*")
        -- ("./" + package + "/bin/release/Dommy.Business.*")
        -- ("./" + package + "/bin/release/Ninject.*")
        -- ("./" + package + "/bin/release/CassiniDev4*")
        -- ("./" + package + "/bin/release/Microsoft.AspNet*")
        -- ("./" + package + "/bin/release/Microsoft.Owin*")
        -- ("./" + package + "/bin/release/log4net*")
        -- ("./" + package + "/bin/release/newtonsoft*")
        -- ("./" + package + "/bin/release/roslyn*")
        -- ("./" + package + "/bin/release/owin*")
        -- ("./" + package + "/bin/release/castle*")
        -- ("./" + package + "/bin/release/jetbrain*")
        |> Copy (buildDir + package) 
)

Target "AppX86" (fun _ ->
    for package in packagesX86 do
        !! (buildDir + package + "/*.*")
        |> Copy (buildDir + "/apps/" + appX86 + "/packages/" + package) 
)

Target "AppX64" (fun _ ->
    for package in packagesX64 do
        !! (buildDir + package + "/*.*")
        |> Copy (buildDir + "/apps/" + appX64 + "/packages/" + package) 
)

Target "CleanPackages" (fun _ ->
    for package in packages do
        DeleteDir (buildDir + package)
)

// Default target
Target "Default" (fun _ ->
    trace "Build is done"
)

"Clean"
==> "BuildApp"
==> "Apps"
==> "Package"
==> "AppX86"
==> "AppX64"
==> "CleanPackages"
==> "Default"

// start build
RunTargetOrDefault "Default"