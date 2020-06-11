module TalBot.Agent.ServiceHelper

open System
open System.ServiceProcess
open System.Configuration.Install
open System.Collections
open Microsoft.Win32
open System.Diagnostics

type installParameters = {assemblyPath:string; serviceName:string; displayName:string; description:string; startType:ServiceStartMode; userName:string; password:string; dependencies:string[] }
let installService installParameters =
    let accountSettings () =
        match installParameters.userName with
        | null | "" -> (ServiceAccount.LocalSystem, "", "")
        | _ -> (ServiceAccount.User, installParameters.userName, installParameters.password)
             
    use processServiceInstaller = 
        let account,userName,password = accountSettings ()
        new ServiceProcessInstaller(Account=account,Username=userName,Password=password)
    
    use installer = 
        new ServiceInstaller(
            DisplayName=installParameters.displayName,
            Description=installParameters.description,
            ServiceName=installParameters.serviceName,
            StartType=installParameters.startType,
            Parent=processServiceInstaller)
    installer.ServicesDependedOn <- installParameters.dependencies

    let appPath = Process.GetCurrentProcess().MainModule.FileName
    installer.Context <- new InstallContext("",[|"assemblypath=" + appPath;|])
    
    let mutable state = new Hashtable();

    try
        installer.Install(state)
        installer.Commit(state)
    with
    | exn -> 
        installer.Rollback(state)
        raise (new Exception("Failed to install the service.", exn))

let setServiceArguments serviceName (arguments:string) =
    let serviceKeyName = sprintf "System\\CurrentControlSet\\Services\\%s" serviceName
    use serviceKey = Registry.LocalMachine.OpenSubKey(serviceKeyName, true)
        
    match serviceKey with
    | null -> ()
    | _ -> 
        let imagePath : string = serviceKey.GetValue("ImagePath").ToString()
        let imagePath2 = sprintf "%s %s" imagePath (arguments.Trim())
        serviceKey.SetValue("ImagePath", imagePath2)
        serviceKey.Close()

let uninstallService serviceName =
    let context = new InstallContext(null, null)
    use serviceInstaller = new ServiceInstaller(Context = context, ServiceName = serviceName)

    try
        serviceInstaller.Uninstall(null)
    with
    | exn -> raise (new Exception("Failed to uninstall the service.", exn))