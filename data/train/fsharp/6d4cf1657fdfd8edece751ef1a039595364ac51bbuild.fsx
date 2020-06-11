//#region F# Regions outlining extension download link
(*
https://visualstudiogallery.msdn.microsoft.com/bec977b8-c9d9-4926-999e-e50c4498df8a
*)
//#endregion

//#region Includes
#r @"libs\FAKE\tools\FakeLib.dll"
#r "System.Runtime.Serialization.dll"
#r "System.Xml.dll"
#r "System.Xml.Linq.dll"
#r "System.Data.Entity.dll"
#r "System.IO.Compression.FileSystem.dll"
#r @"libs\FSharp.Collections.ParallelSeq\lib\net40\FSharp.Collections.ParallelSeq.dll"
#r @"libs\EntityFramework.6.1.3\lib\net45\EntityFramework.dll"

open Fake
open Fake.DotCover
open System.Xml
open System.Xml.Linq
open System
open System.Text
open System.IO
open System.Linq
open System.Diagnostics
open System.Collections.Generic
open System.Net
open System.Runtime.Serialization.Json
open System.Threading
open FSharp.Collections.ParallelSeq
open System.Data
open System.Collections.Generic
open System.ComponentModel.DataAnnotations
open System.Data.Entity
//#endregion

let EnumClassToString = 
    fun obj -> 
        obj
            .GetType()
            .GetFields(System.Reflection.BindingFlags.Static|||System.Reflection.BindingFlags.NonPublic)
            .FirstOrDefault(fun f -> obj.Equals(f.GetValue(obj))).Name
            .Split([|"_unique_"|],StringSplitOptions.None).[1]

//#region Build Parameters
type BuildConfiguration = 
    | DevelopUnit
    | DevelopIntegration
    | QA
    | QA2_1
    | QA2_2
    | QA2_3
    | QA2_4
    | QA2_5
    | QA2_6
    | DevelopSelenium
    | DevelopSeleniumMultipleTimes
    | IntegrationDev1
    | IntegrationStaging1
    | UgsIntegrationDemo
    | UgsIntegrationTests
    | Agent1
    | Agent2
    | Agent3
    | Agent4
    | Agent5
    | Agent6
    | Agent7
    | UIUX
    | Load
    | Soak
    | Demo
    | Staging
    | NA

    override this.ToString() = EnumClassToString(this)

type BuildStep = 
    | StopWinService
    | StopBonusWinService
    | CreateServiceBusNamespace
    | PackageRestore
    | Build
    | DeployWinServiceBinaries
    | DeployBonusWinServiceBinaries
    | DropDatabase
    | UpdateTestsConfig
    | UpdateAdminApiTestsConfig
    | UpdateMemberApiTestsConfig
    | UpdateBonusApiTestsConfig
    | CheckEventsTableBeforeTests
    | CheckEventsTableAfterTests
    | RunUnitTests
    | RunIntegrationTests
    | RunSmokeTests
    | RunSeleniumTests
    | RunSeleniumTestsMultipleTimes
    | RunLoadTests
    | RunSoakTests
    | CleanupJMeterReport
    | GenerateJMeterIndex
    | PublishAdminApi
    | PublishMemberApi
    | PublishFakeUgs
    | PublishBonusApi
    | PublishMemberWebsite
    | PublishAdminWebsite
    | PublishFakeGameWebsite
    | PublishFakePaymentServer
    | PackAndPublishWebsitesToNuGet
    | RunProductionDeployment
    | PingWebsites
    | StartWinService
    | StartBonusWinService
    | WaitUntilInitialSeedingComplete
    | ReportBuildStatus
    | GenerateScreenshotsIndex
    | GenerateLogsIndex
    | ActivateFinalTargets

    override this.ToString() = EnumClassToString(this)

let isPerformanceTesting = if (getBuildParam "performanceTesting").Equals("true")
                            then true
                            else false
let buildType = "Debug"

let MSDeployServicebusComputerName = @"https://regov2deploy.flycowdev.com:8172/msdeploy.axd"
let MSDeployTargetComputerName = if (isPerformanceTesting)
                                    then @"https://perf-regov2-app.flycowdev.com:8172/msdeploy.axd"
                                    else @"https://regov2deploy.flycowdev.com:8172/msdeploy.axd"

let MSDeployPassword = "ch6kaCru"
let MSDeployUserName = @"WIN-NKD9IS8A8GG\robot"
let databaseUrl = if (isPerformanceTesting)
                    then "perf-regov2-db.flycowdev.com"
                    else "regov2db.flycowdev.com"
                    
let domain = ".flycowdev.com"
let httpsEnabled = true
//#endregion

//#region Modules
module Configuration = 
    let make (configuration : string) = 
        match configuration with
            | "DevelopUnit" -> BuildConfiguration.DevelopUnit
            | "DevelopIntegration" -> BuildConfiguration.DevelopIntegration
            | "QA" -> BuildConfiguration.QA
            | "QA2_1" -> BuildConfiguration.QA2_1
            | "QA2_2" -> BuildConfiguration.QA2_2
            | "QA2_3" -> BuildConfiguration.QA2_3
            | "QA2_4" -> BuildConfiguration.QA2_4
            | "QA2_5" -> BuildConfiguration.QA2_5
            | "QA2_6" -> BuildConfiguration.QA2_6
            | "DevelopSelenium" -> BuildConfiguration.DevelopSelenium
            | "DevelopSeleniumMultipleTimes" -> BuildConfiguration.DevelopSeleniumMultipleTimes
            | "IntegrationDev1" -> BuildConfiguration.IntegrationDev1
            | "IntegrationStaging1" -> BuildConfiguration.IntegrationStaging1
            | "UgsIntegrationDemo" -> BuildConfiguration.UgsIntegrationDemo
            | "UgsIntegrationTests" -> BuildConfiguration.UgsIntegrationTests
            | "Agent1" -> BuildConfiguration.Agent1
            | "Agent2" -> BuildConfiguration.Agent2
            | "Agent3" -> BuildConfiguration.Agent3
            | "Agent4" -> BuildConfiguration.Agent4
            | "Agent5" -> BuildConfiguration.Agent5
            | "Agent6" -> BuildConfiguration.Agent6
            | "Agent7" -> BuildConfiguration.Agent7
            | "UIUX" -> BuildConfiguration.UIUX
            | "Load" -> BuildConfiguration.Load
            | "Soak" -> BuildConfiguration.Soak
            | "Demo" -> BuildConfiguration.Demo
            | "Staging" -> BuildConfiguration.Staging
            | _ -> BuildConfiguration.NA
