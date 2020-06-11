namespace Cronix.Tests

open System.Reflection
open System.ServiceProcess
open System.Threading

type DummyType() = 
    class
    end

module ServiceEnviroment =
    open System
    open System.IO
    open System.Diagnostics
    open System.Security

    let sourcePath = "../../../../docs/samples/CSharpSample/bin/debug"
    let enviromentPath = "../../../../envs"
    let executable = "CSharpSample.exe"
 
    let rec deleteDirectory targetPath =
        let target = new DirectoryInfo(targetPath)
        if target.Exists then
            seq { for directory in target.EnumerateDirectories() -> directory }
            |> Seq.iter(fun(dir) -> deleteDirectory dir.FullName)

    let copyExecutable source target = 
        let rec copyAll (source : DirectoryInfo) (target : DirectoryInfo) =
            if target.Exists = false then
                target.Create() |> ignore
            for file in source.GetFiles() do
                let path = Path.Combine(target.FullName, file.Name)
                file.CopyTo(path, true) |> ignore
            for dirSourceSub in source.GetDirectories() do
                let nexttargetSubDir = target.CreateSubdirectory(dirSourceSub.Name)     
                copyAll dirSourceSub nexttargetSubDir

        let copy source target =
            let dirSource = new DirectoryInfo(source)
            let dirTarget = new DirectoryInfo(target)
            copyAll dirSource dirTarget

        copy source target

    let deleteLogDir targetPath = 
        let logDir = IO.Path.Combine(targetPath, "logs")
        if Directory.Exists logDir then 
            Directory.EnumerateFiles(logDir) 
            |> Seq.iter (fun(f) -> File.Delete f) |> ignore

    let getTargetPath enviromentName = 
        let uri = new Uri(Assembly.GetAssembly(typedefof<DummyType>).CodeBase)
        let location = Path.GetDirectoryName(uri.LocalPath)
        let targetPath = Path.Combine(location, enviromentPath, enviromentName)
        let target = new DirectoryInfo(targetPath)
        target.FullName

    
    
    let isServiceInstalled serviceName =
        let service = ServiceController.GetServices() |> Array.tryFind(fun(s: System.ServiceProcess.ServiceController) -> s.ServiceName = serviceName)
        match service with
        | Some s -> true
        | _ -> false

    let executeCmd args = 
        let process' = new Process()
        let startInfo = new ProcessStartInfo()
        startInfo.WindowStyle <- System.Diagnostics.ProcessWindowStyle.Hidden;
        startInfo.FileName <- "cmd.exe"
        startInfo.Arguments <- args
        startInfo.RedirectStandardOutput <- true
        startInfo.RedirectStandardInput <- true
        startInfo.UseShellExecute <- false

        process'.StartInfo <- startInfo
        process'.Start() |> ignore
        process'.BeginOutputReadLine() |> ignore
        process'.OutputDataReceived.Add(fun(args) -> 
            Console.WriteLine("executeCmd: {0} {1}", args.Data, DateTime.Now))
        Thread.Sleep(1000) |> ignore

    let startService() =
        if isServiceInstalled "CSharpSample" then
           executeCmd "/C sc start CSharpSample"

    let uninstallService() =
        if isServiceInstalled "CSharpSample" then
           executeCmd "/C sc stop CSharpSample"
           executeCmd "/C sc delete CSharpSample"

    let loadUserPassword() =
        let password = File.ReadAllText("../../../../password.txt")
        let secured = new SecureString()
        for c in password.ToCharArray() do secured.AppendChar(c)
        secured   

    let createEnviroment enviromentName =
        uninstallService()
        let targetPath = getTargetPath enviromentName
        deleteDirectory targetPath
        copyExecutable sourcePath targetPath
        deleteLogDir targetPath

    let createEnviromentForRollbackWithFailure =
        uninstallService()
        let name = "rollback"
        createEnviroment name
        File.Delete("FSharp.Scheduler.dll")
        name