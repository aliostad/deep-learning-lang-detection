#r @"../packages/FAKE/tools/FakeLib.dll"
#r @"../packages/FAKE.IIS/tools/Fake.IIS.dll"

#load "./config.fsx"

open System.IO
open Fake
open Fake.IISExpress
open Config
open System.Configuration

Target "Test" (fun _ ->
  !! "**/bin/Debug/*Tests.dll"
  |> NUnit (fun p ->
    {p with
      DisableShadowCopy = true;
    }
  )
)

Target "Canopy" (fun _ ->
    let hostName = "localhost"
    let port = 9099
    let buildDir = "AcceptanceApp" @@ "bin" @@ "debug"
    let websiteDir = "DemoKoCoffee"
    let project = "DemoKoCoffee-Acceptance"

    let config = createConfigFile(project, 99, "iisexpress.config",  websiteDir, hostName, port)
    let webSiteProcess = HostWebsite id config 99

    let result =
        ExecProcess (fun info ->
            info.FileName <- (buildDir @@ "AcceptanceApp.exe")
            info.WorkingDirectory <- buildDir
        ) (System.TimeSpan.FromMinutes 5.)

    ProcessHelper.killProcessById webSiteProcess.Id

    if result <> 0 then failwith "Failed result from canopy tests"
)