//            | configuration -> failwith "Can not find proper build configuration!"

    let agentName = environVar "AgentName"

    let agentHomeDir = environVar "AgentHomeDir"

    let buildNumber = environVar "BUILD_NUMBER"

    let buildTarget = getBuildParam "buildTarget"

    let version = environVar "NuGetBuildVersion"

    let action = getBuildParam "action"

    let dropDb = getBuildParam "dropDb"

    let serverPassword = getBuildParam "pass"

    let buildStepRepeatCount = System.Int32.Parse(getBuildParam "buildStepRepeatCount")

    let getCurrent = if (buildTarget.Equals("DevelopUnit") || buildTarget.Equals("DevelopIntegration") || buildTarget.Equals("DevelopSelenium"))
                        then agentName |> make
                        else buildTarget |> make

    let getPrefix configuration = 
        match configuration with
            | BuildConfiguration.DevelopUnit -> "dev-unit"
            | BuildConfiguration.DevelopIntegration -> "dev-integration"
            | BuildConfiguration.QA -> "qa"
            | BuildConfiguration.QA2_1 -> "qa2-1"
            | BuildConfiguration.QA2_2 -> "qa2-2"
            | BuildConfiguration.QA2_3 -> "qa2-3"
            | BuildConfiguration.QA2_4 -> "qa2-4"
            | BuildConfiguration.QA2_5 -> "qa2-5"
            | BuildConfiguration.QA2_6 -> "qa2-6"
            | BuildConfiguration.DevelopSelenium -> "dev-selenium"
            | BuildConfiguration.DevelopSeleniumMultipleTimes -> "dev-selenium-multiple-times"
            | BuildConfiguration.IntegrationDev1 -> "integration-dev-1"
            | BuildConfiguration.IntegrationStaging1 -> "integration-staging-1"
            | BuildConfiguration.UgsIntegrationDemo -> "ugs-integration-demo"
            | BuildConfiguration.UgsIntegrationTests -> "ugs-integration-tests"
            | BuildConfiguration.Agent1 -> "agent-1"
            | BuildConfiguration.Agent2 -> "agent-2"
            | BuildConfiguration.Agent3 -> "agent-3"
            | BuildConfiguration.Agent4 -> "agent-4"
            | BuildConfiguration.Agent5 -> "agent-5"
            | BuildConfiguration.Agent6 -> "agent-6"
            | BuildConfiguration.Agent7 -> "agent-7"
            | BuildConfiguration.UIUX -> "uiux"
            | BuildConfiguration.Load -> "perf"
            | BuildConfiguration.Soak -> "perf"
            | BuildConfiguration.Demo -> "demo"
            | BuildConfiguration.Staging -> "staging"
            | BuildConfiguration.NA -> ""

    let getConfigurationFolderName configuration = 
        let buildConfiguration = configuration |> make
        match buildConfiguration with
            | BuildConfiguration.DevelopUnit -> "develop-unit"
            | BuildConfiguration.DevelopIntegration -> "develop-integration"
            | BuildConfiguration.QA -> "qa"
            | BuildConfiguration.QA2_1 -> "qa2"
            | BuildConfiguration.QA2_2 -> "qa2"
            | BuildConfiguration.QA2_3 -> "qa2"
            | BuildConfiguration.QA2_4 -> "qa2"
            | BuildConfiguration.QA2_5 -> "qa2"
            | BuildConfiguration.QA2_6 -> "qa2"
            | BuildConfiguration.DevelopSelenium -> "develop-selenium"
            | BuildConfiguration.DevelopSeleniumMultipleTimes -> "develop-selenium-multiple-times"
            | BuildConfiguration.NA -> "other"
            | buildConfiguration -> "other"

    let getScreenshotsPath = sprintf "C:\Projects\screenshots\%s\%s" (getConfigurationFolderName buildTarget) buildVersion

    let getLogsPath = @"C:\RegoV2Logs"
    
    let instanceName = getPrefix(getCurrent)

    let getWinServiceName configuration isBonus = 
        let name = if (isBonus)
                        then "Bonus."
                        else ""
        sprintf @"AFT.RegoV2.%sWinService.%s" name configuration

    let getWinServiceFullPath configuration isBonus = 
        let name = if (isBonus)
                        then ".Bonus"
                        else ""
        sprintf @"C:\RegoV2Data-%s\WinService%s\AFT.RegoV2%s.WinService.exe" configuration name name

    let getRelativeLogFilePath projectName =
        sprintf @"\%s\%s\%s-log.txt" (getConfigurationFolderName buildTarget) buildVersion projectName

    let getProjectIISName projectName configuration = 
        let configurationPrefix = getPrefix(configuration)
        match projectName with
            | "MemberApi" -> sprintf "%s-regov2-member-api" configurationPrefix
            | "AdminApi" -> sprintf "%s-regov2-admin-api" configurationPrefix
            | "FakeUgs" -> sprintf "%s-regov2-game-api" configurationPrefix
            | "BonusApi" -> sprintf "%s-regov2-bonus-api" configurationPrefix
            | "MemberWebsite" -> sprintf "%s-regov2-member-website" configurationPrefix
            | "AdminWebsite" -> sprintf "%s-regov2-admin-website" configurationPrefix
            | "FakeGameWebsite" -> sprintf "%s-regov2-game-website" configurationPrefix
            | "FakePaymentServer" -> sprintf "%s-regov2-fake-payment-server" configurationPrefix
            | projectName -> failwithf "Can not find proper project IIS name for given project name %s!" projectName

    let getFullWebsiteUrl projectName configuration enableHttps = 
        let iisName = getProjectIISName projectName configuration
        let protocol = if (enableHttps)
                        then "https"
                        else "http"
        sprintf @"%s://%s%s/" protocol iisName domain

    let getAllWebsitesUrls =
        let urls = new List<string>()
        urls.Add(getFullWebsiteUrl "AdminApi" getCurrent httpsEnabled)
        urls.Add(getFullWebsiteUrl "MemberApi" getCurrent false)
        urls.Add(getFullWebsiteUrl "FakeUgs" getCurrent false)
        urls.Add(getFullWebsiteUrl "BonusApi" getCurrent httpsEnabled)
        urls.Add(getFullWebsiteUrl "MemberWebsite" getCurrent false)
        urls.Add(getFullWebsiteUrl "AdminWebsite" getCurrent httpsEnabled)
        urls.Add(getFullWebsiteUrl "FakeGameWebsite" getCurrent false)
        urls.Add(getFullWebsiteUrl "FakePaymentServer" getCurrent false)
        urls

    let getAllStagingWebsitesUrls =
        let urls = new List<string>()
        urls.Add("http://staging-rego.8080win.com")
        urls.Add("https://staging-regov2-admin-website.flycowdev.com")
        urls.Add("http://staging-regov2-game-website.flycowdev.com")
        urls.Add("https://staging-regov2-admin-api.flycowdev.com")
        urls.Add("https://staging-regov2-bonus-api.flycowdev.com")
        urls.Add("http://staging-regov2-game-api.flycowdev.com")
        urls.Add("http://staging-regov2-member-api.flycowdev.com")
        urls.Add("http://staging-regov2-fake-payment-server.flycowdev.com")
        urls

    let getDbConnectionString serverUrl =
        if (instanceName.Equals("staging"))
            then sprintf "Server=10.251.4.210; Database=Rego-Staging; Persist Security Info=True; integrated security=false; user id=regostaging; password=^QPl*d0LkB3j"
            else sprintf "Server=%s; Database=RegoV2-%s; Persist Security Info=True; integrated security=false; user id=sa; password=ch6kaCru" serverUrl (getPrefix(getCurrent))

    let useUGS = buildTarget.Equals("Demo") || buildTarget.Equals("UgsIntegrationDemo") || buildTarget.Equals("UgsIntegrationTests")

    let operatorApiUrl = if useUGS
                            then "http://integration-1-ugs-api.flycowdev.com/" 
                            else if (buildTarget.Equals("Staging"))
                                    then "http://integration-8-ugs-api.flycowdev.com/"
                                    else getFullWebsiteUrl "FakeUgs" getCurrent false

    let getProjectSettings projectName = 
        let appSettings = new Dictionary<string, string>()
        match projectName with
            | "MemberApi" -> 
                            appSettings.Add("MockGameWebsite", (getFullWebsiteUrl "FakeGameWebsite" getCurrent false))
                            appSettings.Add("PaymentNotifyUrl", (getFullWebsiteUrl "MemberWebsite" getCurrent false))
                            appSettings.Add("InstanceName", instanceName)
                            appSettings

            | "AdminApi" -> 
                            appSettings.Add("MockGameWebsite", (getFullWebsiteUrl "FakeGameWebsite" getCurrent false))
                            appSettings.Add("InstanceName", instanceName)
                            appSettings

            | "FakeUgs" -> 
                           appSettings.Add("GameWebsiteUrl", (getFullWebsiteUrl "FakeGameWebsite" getCurrent false))
                           appSettings.Add("InstanceName", instanceName)
                           if (getPrefix(getCurrent).StartsWith("integration"))
                                then appSettings.Add("SkipIpValidation", "true")
                           appSettings

            | "BonusApi" -> 
                           appSettings.Add("InstanceName", instanceName)
                           appSettings

            | "MemberWebsite" -> 
                           appSettings.Add("MemberApiUrl", (getFullWebsiteUrl "MemberApi" getCurrent false))
                           appSettings.Add("MemberWebsiteUrl", (getFullWebsiteUrl "MemberWebsite" getCurrent false))
                           appSettings.Add("MockGameWebsite", (getFullWebsiteUrl "FakeGameWebsite" getCurrent false))
                           appSettings.Add("InstanceName", instanceName)
                           appSettings

            | "AdminWebsite" -> 
                           appSettings.Add("AdminApiUrl", (getFullWebsiteUrl "AdminApi" getCurrent false))
                           appSettings.Add("MemberApiUrl", (getFullWebsiteUrl "MemberApi" getCurrent false))
                           appSettings.Add("MockGameWebsite", (getFullWebsiteUrl "FakeGameWebsite" getCurrent false))
                           appSettings.Add("InstanceName", instanceName)
                           appSettings

            | "FakeGameWebsite" -> 
                           appSettings.Add("GameApiUrl", (getFullWebsiteUrl "FakeUgs" getCurrent false))
                           appSettings.Add("MockGameWebsite", (getFullWebsiteUrl "FakeGameWebsite" getCurrent false))
                           appSettings.Add("InstanceName", instanceName)
                           appSettings

            | "FakePaymentServer" -> 
                           appSettings.Add("InstanceName", instanceName)
                           appSettings

            | projectName -> failwith "Can not find proper configuration for a given project name!"

    module Wsb =   
            let HttpPort = "10355"
            let TcpPort = "10354" 
            let Host = "regov2sb.flycowdev.com"
            let Namespace = sprintf "sb-%s-%s" (getPrefix getCurrent) buildNumber // namespace length can not be smaller than 6 symbols
            let Username = "ServiceBusRobot"
            let Password = "Z#T5qt$FG9be"
            let UserDomain = ""

    module Ugsbus = 
            let ConnectionString = if useUGS
                                     then "Endpoint=sb://ugsdeploy.flycowdev.com/UgsServicesIntegration1,sb://ugsdb.flycowdev.com/UgsServicesIntegration1,sb://ugsgen.flycowdev.com/UgsServicesIntegration1;StsEndpoint=https://ugsdeploy.flycowdev.com:10355/UgsServicesIntegration1,https://ugsdb.flycowdev.com:10355/UgsServicesIntegration1,https://ugsgen.flycowdev.com:10355/UgsServicesIntegration1;RuntimePort=10354;ManagementPort=10355;SharedAccessKeyName=rego;SharedAccessKey=lKGuTQ8EBWlAPf5tVJhvKRSZ0LCupd1uQkz8B64kt9I=" 
                                     else sprintf "Endpoint=sb://%s/%s;StsEndpoint=https://%s:%s/%s;RuntimePort=%s;ManagementPort=%s;OAuthUsername=%s;OAuthPassword=%s" Wsb.Host Wsb.Namespace Wsb.Host Wsb.HttpPort Wsb.Namespace Wsb.TcpPort Wsb.HttpPort Wsb.Username Wsb.Password

