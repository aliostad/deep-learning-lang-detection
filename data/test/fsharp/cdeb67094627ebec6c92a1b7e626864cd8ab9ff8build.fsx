// include Fake lib
//#r @"D:/fake/tools/FakeLib.dll"
#I @"D:/fake/tools/"
#r @"FakeLib.dll"

open Fake
open Fake.Git
open System

let msdeployPath = getBuildParamOrDefault "msdeployPath" @"C:\Program Files (x86)\IIS\Microsoft Web Deploy V3\msdeploy.exe"

let getBuildParamEnsure name =
    let value = environVar name
    if isNullOrWhiteSpace value then failwithf "environVar of %s is null or whitespace" name
    else value

let slnFile = 
    !! "./**/*.sln"
    |> Seq.toList
    |> List.head
    |> getBuildParamOrDefault "slnFile"



let pkgProject pkgDir =
    let useConfig = getBuildParamEnsure "useConfig"
    
    let setParams defaults =
        {
            defaults with
                Verbosity = Some(Quiet)
                Targets = ["Build"]
                Properties =
                    [
                        "DeployOnBuild", "True"
                        "Configuration", useConfig
                        "PackageLocation", pkgDir
                    ]
        }
    
    (getBuildParamEnsure "csProjFile") |> build setParams

    
let deploy() =
    RestoreMSSolutionPackages (fun p -> p) slnFile

    let pkgDir = getBuildParamEnsure "pkgDir"
    let iisSiteName = getBuildParamEnsure "iisSiteName"

    let pkgFullPath = sprintf "%s/%s.zip" pkgDir iisSiteName
    let setParametersFile = sprintf "%s/%s.SetParameters.xml" pkgDir iisSiteName
    
    pkgProject pkgFullPath

    let deployUser = getBuildParamEnsure "deployUser" // 系统自身配置
    let deployPwd = getBuildParamEnsure "deployPwd"   // 系统自身配置
    let msDeployUrl = getBuildParamEnsure "msDeployUrl"

    let msdeployArgs = sprintf @"-source:package=""%s"" -dest:auto,computerName=""%s?site=%s"",userName=""%s"",password=""%s"",authtype=""Basic"",includeAcls=""False"" -verb:sync 
    -disableLink:AppPoolExtension -disableLink:ContentExtension -disableLink:CertificateExtension 
    -setParamFile:""%s"" -allowUntrusted -enableRule:AppOffline -setParam:name=""IIS Web Application Name"",value=""%s""" pkgFullPath msDeployUrl iisSiteName deployUser deployPwd setParametersFile iisSiteName
    
    let tracing = ProcessHelper.enableProcessTracing
    ProcessHelper.enableProcessTracing <- false
    let exitCode = ExecProcess (fun info ->
                    info.FileName <- msdeployPath
                    info.Arguments <- msdeployArgs) (TimeSpan.FromMinutes 5.0)
    if exitCode <> 0 then failwithf "deploy cmd failed with a non-zero exit code %d."  exitCode
    ProcessHelper.enableProcessTracing <- tracing


let backup onlineVersion =
    let pkgDir = getBuildParamEnsure "pkgDir"
    let iisSiteName = getBuildParamEnsure "iisSiteName"
    let deployUser = getBuildParamEnsure "deployUser" // 系统自身配置
    let deployPwd = getBuildParamEnsure "deployPwd"   // 系统自身配置
    let msDeployUrl = getBuildParamEnsure "msDeployUrl"
    
    let backupPath = sprintf "%s/backups/%s-before-%s.zip" pkgDir iisSiteName onlineVersion
    
    let sourceArg = sprintf @"-source:iisapp=""%s"",computerName=""%s?site=%s"",userName=""%s"",password=""%s"",authtype=""Basic"",includeAcls=""False""" iisSiteName msDeployUrl iisSiteName deployUser deployPwd
    let destArg = sprintf @"-dest:package=""%s"",computerName=""%s?site=%s"",userName=""%s"",password=""%s"",authtype=""Basic"",includeAcls=""False""" backupPath msDeployUrl iisSiteName deployUser deployPwd

    let backupArgs = sprintf @"-verb:sync -allowUntrusted %s %s" sourceArg destArg

    let tracing = ProcessHelper.enableProcessTracing
    ProcessHelper.enableProcessTracing <- false
    let exitCode = ExecProcess (fun info ->
                    info.FileName <- msdeployPath
                    info.Arguments <- backupArgs) (TimeSpan.FromMinutes 5.0)
                    
    if exitCode <> 0 then failwithf "backup failed with a non-zero exit code %d."  exitCode
    ProcessHelper.enableProcessTracing <- tracing


