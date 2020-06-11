namespace Mocosha.Monytool.Core

open System
open System.ServiceProcess
open System.Management
open System.Diagnostics
open System.Globalization
open Microsoft.Win32
open System.Text.RegularExpressions
open System.Reflection
open NLog

type ServiceInfo = 
    { Name : string
      ServerName : string
      Status : string
      CpuUsage : int 
      InstanceName : string 
      ProcessName : string 
      FileVersion : string
      ProductVersion : string
      AssemblyVersion : string }

type ServiceMonitor (serverName : string, serviceName : string) as x =
    
    let logger = LogManager.GetCurrentClassLogger ()
    let processCounter = new PerformanceCounter("Process", "% Processor Time")

    let monitorName = (x :> IMonitor).Name

    let getProcessIdByServiceName serviceName = 
        let qry = "SELECT PROCESSID FROM WIN32_SERVICE WHERE NAME = '" + serviceName + "'";
        use searcher = new ManagementObjectSearcher (qry)
        searcher.Get ()
        |> Seq.cast<ManagementObject>
        |> Seq.map(fun x -> UInt32.Parse(x.["PROCESSID"].ToString()))
        |> Seq.head

    let getProcessInstanceName (pid : uint32) = 
        let cat = new PerformanceCounterCategory("Process", serverName)
        cat.GetInstanceNames ()
        |> Seq.filter(fun instance->
            use cnt = new PerformanceCounter("Process", "ID Process", instance, serverName)
            try
                cnt.RawValue = int64 pid
            with
                | ex ->
                    logger.Error (ex, sprintf "Error getting process instance name; monitor=%s" monitorName)
                    false
        )
        |> Seq.tryHead

    let getExecutablePathForService (serviceName : string, registryView : RegistryView) =
        let registryPath = sprintf "SYSTEM\CurrentControlSet\Services\%s" serviceName
        let key = RegistryKey.OpenRemoteBaseKey(RegistryHive.LocalMachine, serverName, registryView).OpenSubKey(registryPath) 

        if isNull key then raise(RegistryKeyNotExists(sprintf "Registry key not exists for service %s!" serviceName))
        
        let value = key.GetValue("ImagePath").ToString()
        key.Close ()
        let value = if value.StartsWith("\"") then Regex.Match(value, "\"([^\"]+)\"").Groups.[1].Value else value
        Environment.ExpandEnvironmentVariables (value)

    let getFileProductAssemblyVersion (exePath : string) =
        let formattedExePath = sprintf "\\%s\%s" serverName (exePath.Replace(":", "$"))
        let fileVersion = FileVersionInfo.GetVersionInfo (formattedExePath)
        let assemblyVersion = AssemblyName.GetAssemblyName(formattedExePath).Version
        (fileVersion.FileVersion, fileVersion.ProductVersion, assemblyVersion.ToString())

    let getServiceInfo (serviceController : ServiceController) = 
        let fileVersion, productVersion, assemblyVersion = 
            try
                getExecutablePathForService (serviceController.ServiceName, RegistryView.Default)
                |> getFileProductAssemblyVersion
            with 
                | ex -> 
                    logger.Error (ex, sprintf "Error getting service info; monitor=%s" monitorName)
                    ("N/A", "N/A", "N/A")
                
        match serviceController.Status with
        | ServiceControllerStatus.Running -> 
            let pid = getProcessIdByServiceName serviceController.ServiceName   
        
            let instanceName = 
                match getProcessInstanceName pid with
                | Some instanceName -> instanceName
                | None -> "no instance"
        
            processCounter.InstanceName <- instanceName

            { Name = serviceController.ServiceName
              ServerName = serverName
              Status = serviceController.Status.ToString()
              CpuUsage = Convert.ToInt32(processCounter.NextValue())
              InstanceName = processCounter.InstanceName
              ProcessName = Process.GetProcessById(int pid, serverName).ProcessName 
              FileVersion = fileVersion
              ProductVersion = productVersion 
              AssemblyVersion = assemblyVersion }
        | _ ->
            { Name = serviceController.ServiceName
              ServerName = serverName
              Status = serviceController.Status.ToString()
              CpuUsage = 0
              InstanceName = ""
              ProcessName = "" 
              FileVersion = fileVersion
              ProductVersion = productVersion 
              AssemblyVersion = assemblyVersion }

    let findServiceController serviceName = 
        ServiceController.GetServices (serverName)
        |> Seq.filter (fun sc -> sc.ServiceName = serviceName)
        |> Seq.tryHead

    interface IMonitor with 
        member x.Name = sprintf "%s/%s/%s" (x.GetType().Name) serverName serviceName
        member x.GetInfo () =
            match findServiceController serviceName with
            | Some serviceController -> 
                let serviceInfo = getServiceInfo serviceController
                {Key = 
                    { Type = EntityTypeEnum.Service
                      Id = sprintf "%s/%s/%s" serviceInfo.ServerName serviceInfo.Name serviceInfo.InstanceName }
                 Values = 
                    [ { Key = "CpuUsage"
                        Value = serviceInfo.CpuUsage.ToString(CultureInfo.InvariantCulture)
                        FormattedValue = "" }
                      { Key = "ProcessName"
                        Value = serviceInfo.ProcessName.ToString(CultureInfo.InvariantCulture)
                        FormattedValue = "" }
                      { Key = "Status"
                        Value = serviceInfo.Status.ToString(CultureInfo.InvariantCulture)
                        FormattedValue = "" }
                      { Key = "FileVersion"
                        Value = serviceInfo.FileVersion
                        FormattedValue = "" }
                      { Key = "ProductVersion"
                        Value = serviceInfo.ProductVersion
                        FormattedValue = "" }
                      { Key = "AssemblyVersion"
                        Value = serviceInfo.AssemblyVersion
                        FormattedValue = "" } ]
                 TimeStamp = DateTime.UtcNow}
            | None -> 
                { Key = 
                    { Type = EntityTypeEnum.Service
                      Id = sprintf "%s/%s/%s" serverName serviceName "NO INSTANCE" }
                  Values = []
                  TimeStamp = DateTime.UtcNow }
        