module Command = 
    let execute cmd args dir = 
        let commandLine = sprintf "%s %s %s" cmd args dir

        printfn "Executing command line: %s" commandLine

        let errorCode = Shell.Exec(cmd, args, dir)

        if errorCode <> 0 then failwithf "Unable to execute script: %i" errorCode
            else printfn "Execution successful: %s" commandLine
    
    let executeRemotely command computerName = 
        let cmd = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
        let args = sprintf "-verb:sync -source:runCommand -dest:runCommand=\"%s\",waitinterval=300000,ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" command computerName MSDeployUserName MSDeployPassword
        let dir = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"

        printfn "Executing remote command: %s %s %s" cmd args dir

        Shell.Exec(cmd, args, dir)

    let httpPing (url : string) = 
        let timeOut = 1000 * 200
        try
            let request = WebRequest.Create(url)
            request.Timeout <- timeOut
            let response = request.GetResponse() :?> HttpWebResponse
            if (response.StatusCode.Equals(HttpStatusCode.OK))
                then sendStrToTeamCity (sprintf "HTTP Ping to %s is OK" url)
                else failwithf "HTTP Ping to %s has failed with the status code: %A!" url response.StatusCode
            response.Close()
        with
            | :? System.Net.WebException as ex -> 
                    if (ex.Status.Equals(System.Net.WebExceptionStatus.Timeout))
                        then failwithf "Timeout occured after %d seconds" (timeOut / 1000)
                        else failwithf "WebException has been raised with the status: %A when pinging to: %s" ex.Status url
            | ex -> printf "Unexpected exception of type %s happened!" (ex.GetType().Name)

    let remoteFileExists (url : string) =
        let mutable result = false
        try
            let request = WebRequest.Create(url) :?> HttpWebRequest
            request.Method = "HEAD" |> ignore
            let response = request.GetResponse() :?> HttpWebResponse
            result <- response.StatusCode.Equals(HttpStatusCode.OK)
            response.Close()
        with
            | ex -> printfn "Remote file at %s exception: %s" url ex.Message
        result

module Settings = 
    let private xn s = XName.Get(s)

    let private updateConnectionString (xd : XDocument) connString =
        xd.Element(xn "configuration").Element(xn "connectionStrings").Elements(xn "add")
            |> Seq.iter (fun el -> if (el.Attribute(xn "name").Value.Equals("Default")) then el.SetAttributeValue(xn "connectionString", connString))

    let private updateAppSettings (xd : XDocument) (appSettings : Dictionary<string, string>) = 
        xd.Element(xn "configuration").Element(xn "appSettings").Elements(xn "add")
            |> Seq.iter (fun el -> let keyValue = el.Attribute(xn "key").Value
                                   if appSettings.ContainsKey(keyValue) then el.SetAttributeValue(xn "value", appSettings.[keyValue]))

    let private requireSsl (xd : XDocument) = 
        xd.Element(xn "configuration").Element(xn "system.web").Element(xn "authentication").Element(xn "forms")
            |> (fun el -> el.SetAttributeValue(xn "requireSSL", "true"))

    let private updateLogFilePath (xd : XDocument) logFile =
        xd.Element(xn "configuration").Element(xn "nlog").Element(xn "targets").Elements(xn "target").Single(fun x -> x.Attribute(xn "type") <> null && x.Attribute(xn "type").Value.Equals("File", StringComparison.InvariantCultureIgnoreCase)).SetAttributeValue(xn "fileName", logFile)

    let getConfigPath tempDir projectFileName configFileName =
        let projectDir = Directory.GetDirectories(tempDir, projectFileName, SearchOption.AllDirectories) |> Seq.head
        let result = Directory.GetFiles(projectDir, configFileName, SearchOption.AllDirectories) |> Seq.head
        if (result.Length < 0) then failwithf "Config file not found!"
        result

    let updateWebConfig appSettings (projectFileName : string) (webConfigPath : string) =
        let xd = XDocument.Load(webConfigPath)

        updateAppSettings xd appSettings

        if (projectFileName.Contains("MemberWebsite") |> not)
            then updateConnectionString xd (Configuration.getDbConnectionString databaseUrl)

        if (projectFileName.Contains("AdminWebsite") && httpsEnabled)
            then requireSsl xd

        if ((projectFileName.Contains("FakePaymentServer") |> not) && (projectFileName |> String.IsNullOrEmpty |> not))
            then let logFile = Configuration.getLogsPath + Configuration.getRelativeLogFilePath (if (projectFileName <> "Api") then projectFileName else "BonusApi")
                 updateLogFilePath xd logFile

        xd.Save(webConfigPath)

    let updateWinServiceConfig appSettings isBonus (winServiceConfigPath : string) =
        let xd = XDocument.Load(winServiceConfigPath)

        updateAppSettings xd appSettings

        updateConnectionString xd (Configuration.getDbConnectionString databaseUrl)
        let name = if (isBonus)
                        then "BonusWinService"
                        else "WinService"
        let logFile = Configuration.getLogsPath + Configuration.getRelativeLogFilePath name
        updateLogFilePath xd logFile

        xd.Save(winServiceConfigPath)

    let updateJsConfigForAdminApi configPath =
        let configContent = String.concat " " (ReadFile configPath)
        let updatedContent = replace "local" (Configuration.getCurrent.ToString()) configContent
        ReplaceFile configPath updatedContent

