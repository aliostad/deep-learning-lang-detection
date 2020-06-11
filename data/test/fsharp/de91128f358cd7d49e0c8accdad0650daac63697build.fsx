// include Fake libs
#r "./packages/FAKE/tools/FakeLib.dll"

open System
open System.IO
open Fake
open Fake.Testing.Expecto

// Directories
let buildDir  = "./build/"
let clientDir = "./client/"
let deployDir = "./deploy/"
let testOutputDir = "./tests/"


type AzureCreds = {
    url : string
    username : string
    password : string
}


// Helper
let run' timeout cmd args dir =
    if execProcess (fun info ->
        info.FileName <- cmd
        if not (String.IsNullOrWhiteSpace dir) then
            info.WorkingDirectory <- dir
        info.Arguments <- args
    ) timeout |> not then
        failwithf "Error while running '%s' with args: %s" cmd args

let run = run' System.TimeSpan.MaxValue

let platformTool tool winTool =
    let tool = if isUnix then tool else winTool
    tool
    |> ProcessHelper.tryFindFileOnPath
    |> function Some t -> t | _ -> failwithf "%s not found" tool

let yarnTool = platformTool "yarn" "yarn.cmd"
let elmAnalyseTool = platformTool "elm-analyse" "elm-analyse.cmd"
let elmAppTool = platformTool "elm-app" "elm-app.cmd"
let winScpExePath = "./packages/WinSCP/content/WinSCP.exe"

let all _ = true

// Filesets
let appReferences  =
    !! "/**/*.csproj"
    ++ "/**/*.fsproj"

let testAssemblies = 
    "tests/*.Test.exe"

// version info
let version = "0.1"  // or retrieve from CI server

// Targets
Target "Clean" (fun _ ->
    CleanDirs [buildDir; testOutputDir; deployDir;] 
)

Target "BuildLocal" (fun _ ->
    let target = "Build"
    let parameters = [
            ("Configuration", "Debug"); 
            ("BuildProjectReferences", "true");
            ("TreatWarningsAsErrors", "true");
        ]
    let solution = [ "./SuaveHost/SuaveHost.fsproj" ]
    MSBuild buildDir target parameters solution
    |> Log "MSBuild Output: "
)
Target "BuildDeploy" (fun _ ->
    let target = "Build"
    let parameters = [
            ("Configuration", "Release"); 
            ("BuildProjectReferences", "true");
            ("TreatWarningsAsErrors", "true");
        ]
    let solution = [ "./SuaveHost/SuaveHost.fsproj" ]
    MSBuild deployDir target parameters solution
    |> Log "MSBuild Output: "
)

Target "BuildTests" (fun _ ->
    let target = "Build"
    let parameters = [
            ("Configuration", "Release"); 
            ("BuildProjectReferences", "true");
            ("TreatWarningsAsErrors", "true");
        ]
    let solution = [ "./Berechnung.Test/Berechnung.Test.fsproj" ]
    MSBuild testOutputDir target parameters solution
    |> Log "MSBuild Output: "
)

Target "PrepareClientDeployPre" (fun _ ->
    printfn "Copying production config to client dir:"
    let filename = "Config_prod.elm"
    let src = clientDir + filename
    let target = clientDir + "src/" + "Config.elm"
    CopyFile target src
    System.IO.File.SetLastWriteTimeUtc(target, DateTime.UtcNow)
)

Target "RestoreDevClientConfig" (fun _ ->
    printfn "Copying development config back to client dir:"
    let filename = "Config_dev.elm"
    let src = clientDir + filename
    let target = clientDir + "src/" + "Config.elm"
    CopyFile target src
    System.IO.File.SetLastWriteTimeUtc(target, DateTime.UtcNow)
)

Target "RunElmAnalyse" (fun _ ->
    run elmAnalyseTool "" clientDir
    
)

let buildClientCore ()=
    printfn "Yarn version:"
    run yarnTool "--version" clientDir
    //run yarnTool "install" clientDir
    printfn "Running elm-app to build the Elm app:"
    run elmAppTool "build" clientDir

Target "BuildClient" (fun _ ->
    buildClientCore ()
)

Target "BuildClientLocal" (fun _ ->
    buildClientCore ()
)

Target "RunTests" (fun _ ->
    !! testAssemblies
    |> Expecto (fun p ->
        { p with
            Parallel = false} )
)

Target "CopyLocal" (fun _ ->
    let copyToBuildDir = CopyFile buildDir   
    copyToBuildDir "SuaveHost/config.yaml"

    CopyFile (buildDir + "/SuaveHost.exe.config") "SuaveHost/app.config"
)

Target "CopyDeploy" (fun _ ->
    let copyToTempDir = CopyFile deployDir
    copyToTempDir "web.config"
    copyToTempDir "SuaveHost/config.yaml"
    CopyFile (deployDir + "/SuaveHost.exe.config") "SuaveHost/app.config"
)

Target "CopyClientDeploy" (fun _ ->
    printfn "*** Copying client to deployment directory ***"
    let builtClient = clientDir + "/build"
    CopyDir deployDir builtClient all
)

Target "CopyClientLocal" (fun _ ->
    printfn "*** Copying client to local build directory ***"
    let builtClient = clientDir + "/build"
    CopyDir buildDir builtClient all
)

Target "UploadToAzure" (fun _ ->
    printfn "*** Uploading to Azure ***"
    

    let credsFile = "azure_deployment_credentials.txt"

    let creds =
        if System.IO.File.Exists credsFile then
            let lines = System.IO.File.ReadAllLines credsFile
            {
                url = lines.[0]
                username = lines.[1]
                password = lines.[2]
            }
        else
            failwith <| (sprintf "Credentials file %s does not exist. Three lines: Url, Username, Password" credsFile)

    let connectionString = 
        sprintf "ftps://%s:%s@%s" creds.username creds.password creds.url

    let ftpCommand =
        sprintf """ /command "open %s" "synchronize remote -delete -criteria=either "".\deploy"" ""/site/wwwroot"" " "exit" """ connectionString

    let logfile = "azureuploadlog.txt"
    let logCommand = sprintf "/log=%s" logfile

    let commands = [
        "/console"
        "/nointeractiveinput"
        logCommand
        ftpCommand
    ]

    let finalCommand =
        List.fold (fun acc s -> acc + " " + s) "" commands


    System.IO.File.Delete logfile
    run winScpExePath finalCommand "."

    )

// Promote all staged files into the real application
Target "Deploy" (fun _ ->
    printfn "*** Finished deployment ***"
)
Target "LocalBuild" (fun _ ->
    printfn "*** Finished local build ***"
)
// Build order
"Clean"
    ==> "BuildLocal"
    ==> "CopyLocal"
    ==> "RestoreDevClientConfig"
    //==> "RunElmAnalyse"    
    ==> "BuildClientLocal"    
    ==> "CopyClientLocal"
    ==> "LocalBuild"

// Set up dependencies
"Clean"
    ==> "BuildDeploy"
    ==> "CopyDeploy"
    //==> "RunTests"
    ==> "PrepareClientDeployPre"    
    ==> "BuildClient"    
    ==> "CopyClientDeploy"
    ==> "UploadToAzure"
    ==> "Deploy"

RunTargetOrDefault "LocalBuild"
//RunTargetOrDefault "Deploy"