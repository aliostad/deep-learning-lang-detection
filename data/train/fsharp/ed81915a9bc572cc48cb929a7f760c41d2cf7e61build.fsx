#r @"src/packages/FAKE.3.14.9/tools/FakeLib.dll"
open Fake
open System.IO

let buildDir = "./build/"
let testDir   = "./test/"

Target "Clean" (fun _ ->
    CleanDirs [buildDir; testDir]
)

Target "BuildApp" (fun _ ->
    !! "src/App/*.fsproj" ++ "src/Api/*.fsproj"
      |> MSBuildRelease buildDir "Build"
      |> Log "AppBuild-Output: "
)

Target "CopyWWW" (fun _ -> 
    XCopy "src/Api/www" (buildDir + "/_PublishedWebsites/Api/www")
)

Target "Copy Native Binaries" (fun _ ->
    XCopy (buildDir + "/NativeBinaries") (buildDir + "/_PublishedWebsites/Api/bin/NativeBinaries")
)

Target "BuildTest" (fun _ ->
    !! "src/Tests/*.fsproj"
      |> MSBuildDebug testDir "Build"
      |> Log "TestBuild-Output: "
)

Target "Default" (fun _ ->
    ()
)

Target "Test" (fun _ ->
    !! (testDir + "/Tests.dll")
      |> NUnit (fun p ->
          {p with
             DisableShadowCopy = true;
             OutputFile = testDir + "TestResults.xml" })
)

Target "UpdateConfig" (fun _ ->    
    ConfigurationHelper.updateConnectionString 
        "studynotesapi_db" 
        (sprintf "Server=tcp:q7et4k1vyb.database.windows.net,1433;Database=studynotes;User ID=simpleauthdata@q7et4k1vyb;Password=%s;Trusted_Connection=False;Encrypt=True;Connection Timeout=30;" (File.ReadAllText "pw.txt"))
        (buildDir + "/_PublishedWebsites/Api/Web.config")  
    ConfigurationHelper.updateAppSetting "simpleAuthUrl" "http://simpleauth1.azurewebsites.net/auth" (buildDir + "/_PublishedWebsites/Api/Web.config") 
)

Target "Upload" (fun _ ->
    FtpHelper.uploadAFolder "simpleauth.cloudapp.net" "ftp" "greedyfly@9" (buildDir + "/_PublishedWebsites/Api/") "")

// Dependencies
"Clean"
  ==> "BuildApp"
  ==> "BuildTest"
  ==> "Test"
  ==> "CopyWWW"
  ==> "Copy Native Binaries"
  ==> "UpdateConfig"
  ==> "Default"

// start build
RunTargetOrDefault "Default"