module IIS = 
    let private configurationNotExists iisName = 
        let cmd = @"C:\windows\system32\inetsrv\appcmd.exe"
        let args = sprintf "list site /name:%s" iisName
        let dir = ""

        Command.executeRemotely (sprintf "%s %s" cmd args) MSDeployTargetComputerName <> 0

    let private createConfiguration iisName enableHttps = 
        let cmd = @"C:\windows\system32\inetsrv\appcmd.exe"

        let executeCommand args =
            Command.executeRemotely (sprintf "%s %s" cmd args) MSDeployTargetComputerName |> ignore

        let bindings = if (enableHttps)
                        then "https/*:443"
                        else "http/*:80"

        executeCommand (sprintf "delete site %s" iisName)
        executeCommand (sprintf "add apppool /name:%s" iisName)
        executeCommand (sprintf "add site /name:%s /bindings:%s:%s%s /physicalpath:\"C:\inetpub\wwwroot\%s\"" iisName bindings iisName domain iisName)
        executeCommand (sprintf "set app \"%s/\" /applicationPool:\"%s\"" iisName iisName)

    let private setWritable folderPath =
        let cmd = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
        let args = sprintf "-verb:sync -source:setacl -dest:setacl=\"%s\",setAclUser=\"IIS_IUSRS\",setAclAccess=Write,ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" folderPath MSDeployTargetComputerName MSDeployUserName MSDeployPassword
        let dir = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"
        Command.execute cmd args dir

    let publishProject projectPath projectName appSettings enableHttps = 
        let tempDir = currentDirectory @@ "tmp"
        let projectFileName = fileNameWithoutExt projectPath
        let packagePath = tempDir @@ (sprintf "%s.zip" projectFileName)
        let iisName = Configuration.getProjectIISName projectName Configuration.getCurrent

        if (configurationNotExists iisName) then createConfiguration iisName enableHttps

        let cmd = @"C:\Windows\Microsoft.NET\Framework\v4.0.30319\msbuild.exe"
        let args = sprintf @"%s /p:Configuration=%s /p:DeployOnBuild=true /P:ContinueOnError=false /P:AllowUntrustedCertificate=True /P:CreatePackageOnPublish=True /P:WebPublishPipelineProjectName=%s /P:DeployTarget=Package /p:PackageLocation=%s /P:VisualStudioVersion=14.0" projectPath buildType iisName packagePath
        let dir = ""
        Command.execute cmd args dir

        Unzip tempDir packagePath

        let webConfigPath = if projectFileName.Contains("FakeGameWebsite")
                                then Settings.getConfigPath tempDir "GameWebsite" "web.config"
                                else Settings.getConfigPath tempDir projectFileName "web.config"

        let sourcePath = Path.GetDirectoryName(webConfigPath)
        let destinationPath = @"C:\inetpub\wwwroot" @@ iisName

        Settings.updateWebConfig appSettings projectFileName webConfigPath

        if iisName.Contains("admin-website")
            then let jsConfigPath = Settings.getConfigPath tempDir projectFileName "config.js"
                 Settings.updateJsConfigForAdminApi jsConfigPath

        let cmd = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
        let args = sprintf "-verb:sync -source:contentPath=\"%s\" -dest:contentPath=\"%s\",ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" sourcePath destinationPath MSDeployTargetComputerName MSDeployUserName MSDeployPassword
        let dir = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"
        Command.execute cmd args dir

        if iisName.Contains("admin-website")
            then setWritable (sprintf "C:\inetpub\wwwroot\%s\Uploads" iisName)

        CleanDir tempDir

module Tests = 
    let run includeCategory = 
        let testsDll = @"Tests\bin\" + buildType + @"\AFT.RegoV2.Tests.dll;
        Bonus.Tests\bin\" + buildType + @"\AFT.RegoV2.Bonus.Tests.dll;
        Infrastructure\WebServices\AdminApi.Tests\bin\" + buildType + @"\AFT.RegoV2.AdminApi.Tests.dll;
        Infrastructure\WebServices\MemberApi.Tests\bin\" + buildType + @"\AFT.RegoV2.MemberApi.Tests.dll"

        let nunitLauncherPath = @"../../plugins/dotnetPlugin/bin/JetBrains.BuildServer.NUnitLauncher.exe"
        let nunitParams = sprintf "v4.0 x64 NUnit-2.6.3 /category-include:%s %s" includeCategory testsDll
        let dotCoverFileName = "DotCover.snapshot"
        let filters = "+:*AFT.RegoV2.Core*"

        let dotCoverParams = 
            (fun p -> { p with
                            ToolPath = @"../../tools/DotCover/dotcover.exe"
                            TargetExecutable = nunitLauncherPath
                            TargetArguments = nunitParams
                            TargetWorkingDir = currentDirectory
                            Output = dotCoverFileName
                            Filters = filters })

        let getUniqueName fileName =
            let rnd : string = (new System.Random()).Next(1, Int32.MaxValue).ToString()
            sprintf "%s%s" rnd fileName

        try
            DotCover dotCoverParams
        finally
            let randomFileName = getUniqueName dotCoverFileName
            Rename randomFileName dotCoverFileName
            sendToTeamCity "##teamcity[importData type='dotNetCoverage' tool='dotcover' path='%s']" randomFileName

module WinService = 
    let execute action isBonus = 
        let remoteCmd = 
            if (action.Equals("stop"))
                then sprintf "sc stop %s" (Configuration.getWinServiceName(Configuration.getCurrent.ToString()) isBonus)
                else if (action.Equals("uninstall"))
                        then sprintf "sc delete %s" (Configuration.getWinServiceName(Configuration.getCurrent.ToString()) isBonus)
                        else sprintf "%s %s" (Configuration.getWinServiceFullPath(Configuration.getCurrent.ToString()) isBonus) action

        let cmd = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
        let args = sprintf "-verb:sync -source:runCommand -dest:runCommand=\"%s\",waitinterval=60000,ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" remoteCmd MSDeployTargetComputerName MSDeployUserName MSDeployPassword
        let dir = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"

        // Temporary workaround until everyone updates their branches with correct winservice assembly name
        let remoteCmd2 = 
            if (action.Equals("stop"))
                then sprintf "sc stop %s" (sprintf @"WinService.%s" (Configuration.getCurrent.ToString()))
                else if (action.Equals("uninstall"))
                        then sprintf "sc delete %s" (sprintf @"WinService.%s" (Configuration.getCurrent.ToString()))
                        else ""
        let args2 = sprintf "-verb:sync -source:runCommand -dest:runCommand=\"%s\",waitinterval=60000,ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" remoteCmd2 MSDeployTargetComputerName MSDeployUserName MSDeployPassword
        // Remove later

        if (action.Equals("stop") || action.Equals("uninstall"))
            then Shell.Exec(cmd, args, dir) |> ignore
                 Shell.Exec(cmd, args2, dir) |> ignore
            else Command.execute cmd args dir

module Database = 
    let getErrorsFromEventsTable () : List<string> = 
        let db = new DbContext((Configuration.getDbConnectionString databaseUrl))
        let query = sprintf "SELECT [Data] FROM [RegoV2-%s].[event].[Events] Where [DataType] = 'ErrorRaised'" (Configuration.getPrefix(Configuration.getCurrent))
        let result = db.Database.SqlQuery<string>(query).ToList()
        result
    let getIsAllEventsPublished() : bool = 
        let queryGetEvents state = (sprintf "SELECT Count(*) FROM [RegoV2-%s].[event].[Events] where [State] = %i" (Configuration.getPrefix(Configuration.getCurrent))) state
        try
            let db = new DbContext((Configuration.getDbConnectionString databaseUrl))
            let newEventsCount = db.Database.SqlQuery<int>(queryGetEvents 0).First()
            let publishedEventsCount = db.Database.SqlQuery<int>(queryGetEvents 1).First()
            if newEventsCount = 0 && publishedEventsCount > 0 then
                true
            else
                false
        with
        | ex -> printfn "getIsAllEventsPublished raised an exception: %s" (ex.ToString()); false

module Nuget = 
    let pack projectPath = 
        let cmd = currentDirectory @@ ".nuget" @@ "nuget.exe"
        //let args = sprintf "pack \"%s\" -Build -Properties Configuration=%s" projectPath buildType
        let args = sprintf "pack \"%s\"" projectPath
        let dir = currentDirectory

        Command.execute cmd args dir

    let pushAllPackages packagesPrefix =
        let cmd = currentDirectory @@ ".nuget" @@ "nuget.exe"
        let args = sprintf @"push %s -s https://feed.flycowdev.com:443/ 0a276e71-395e-4ccc-b747-48ccdd20def0  -Config .nuget/NuGet.Config" packagesPrefix
        let dir = currentDirectory

        Command.execute cmd args dir

