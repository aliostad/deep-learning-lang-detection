namespace ClusterManagement

type Plugin =
    | Ebs
    | S3fs
    member x.Name =
        match x with
        | Ebs -> "ebs"
        | S3fs -> "s3fs"
    
type PluginSetting =
    { ClusterSettingName: string; PluginSettingName : string }

type PluginOpt =
    { Option : string; Description : string }

type PluginInfo =
    { Plugin : Plugin; ImageName : string; Tag : string; Settings : PluginSetting list; CreateOpts : PluginOpt list }
    
module Plugins =
    let private nameMap, private imageMap, plugins =
        let (-->) s1 s2 = { ClusterSettingName = s1 ; PluginSettingName = s2 }
        let rawList =
            [ { Plugin = Ebs; ImageName = "rexray/ebs"; Tag = ""
                Settings =
                  [ "AWS_ACCESS_KEY_ID" --> "EBS_ACCESSKEY"
                    "AWS_ACCESS_KEY_SECRET" --> "EBS_SECRETKEY"
                    "AWS_REGION" --> "EBS_REGION" ]
                CreateOpts = [ { Option = "size"; Description = "the size of the volume in gigabytes" } ] }
              { Plugin = S3fs; ImageName = "rexray/s3fs"; Tag = ""
                Settings =
                  [ "AWS_ACCESS_KEY_ID" --> "S3FS_ACCESSKEY"
                    "AWS_ACCESS_KEY_SECRET" --> "S3FS_SECRETKEY"
                    "AWS_REGION" --> "S3FS_REGION" ]
                CreateOpts = [ { Option = "size"; Description = "the size of the volume in gigabytes" } ]  } ]
            |> List.map (fun p -> { p with Tag = DockerImages.getImageTag p.ImageName })
        rawList |> Seq.map (fun p -> p.Plugin, p) |> Map.ofSeq,
        rawList |> Seq.map (fun p -> p.ImageName, p) |> Map.ofSeq,
        rawList |> List.map (fun p -> p.Plugin)
    
    let getPlugin p =
        match nameMap.TryFind p with
        | Some pl -> pl
        | None -> failwithf "Plugin '%s' was not found" p.Name

    let listPlugins wrapProcess=
      async {
        let! (result:DockerWrapper.DockerPlugin list) =
            DockerWrapper.listPlugins()
            |> wrapProcess
            |> Proc.startAndAwait
        return
            result
            |> List.choose (fun p -> imageMap.TryFind p.Image)
      }
      
    

    let installPlugin wrapProcess (plugin:Plugin) (c:ClusterConfig.MyClusterConfig) =
      async {
        if Env.isVerbose then printfn "installing and starting plugin '%s'." plugin.Name

        let forceConfig name =
            match ClusterConfig.getConfig name c with
            | Some va -> va
            | None -> failwithf "Expected config %s" name

        let pluginInfo = getPlugin plugin
        let settingsCmdLine =
            pluginInfo.Settings
            |> Seq.map (fun s -> sprintf "%s=%s" s.PluginSettingName (forceConfig s.ClusterSettingName))
            |> fun set -> System.String.Join(" ", set)

        let! (result : ProcessResults<unit>) =
            (sprintf "plugin inspect %s " pluginInfo.ImageName)
            |> Arguments.OfWindowsCommandLine
            |> DockerWrapper.createProcess
            |> wrapProcess
            |> Proc.startRaw
        if result.ExitCode = 0 then
            // exists -> disable and set settings, like EBS_ACCESSKEY=%s EBS_SECRETKEY=%s EBS_REGION=%s
            do!
                (sprintf "plugin disable --force %s" pluginInfo.ImageName)
                |> Arguments.OfWindowsCommandLine
                |> DockerWrapper.createProcess
                |> CreateProcess.ensureExitCode
                |> wrapProcess
                |> Proc.startAndAwait
                |> Async.Ignore
            do!
                (sprintf "plugin set %s %s"
                    pluginInfo.ImageName settingsCmdLine)
                |> Arguments.OfWindowsCommandLine
                |> DockerWrapper.createProcess
                |> CreateProcess.ensureExitCode
                |> wrapProcess
                |> Proc.startAndAwait
                |> Async.Ignore
        else
            // Install docker plugin
            do!
                (sprintf "plugin install --disable --grant-all-permissions %s %s"
                    pluginInfo.ImageName settingsCmdLine)
                |> Arguments.OfWindowsCommandLine
                |> DockerWrapper.createProcess
                |> CreateProcess.ensureExitCode
                |> wrapProcess
                |> Proc.startAndAwait
                |> Async.Ignore

        // sudo docker plugin upgrade --skip-remote-check --grant-all-permissions rexray/ebs:0.9.0 rexray/ebs:0.8.2
        //
        do!
            (sprintf "plugin upgrade --skip-remote-check --grant-all-permissions %s %s:%s"
                pluginInfo.ImageName pluginInfo.ImageName pluginInfo.Tag)
            |> Arguments.OfWindowsCommandLine
            |> DockerWrapper.createProcess
            |> CreateProcess.ensureExitCode
            |> wrapProcess
            |> Proc.startAndAwait
            |> Async.Ignore

        do!
            (sprintf "plugin enable %s" pluginInfo.ImageName)
            |> Arguments.OfWindowsCommandLine
            |> DockerWrapper.createProcess
            |> CreateProcess.ensureExitCode
            |> wrapProcess
            |> Proc.startAndAwait
            |> Async.Ignore
      }
    
    let uninstallPlugin wrapProcess (plugin:Plugin) =
      async {
        if Env.isVerbose then printfn "removing plugin '%s'." plugin.Name
        
        let pluginInfo = getPlugin plugin
        
        let! (result : ProcessResults<unit>) =
            (sprintf "plugin inspect %s" pluginInfo.ImageName)
            |> Arguments.OfWindowsCommandLine
            |> DockerWrapper.createProcess
            |> wrapProcess
            |> Proc.startRaw
        if result.ExitCode = 0 then
            do!
                (sprintf "plugin disable --force %s" pluginInfo.ImageName)
                |> Arguments.OfWindowsCommandLine
                |> DockerWrapper.createProcess
                |> CreateProcess.ensureExitCode
                |> wrapProcess
                |> Proc.startAndAwait
                |> Async.Ignore
            do!
                (sprintf "plugin rm --force %s"
                    pluginInfo.ImageName)
                |> Arguments.OfWindowsCommandLine
                |> DockerWrapper.createProcess
                |> CreateProcess.ensureExitCode
                |> wrapProcess
                |> Proc.startAndAwait
                |> Async.Ignore
      }
    
    let listClusterPlugins cluster =
        listPlugins (DockerMachine.runSudoDockerOnNode cluster "master-01")
    
    let installToCluster cluster plugin =
      async {
        let i = Deploy.getInfoInternal cluster [||]
        for node in i.Nodes do
            do! installPlugin
                    (DockerMachine.runSudoDockerOnNode cluster node.Name)
                    plugin
                    i.ClusterConfig
      }
  
    let uninstallFromCluster cluster plugin =
      async {
        let i = Deploy.getInfoInternal cluster [||]
        for node in i.Nodes do
            do! uninstallPlugin
                    (DockerMachine.runSudoDockerOnNode cluster node.Name)
                    plugin
      }
      
    let ensurePluginInstalled cluster plugin =
      async {
        let! plugins = listPlugins (DockerMachine.runSudoDockerOnNode cluster "master-01")
        plugins
        |> Seq.exists (fun p -> p.Plugin = plugin)
        |> fun b -> if not b then failwithf "Plugin '%s' needs to be installed on cluster '%s' first!" plugin.Name cluster
      }