let ensureOnBranch branchNeeded =
    gitCommand null (sprintf "checkout %s"  branchNeeded)
    let branchName = getBranchName null
    if branchName <> branchNeeded then failwithf "you need do this only on [%s] branch,but now you are on [%s]" branchNeeded branchName
        
let ffMergeAndDeploy onBranch =
    let mergeFromBranch = getBuildParamEnsure "mergeFromBranch"

    merge null "--ff-only" ("origin/" + mergeFromBranch)

    if onBranch = "master" then
        let onlineDate = System.DateTime.Today.Date.ToString("yyyy-MM-dd")
        let tagName = getBuildParamEnsure "onlineTagName"
        gitCommand null (sprintf "tag -f -a v-%s-%s -m \"deploy %s to %s\"" tagName onlineDate mergeFromBranch onBranch)
        backup tagName
                
    deploy()

    let useRunnerAccountUrl = System.Text.RegularExpressions.Regex.Replace(environVar "CI_BUILD_REPO", @".*(@.+?)(:\d+)?/(.*)", "git$1:$3"); 

    gitCommand null (sprintf "remote set-url --push origin %s" useRunnerAccountUrl)

    gitCommand null "push --follow-tags"



Target "Deploy-To-PRE" (fun _ ->
    let branchPre = "pre"
    ensureOnBranch branchPre
        
    // 保证 pre 和 master 永远保持最新,即：在上pre这个过程里面，没有人越过上线。否则需要人为合并这部分数据过来 pre 上。
    merge null "--ff-only" "origin/master"
    
    ffMergeAndDeploy branchPre
)

Target "Online" (fun _ ->
    let branchMaster = "master"
    ensureOnBranch branchMaster    
    ffMergeAndDeploy branchMaster
)

Target "Deploy-To-IOC" (fun _ ->
    deploy()
)

Target "BuildSolution" (fun _ ->
    let setParams defaults =
        {
            defaults with
                Verbosity = Some(Quiet)
                Targets = ["Build"]
                Properties =
                    [
                        "Configuration","Release"
                    ]
        }
            
    RestoreMSSolutionPackages (fun p -> p) slnFile
    build setParams slnFile
)


Target "Rollback" (fun _ ->
    let invokeTime = getBuildParamEnsure "invokeTime" |> System.DateTime.Parse 
    let times = System.DateTime.Now - invokeTime
    if (System.DateTime.Now - invokeTime) > (System.TimeSpan.FromMinutes 1.0) then failwithf "该次操作已经失效,截止 %s,请重新发起操作" (invokeTime.AddMinutes(1.0).ToString "yyyy-MM-dd HH:mm:ss")
    
    let rollbackVersion = getBuildParamEnsure "rollbackVersion"
    let pkgDir = getBuildParamEnsure "pkgDir"
    let iisSiteName = getBuildParamEnsure "iisSiteName"
    let deployUser = getBuildParamEnsure "deployUser" // 系统自身配置
    let deployPwd = getBuildParamEnsure "deployPwd"   // 系统自身配置
    let msDeployUrl = getBuildParamEnsure "msDeployUrl"
    let backupPath = sprintf "%s/backups/%s-before-%s.zip" pkgDir iisSiteName rollbackVersion
    
    let sourceArg = sprintf @"-source:package=""%s"",computerName=""%s?site=%s"",userName=""%s"",password=""%s"",authtype=""Basic"",includeAcls=""False""" backupPath msDeployUrl iisSiteName deployUser deployPwd
    let destArg = sprintf @"-dest:iisapp=""%s"",computerName=""%s?site=%s"",userName=""%s"",password=""%s"",authtype=""Basic"",includeAcls=""False""" iisSiteName msDeployUrl iisSiteName deployUser deployPwd

    let rollbackArgs = sprintf @"-verb:sync -allowUntrusted %s %s" sourceArg destArg

    let trace = ProcessHelper.enableProcessTracing
    ProcessHelper.enableProcessTracing <- false
    let exitCode = ExecProcess (fun info ->
                    info.FileName <- msdeployPath
                    info.Arguments <- rollbackArgs) (TimeSpan.FromMinutes 5.0)
    ProcessHelper.enableProcessTracing <- trace
    if exitCode <> 0 then failwithf "rollback cmd failed with a non-zero exit code %d."  exitCode
)


Target "test" (fun _ ->
    printfn "before test------------>%b" ProcessHelper.enableProcessTracing
    printfn "after test------------>%b" ProcessHelper.enableProcessTracing
)


RunTargetOrDefault "BuildSolution"