//#endregion

//#region Build Steps
let mutable currentStep = ""

let solutionPath = "RegoV2.sln"

Target (BuildStep.StopWinService.ToString()) (fun _ ->
    currentStep <- BuildStep.StopWinService.ToString()

    WinService.execute "stop" false
    WinService.execute "uninstall" false
)

Target (BuildStep.StopBonusWinService.ToString()) (fun _ ->
    currentStep <- BuildStep.StopWinService.ToString()

    WinService.execute "stop" true
    WinService.execute "uninstall" true
)

Target (BuildStep.PackageRestore.ToString()) (fun _ ->
    currentStep <- BuildStep.PackageRestore.ToString()

    let cmd = @".nuget\NuGet.exe"
    let args = sprintf @"restore %s" solutionPath
    let dir = ""

    Command.execute cmd args dir
)

Target (BuildStep.Build.ToString()) (fun _ ->
    currentStep <- BuildStep.Build.ToString()

    let targets = ["Clean"; "Build"]
    let toolsVersion = "14.0"

    let setParams defaults =
        { defaults with
            Verbosity = Some(Quiet)
            Targets = targets
            NodeReuse = false
            RestorePackagesFlag = false
            Properties =
                [
                    "Optimize", "True"
                    "DebugSymbols", "True"
                    "Configuration", buildType
                ]
            ToolsVersion = Some(toolsVersion)
        }

    build setParams solutionPath
        |> DoNothing
)

Target (BuildStep.DeployWinServiceBinaries.ToString()) (fun _ ->
    currentStep <- BuildStep.DeployWinServiceBinaries.ToString()

    let tempDir = currentDirectory @@ "tmp"
    let source = currentDirectory @@ "WinService" @@ "bin" @@ buildType
    let destination = DirectoryName (Configuration.getWinServiceFullPath(Configuration.getCurrent.ToString()) false)

    CopyDir tempDir source (fun _ -> true)

    let appSettings = new Dictionary<string, string>()
    appSettings.Add("WinServiceName", (sprintf @"AFT.RegoV2.WinService.%s" (Configuration.getCurrent.ToString())))
    appSettings.Add("InstanceName", Configuration.instanceName)

    appSettings.Add("dbsettings:OperatorApiUrl", (Configuration.operatorApiUrl))
    appSettings.Add("dbsettings:GameApiUrl", (Configuration.getFullWebsiteUrl "FakeUgs" Configuration.getCurrent false))    
    appSettings.Add("dbsettings:AdminApiUrl", (Configuration.getFullWebsiteUrl "AdminApi" Configuration.getCurrent httpsEnabled))
    appSettings.Add("dbsettings:MemberApiUrl", (Configuration.getFullWebsiteUrl "MemberApi" Configuration.getCurrent false))
    appSettings.Add("dbsettings:BonusApiUrl", (Configuration.getFullWebsiteUrl "BonusApi" Configuration.getCurrent httpsEnabled))
    appSettings.Add("dbsettings:MemberWebsiteUrl", (Configuration.getFullWebsiteUrl "MemberWebsite" Configuration.getCurrent false))
    appSettings.Add("dbsettings:AdminWebsiteUrl", (Configuration.getFullWebsiteUrl "AdminWebsite" Configuration.getCurrent httpsEnabled))
    appSettings.Add("dbsettings:GameWebsiteUrl", (Configuration.getFullWebsiteUrl "FakeGameWebsite" Configuration.getCurrent false))
    appSettings.Add("dbsettings:PaymentProxyUrl", (Configuration.getFullWebsiteUrl "FakePaymentServer" Configuration.getCurrent false))
    appSettings.Add("dbsettings:PaymentNotifyUrl", (Configuration.getFullWebsiteUrl "MemberWebsite" Configuration.getCurrent false))
    appSettings.Add("dbsettings:wsb.httpport", Configuration.Wsb.HttpPort)
    appSettings.Add("dbsettings:wsb.tcpport", Configuration.Wsb.TcpPort)
    appSettings.Add("dbsettings:wsb.namespace", Configuration.Wsb.Namespace)
    appSettings.Add("dbsettings:wsb.host", Configuration.Wsb.Host)
    appSettings.Add("dbsettings:wsb.username", Configuration.Wsb.Username)
    appSettings.Add("dbsettings:wsb.password", Configuration.Wsb.Password)
    appSettings.Add("dbsettings:wsb.userdomain", Configuration.Wsb.UserDomain)
    appSettings.Add("dbsettings:ugsbus.connectionString", Configuration.Ugsbus.ConnectionString)

    if ( Configuration.getPrefix(Configuration.getCurrent).StartsWith("qa") ) 
        then appSettings.Add("EnableEmails", "true")

    let winServiceConfigPath = tempDir @@ "AFT.RegoV2.WinService.exe.config"

    Settings.updateWinServiceConfig appSettings false winServiceConfigPath

    let preSyncFilePath = currentDirectory @@ "PreSync.bat"
    let preSyncCommandLine = sprintf @"WMIC PROCESS WHERE ""ExecutablePath ='%s'"" delete" ((Configuration.getWinServiceFullPath(Configuration.getCurrent.ToString()) false).Replace(@"\", @"\\"))
    System.IO.File.WriteAllText(preSyncFilePath, preSyncCommandLine)

    let cmd = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
    let args = sprintf "-verb:sync -preSync:runCommand=\"%s\",waitinterval=15000,successReturnCodes=0 -source:contentPath=\"%s\" -dest:contentPath=\"%s\",ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" preSyncFilePath tempDir destination MSDeployTargetComputerName MSDeployUserName MSDeployPassword
    let dir = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"

    Command.execute cmd args dir

    CleanDir tempDir
)

Target (BuildStep.DeployBonusWinServiceBinaries.ToString()) (fun _ ->
    currentStep <- BuildStep.DeployWinServiceBinaries.ToString()

    let tempDir = currentDirectory @@ "tmp"
    let source = currentDirectory @@ "Bonus" @@ "WinService" @@ "bin" @@ buildType
    let destination = DirectoryName (Configuration.getWinServiceFullPath(Configuration.getCurrent.ToString()) true)

    CopyDir tempDir source (fun _ -> true)

    let appSettings = new Dictionary<string, string>()
    appSettings.Add("BonusWinServiceName", (sprintf @"AFT.RegoV2.Bonus.WinService.%s" (Configuration.getCurrent.ToString())))
    appSettings.Add("InstanceName", Configuration.instanceName)

    let winServiceConfigPath = tempDir @@ "AFT.RegoV2.Bonus.WinService.exe.config"

    Settings.updateWinServiceConfig appSettings true winServiceConfigPath

    let preSyncFilePath = currentDirectory @@ "PreSync.bat"
    let preSyncCommandLine = sprintf @"WMIC PROCESS WHERE ""ExecutablePath ='%s'"" delete" ((Configuration.getWinServiceFullPath(Configuration.getCurrent.ToString()) true).Replace(@"\", @"\\"))
    System.IO.File.WriteAllText(preSyncFilePath, preSyncCommandLine)

    let cmd = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
    let args = sprintf "-verb:sync -preSync:runCommand=\"%s\",waitinterval=15000,successReturnCodes=0 -source:contentPath=\"%s\" -dest:contentPath=\"%s\",ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" preSyncFilePath tempDir destination MSDeployTargetComputerName MSDeployUserName MSDeployPassword
    let dir = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"

    Command.execute cmd args dir

    CleanDir tempDir
)

Target (BuildStep.DropDatabase.ToString()) (fun _ ->
    currentStep <- BuildStep.DropDatabase.ToString()

    let configurationPrefix = Configuration.getPrefix(Configuration.getCurrent)
    let DBName = sprintf "RegoV2-%s" configurationPrefix
    let DBUserName = "sa"
    let DBPassword = "ch6kaCru"
    let DBAddress = databaseUrl

    let cmd = @"sqlcmd"
    let args1 = sprintf "-S %s -U \"%s\" -P \"%s\" -q \"ALTER DATABASE [%s] SET SINGLE_USER WITH ROLLBACK IMMEDIATE\"" DBAddress DBUserName DBPassword DBName
    let args2 = sprintf "-S %s -U \"%s\" -P \"%s\" -q \"DROP DATABASE [%s]\"" DBAddress DBUserName DBPassword DBName
    let dir = ""

    Command.execute cmd args1 dir
    Command.execute cmd args2 dir
)

Target (BuildStep.UpdateTestsConfig.ToString()) (fun _ ->
    currentStep <- BuildStep.UpdateTestsConfig.ToString()
    
    let portNumber = 
        if ((Configuration.agentName).StartsWith("Agent"))
            then (Configuration.agentName.[Configuration.agentName.Length - 1].ToString())
            else "5"

    let appSettings = new Dictionary<string, string>()
    appSettings.Add("TestServerUri", ("http://localhost:555" + portNumber))
    appSettings.Add("ScreenshotsPath", (Configuration.getScreenshotsPath))
    appSettings.Add("InstanceName", Configuration.instanceName)

    let webConfigPath = currentDirectory @@ "Tests" @@ "bin" @@ buildType @@ "AFT.RegoV2.Tests.dll.config"

    Settings.updateWebConfig appSettings "" webConfigPath
)

Target (BuildStep.UpdateAdminApiTestsConfig.ToString()) (fun _ ->
    currentStep <- BuildStep.UpdateAdminApiTestsConfig.ToString()

    let appSettings = new Dictionary<string, string>()
    appSettings.Add("InstanceName", Configuration.instanceName)
    let webConfigPath = currentDirectory @@ "Infrastructure" @@ "WebServices" @@ "AdminApi.Tests" @@ "bin" @@ buildType @@ "AFT.RegoV2.AdminApi.Tests.dll.config"

    Settings.updateWebConfig appSettings "" webConfigPath
)

Target (BuildStep.UpdateMemberApiTestsConfig.ToString()) (fun _ ->
    currentStep <- BuildStep.UpdateMemberApiTestsConfig.ToString()

    let appSettings = new Dictionary<string, string>()
    appSettings.Add("InstanceName", Configuration.instanceName)

    let webConfigPath = currentDirectory @@ "Infrastructure" @@ "WebServices" @@ "MemberApi.Tests" @@ "bin" @@ buildType @@ "AFT.RegoV2.MemberApi.Tests.dll.config"

    Settings.updateWebConfig appSettings "" webConfigPath
)

Target (BuildStep.UpdateBonusApiTestsConfig.ToString()) (fun _ ->
    currentStep <- BuildStep.UpdateBonusApiTestsConfig.ToString()

    let appSettings = new Dictionary<string, string>()
    appSettings.Add("InstanceName", Configuration.instanceName)
    
    let webConfigPath = currentDirectory @@ "Bonus.Tests" @@ "bin" @@ buildType @@ "AFT.RegoV2.Bonus.Tests.dll.config"

    Settings.updateWebConfig appSettings "" webConfigPath
)

Target (BuildStep.CheckEventsTableBeforeTests.ToString()) (fun _ ->
    currentStep <- BuildStep.CheckEventsTableBeforeTests.ToString()

    printfn "Checking events db table before tests..."
    let errorsList = Database.getErrorsFromEventsTable()    
    printfn "Errors count is: %d" errorsList.Count
    if errorsList.Count > 0 then 
        sendStrToTeamCity (sprintf "##teamcity[buildProblem description='%d error(s) logged in Events db table BEFORE tests run!']" errorsList.Count)
        for errorItem in errorsList do
            printfn "Error details: %s" errorItem
        failwithf "%d error(s) logged in Events db table BEFORE tests run!" errorsList.Count
)

Target (BuildStep.CheckEventsTableAfterTests.ToString()) (fun _ ->
    currentStep <- BuildStep.CheckEventsTableAfterTests.ToString()

    printfn "Checking events db table after tests..."
    let errorsList = Database.getErrorsFromEventsTable()    
    printfn "Errors count is: %d" errorsList.Count
    if errorsList.Count > 0 then 
        sendStrToTeamCity (sprintf "##teamcity[buildProblem description='%d error(s) logged in Events db table AFTER tests run!']" errorsList.Count)
        for errorItem in errorsList do
            printfn "Error details: %s" errorItem
        failwithf "%d error(s) logged in Events db table AFTER tests run!" errorsList.Count
)

Target (BuildStep.RunUnitTests.ToString()) (fun _ ->
    currentStep <- BuildStep.RunUnitTests.ToString()

    let includeCategory = "Unit"
    Tests.run includeCategory
)

Target (BuildStep.RunIntegrationTests.ToString()) (fun _ ->
    currentStep <- BuildStep.RunIntegrationTests.ToString()

    let includeCategory = "Integration"
    Tests.run includeCategory
)

Target (BuildStep.RunSmokeTests.ToString()) (fun _ ->
    currentStep <- BuildStep.RunSmokeTests.ToString()

    let includeCategory = "Smoke"
    Tests.run includeCategory
)

Target (BuildStep.RunSeleniumTests.ToString()) (fun _ ->
    currentStep <- BuildStep.RunSeleniumTests.ToString()

    let includeCategory = "Selenium"
    Tests.run includeCategory
)

Target (BuildStep.RunSeleniumTestsMultipleTimes.ToString()) (fun _ ->
    currentStep <- BuildStep.RunSeleniumTestsMultipleTimes.ToString()

    let includeCategory = "Selenium"

    for i = 1 to (Configuration.buildStepRepeatCount) do
        try
            printfn "Running selenium tests (%i of %i)" i Configuration.buildStepRepeatCount
            Tests.run includeCategory
        with
            | _ -> ()
)

Target (BuildStep.PublishAdminApi.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishAdminApi.ToString()

    let projectPath = @"Infrastructure\WebServices\AdminApi\AdminApi.csproj"
    let projectName = "AdminApi"
    let appSettings = Configuration.getProjectSettings (fileNameWithoutExt projectPath)

    IIS.publishProject projectPath projectName appSettings httpsEnabled
)

Target (BuildStep.PublishMemberApi.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishMemberApi.ToString()

    let projectPath = @"Infrastructure\WebServices\MemberApi\MemberApi.csproj"
    let projectName = "MemberApi"
    let appSettings = Configuration.getProjectSettings (fileNameWithoutExt projectPath)

    IIS.publishProject projectPath projectName appSettings false
)

Target (BuildStep.PublishFakeUgs.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishFakeUgs.ToString()

    let projectPath = @"Tests\FakeUGS\FakeUGS.csproj"
    let projectName = "FakeUgs"
    let appSettings = Configuration.getProjectSettings projectName

    if ( Configuration.getPrefix(Configuration.getCurrent).StartsWith("integration") ) 
        then appSettings.Add("SkipIpValidation", "true")

    IIS.publishProject projectPath projectName appSettings false
)

Target (BuildStep.PublishBonusApi.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishBonusApi.ToString()

    let projectPath = @"Bonus\Api\Api.csproj"
    let projectName = "BonusApi"
    let appSettings = Configuration.getProjectSettings projectName

    IIS.publishProject projectPath projectName appSettings httpsEnabled
)

Target (BuildStep.PublishMemberWebsite.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishMemberWebsite.ToString()

    let projectPath = @"Presentation\MemberWebsite\MemberWebsite.csproj"
    let projectName = "MemberWebsite"
    let appSettings = Configuration.getProjectSettings (fileNameWithoutExt projectPath)

    IIS.publishProject projectPath projectName appSettings false
)

Target (BuildStep.PublishAdminWebsite.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishAdminWebsite.ToString()

    let projectPath = @"Presentation\AdminWebsite\AdminWebsite.csproj"
    let projectName = "AdminWebsite"
    let appSettings = Configuration.getProjectSettings (fileNameWithoutExt projectPath)

    IIS.publishProject projectPath projectName appSettings httpsEnabled
)

Target (BuildStep.PublishFakeGameWebsite.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishFakeGameWebsite.ToString()

    let projectPath = @"Presentation\GameWebsite\FakeGameWebsite.csproj"
    let projectName = "FakeGameWebsite"
    let appSettings = Configuration.getProjectSettings projectName

    IIS.publishProject projectPath projectName appSettings false
)

Target (BuildStep.PublishFakePaymentServer.ToString()) (fun _ ->
    currentStep <- BuildStep.PublishFakePaymentServer.ToString()

    let projectPath = @"FakePaymentServer\FakePaymentServer.csproj"
    let projectName = "FakePaymentServer"
    let appSettings = Configuration.getProjectSettings (fileNameWithoutExt projectPath)

    IIS.publishProject projectPath projectName appSettings false
)

Target (BuildStep.PackAndPublishWebsitesToNuGet.ToString()) (fun _ ->
    currentStep <- BuildStep.PackAndPublishWebsitesToNuGet.ToString()

    if (Configuration.action.StartsWith("update"))
        then
            let websites = new Dictionary<string, string>()
            websites.Add("AdminApi", @"Infrastructure\WebServices\AdminApi")
            websites.Add("MemberApi", @"Infrastructure\WebServices\MemberApi")
            websites.Add("FakeUGS", @"Tests\FakeUGS")
            websites.Add("Api", @"Bonus\Api")
            websites.Add("MemberWebsite", @"Presentation\MemberWebsite")
            websites.Add("AdminWebsite", @"Presentation\AdminWebsite")
            websites.Add("FakeGameWebsite", @"Presentation\GameWebsite")
            websites.Add("FakePaymentServer", @"FakePaymentServer")
            websites.Add("WinService", @"WinService")
            websites.Add("BonusWinService", @"Bonus\WinService")

            websites
                |> Seq.iter (fun website -> 
                                let projectName = website.Key.Replace("Bonus", "")
                                let projectPath = website.Value @@ projectName + ".csproj"

                                printfn "Going to pack %s project in %s" projectName projectPath

                                Nuget.pack projectPath
                             )

            Nuget.pushAllPackages "AFT.RegoV2.*.nupkg"
)

Target (BuildStep.RunProductionDeployment.ToString()) (fun _ ->
    currentStep <- BuildStep.RunProductionDeployment.ToString()

    let web1Name = @"https://10.251.2.100:8172/msdeploy.axd"
    let serverUser = @"REGODOMAIN\aft.robot"

    let sourcePath = currentDirectory @@ "DeploymentScripts"
    let destinationPath = @"E:\sites\rego\tools\Scripts\Deployment\"

    Command.execute "C:\scriptcs\scriptcs.exe" "-install" sourcePath

    let cmd = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"
    let args = sprintf "-verb:sync -source:dirPath=\"%s\" -dest:dirPath=\"%s\",ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" sourcePath destinationPath web1Name serverUser Configuration.serverPassword
    let dir = @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3"

    Command.execute cmd args dir

    let runBuildCommandLine = sprintf @"C:\scriptcs\scriptcs.exe E:\sites\rego\tools\Scripts\Deployment\RunBuildCommand.csx -- --version v%s --action %s --dropDb %s" Configuration.version Configuration.action Configuration.dropDb
    let args2 = sprintf "-verb:sync -source:runCommand -dest:runCommand=\"%s\",waitinterval=300000,dontUseCommandExe=false,ComputerName=\"%s\",UserName=\"%s\",Password=\"%s\",AuthType=\"Basic\" -allowUntrusted" runBuildCommandLine web1Name serverUser Configuration.serverPassword

    Command.execute cmd args2 dir
)

Target (BuildStep.PingWebsites.ToString()) (fun _ ->
    currentStep <- BuildStep.PingWebsites.ToString()

    if (Configuration.buildTarget.Equals("Staging"))
        then for i = 1 to 2 do
                Configuration.getAllStagingWebsitesUrls 
                    |> Seq.iter (fun url -> Command.httpPing url)
        else Configuration.getAllWebsitesUrls 
                |> Seq.iter (fun url -> Command.httpPing url)
)

Target (BuildStep.StartWinService.ToString()) (fun _ ->
    currentStep <- BuildStep.StartWinService.ToString()

    WinService.execute "install" false
    WinService.execute "start" false
)

Target (BuildStep.StartBonusWinService.ToString()) (fun _ ->
    currentStep <- BuildStep.StartWinService.ToString()

    WinService.execute "install" true
    WinService.execute "start" true
)

Target (BuildStep.WaitUntilInitialSeedingComplete.ToString()) (fun _ ->
    currentStep <- BuildStep.WaitUntilInitialSeedingComplete.ToString()
    
    printfn "Waiting for messages publishing to be completed"
    let mutable publishingAttemptsLeft = 30
    let mutable stillPublishing = true
    while stillPublishing do
        publishingAttemptsLeft <- publishingAttemptsLeft - 1
        if publishingAttemptsLeft < 0 then
            stillPublishing <- false
        else
            let allEventsPublished = Database.getIsAllEventsPublished()
            if allEventsPublished then
                stillPublishing <- false
            else
                printfn "Not all events have been published yet"
                Thread.Sleep(5000)

    printfn "Waiting for messages processing to be completed"
    // need to implement a real check of windows service bus state
    Thread.Sleep(30000)
)

Target (BuildStep.RunLoadTests.ToString()) (fun _ ->
    currentStep <- BuildStep.RunLoadTests.ToString()

    let cmd = sprintf @"%s\plugins\ant\bin\ant.bat" (Configuration.agentHomeDir.ToString())
    let args = sprintf "-DbuildNumber=%s -DconfigurationName=%s" (Configuration.buildNumber.ToString()) (BuildConfiguration.Load.ToString())
    let dir = @"Tests\jMeter"

    Command.execute cmd args dir
)

Target (BuildStep.RunSoakTests.ToString()) (fun _ ->
    currentStep <- BuildStep.RunSoakTests.ToString()

    let cmd = sprintf @"%s\plugins\ant\bin\ant.bat" (Configuration.agentHomeDir.ToString())
    let args = sprintf "-DbuildNumber=%s -DconfigurationName=%s" (Configuration.buildNumber.ToString()) (BuildConfiguration.Soak.ToString())
    let dir = @"Tests\jMeter"

    Command.execute cmd args dir
)

Target (BuildStep.ActivateFinalTargets.ToString()) (fun _ ->
    if ((Configuration.buildTarget.Equals("Staging") |> not) &&
        (currentStep.Equals(BuildStep.RunSmokeTests.ToString()) || 
         currentStep.Equals(BuildStep.RunSeleniumTests.ToString()) || 
         currentStep.Equals(BuildStep.RunSeleniumTestsMultipleTimes.ToString())))
        then ActivateBuildFailureTarget (BuildStep.CheckEventsTableAfterTests.ToString())

    currentStep <- BuildStep.ActivateFinalTargets.ToString()

    ActivateBuildFailureTarget (BuildStep.GenerateScreenshotsIndex.ToString())

    ActivateBuildFailureTarget (BuildStep.ReportBuildStatus.ToString())

    ActivateBuildFailureTarget (BuildStep.CleanupJMeterReport.ToString())

    ActivateFinalTarget (BuildStep.GenerateLogsIndex.ToString())
)

Target (BuildStep.GenerateJMeterIndex.ToString()) (fun _ ->
    currentStep <- BuildStep.GenerateJMeterIndex.ToString()

    let artifactsDir = sprintf @"C:\RegoV2-Perf\%s\%s\html" (Configuration.getCurrent.ToString()) (Configuration.buildNumber.ToString())
    let getHtmlLink file = sprintf @"<li><a href=""%s"">%s</a></li>" file file
    let content = Directory.GetFiles(artifactsDir, "*.html") |> Array.map (fun file -> getHtmlLink (filename file)) |> String.concat ""
    let getIndexHtml content = sprintf "<!DOCTYPE html><html><body><h2>Tests results:</h2><ul>%s</ul></body></html>" content
    WriteStringToFile false (artifactsDir @@ "index.html") (getIndexHtml content)
)

Target (BuildStep.CreateServiceBusNamespace.ToString()) (fun _ ->
    currentStep <- BuildStep.CreateServiceBusNamespace.ToString()
    
    printfn "Sb namespace to be created: %s" Configuration.Wsb.Namespace

    let powershellCommand = sprintf @"& {Invoke-Command -ScriptBlock { &'C:\Program Files\Service Bus\1.1\Scripts\ImportServiceBusModule.ps1' ; New-SBNamespace -Name %s -ManageUsers ServiceBusRobot }} " Configuration.Wsb.Namespace
    let encodedCommand = Convert.ToBase64String(Encoding.Unicode.GetBytes(powershellCommand))
    let cmd = sprintf @"%%WINDIR%%\System32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy RemoteSigned -encodedCommand %s" encodedCommand
    let errorCode = Command.executeRemotely cmd MSDeployServicebusComputerName
    if errorCode <> 0 then failwithf "Servicebus namespace creation failed with code: %i" errorCode
)

BuildFailureTarget (BuildStep.CleanupJMeterReport.ToString()) (fun _ ->
    if (currentStep.Equals(BuildStep.RunSoakTests.ToString()))
        then CleanDir (sprintf @"C:\RegoV2-Perf\%s\%s\" (Configuration.getCurrent.ToString()) (Configuration.buildNumber.ToString()))
)

BuildFailureTarget (BuildStep.GenerateScreenshotsIndex.ToString()) (fun _ ->
    if (currentStep.Equals(BuildStep.RunSmokeTests.ToString()) || 
        currentStep.Equals(BuildStep.RunSeleniumTests.ToString()) || 
        currentStep.Equals(BuildStep.RunSeleniumTestsMultipleTimes.ToString()))
        then let artifactsDir = Configuration.getScreenshotsPath
             let getHtmlLink file = sprintf @"<li><a href=""%s"">%s</a></li>" file file
             if (directoryExists artifactsDir) 
                 then let content = seq { yield! Directory.GetFiles(artifactsDir, "*.png") } |> Seq.map (fun file -> getHtmlLink (filename file)) |> String.concat ""
                      let getIndexHtml content = sprintf "<!DOCTYPE html><html><body><h2>Failed tests screenshots:</h2><ul>%s</ul></body></html>" content
                      WriteStringToFile false (artifactsDir @@ "index.html") (getIndexHtml content)
)

BuildFailureTarget (BuildStep.ReportBuildStatus.ToString()) (fun _ ->
    sendTeamCityError (sprintf "{build.status.text} in \"%s\" build step" currentStep)
)

FinalTarget (BuildStep.GenerateLogsIndex.ToString()) (fun _ ->
    let logsUrl = @"http://regov2logs.flycowdev.com"
    let projectsToLog = ["WinService"; "BonusWinService"; "FakeUgs"; "AdminApi"; "MemberApi"; "BonusApi"; "AdminWebsite"; "FakeGameWebsite"; "MemberWebsite"]
    let getHtmlLink linkName url = sprintf @"<li><a href=""%s"">%s</a></li>" url linkName
    let content = projectsToLog |> 
                    Seq.map (fun projectName -> 
                                    let logFileUrl = (logsUrl + (Configuration.getRelativeLogFilePath projectName).Replace(@"\", @"/"))
                                    if (Command.remoteFileExists logFileUrl)
                                        then getHtmlLink projectName logFileUrl
                                        else "") |> String.concat ""
    let getIndexHtml content = sprintf "<!DOCTYPE html><html><body><h2>Collected logs:</h2><ul>%s</ul></body></html>" content
    WriteStringToFile false (currentDirectory @@ "logs.html") (getIndexHtml content)
)

//#endregion Build Steps

//#region Build Configurations

Target (BuildConfiguration.DevelopUnit.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.RunUnitTests.ToString()
          
    RunTargetOrDefault (BuildStep.RunUnitTests.ToString())
)

Target (BuildConfiguration.DevelopIntegration.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunIntegrationTests.ToString()
          ==> BuildStep.RunSmokeTests.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.DevelopSelenium.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunIntegrationTests.ToString()
          ==> BuildStep.RunSeleniumTests.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.DevelopSeleniumMultipleTimes.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunSeleniumTestsMultipleTimes.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.QA.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunIntegrationTests.ToString()
          ==> BuildStep.RunSeleniumTests.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.QA2_1.ToString()) (fun _ ->
    RunTargetOrDefault (BuildConfiguration.QA.ToString())
)

Target (BuildConfiguration.QA2_2.ToString()) (fun _ ->
    RunTargetOrDefault (BuildConfiguration.QA.ToString())
)

Target (BuildConfiguration.QA2_3.ToString()) (fun _ ->
    RunTargetOrDefault (BuildConfiguration.QA.ToString())
)

Target (BuildConfiguration.QA2_4.ToString()) (fun _ ->
    RunTargetOrDefault (BuildConfiguration.QA.ToString())
)

Target (BuildConfiguration.QA2_5.ToString()) (fun _ ->
    RunTargetOrDefault (BuildConfiguration.QA.ToString())
)

Target (BuildConfiguration.QA2_6.ToString()) (fun _ ->
    RunTargetOrDefault (BuildConfiguration.QA.ToString())
)

Target (BuildConfiguration.Demo.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunIntegrationTests.ToString()
          ==> BuildStep.RunSeleniumTests.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.UIUX.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunSmokeTests.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.IntegrationDev1.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()

    RunTargetOrDefault (BuildStep.StartBonusWinService.ToString())
)

Target (BuildConfiguration.IntegrationStaging1.ToString()) (fun _ ->
    RunTargetOrDefault (BuildConfiguration.IntegrationDev1.ToString())
)

Target (BuildConfiguration.UgsIntegrationDemo.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunSmokeTests.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.UgsIntegrationTests.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.CheckEventsTableBeforeTests.ToString()
          ==> BuildStep.RunIntegrationTests.ToString()
          ==> BuildStep.RunSmokeTests.ToString()
          ==> BuildStep.CheckEventsTableAfterTests.ToString()

    RunTargetOrDefault (BuildStep.CheckEventsTableAfterTests.ToString())
)

Target (BuildConfiguration.Load.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.RunLoadTests.ToString()
          ==> BuildStep.GenerateJMeterIndex.ToString()

    RunTargetOrDefault (BuildStep.GenerateJMeterIndex.ToString())
)

Target (BuildConfiguration.Soak.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.StopWinService.ToString()
          ==> BuildStep.StopBonusWinService.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.DeployWinServiceBinaries.ToString()
          ==> BuildStep.DeployBonusWinServiceBinaries.ToString()
          ==> BuildStep.DropDatabase.ToString()
          ==> BuildStep.PublishAdminApi.ToString()
          ==> BuildStep.PublishMemberApi.ToString()
          ==> BuildStep.PublishFakeUgs.ToString()
          ==> BuildStep.PublishBonusApi.ToString()
          ==> BuildStep.PublishMemberWebsite.ToString()
          ==> BuildStep.PublishAdminWebsite.ToString()
          ==> BuildStep.PublishFakeGameWebsite.ToString()
          ==> BuildStep.PublishFakePaymentServer.ToString()
          ==> BuildStep.CreateServiceBusNamespace.ToString()
          ==> BuildStep.StartWinService.ToString()
          ==> BuildStep.StartBonusWinService.ToString()
          ==> BuildStep.WaitUntilInitialSeedingComplete.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.RunSoakTests.ToString()
          ==> BuildStep.GenerateJMeterIndex.ToString()

    RunTargetOrDefault (BuildStep.GenerateJMeterIndex.ToString())
)

Target (BuildConfiguration.Staging.ToString()) (fun _ ->
    let buildSteps =
        BuildStep.ActivateFinalTargets.ToString()
          ==> BuildStep.PackageRestore.ToString()
          ==> BuildStep.Build.ToString()
          ==> BuildStep.UpdateTestsConfig.ToString()
          ==> BuildStep.UpdateAdminApiTestsConfig.ToString()
          ==> BuildStep.UpdateMemberApiTestsConfig.ToString()
          ==> BuildStep.UpdateBonusApiTestsConfig.ToString()
          ==> BuildStep.PackAndPublishWebsitesToNuGet.ToString()
          ==> BuildStep.RunProductionDeployment.ToString()
          ==> BuildStep.PingWebsites.ToString()
          ==> BuildStep.RunSmokeTests.ToString()

    RunTargetOrDefault (BuildStep.RunSmokeTests.ToString())
)
//#endregion

RunTargetOrDefault (Configuration.buildTarget)