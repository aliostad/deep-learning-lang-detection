namespace ClusterManagement

module DockerImages =
    type Image = { Name : string; Tag : string }
    let clusterManagementName, clusterManagementTag, clusterManagement =
        let clusterManagementName = "matthid/clustermanagement"
        let assembly = System.Reflection.Assembly.GetExecutingAssembly()
        let assemblyLocation = assembly.Location
        let versionInfo =
            if System.String.IsNullOrEmpty assemblyLocation then null else System.Diagnostics.FileVersionInfo.GetVersionInfo(assemblyLocation)
        let fileVersion = if isNull versionInfo then null else versionInfo.FileVersion
        let clusterManagementTag =
            if isNull fileVersion then
                    match assembly.GetCustomAttributes(typeof<System.Reflection.AssemblyFileVersionAttribute>, true)
                          |> Seq.tryHead with
                    | Some a ->
                        let attribute = a :?> System.Reflection.AssemblyFileVersionAttribute
                        attribute.Version
                    | None -> null
            else fileVersion
        clusterManagementName, clusterManagementTag,
        if System.String.IsNullOrEmpty clusterManagementTag then
            eprintfn "Could not read tag from FileVersion!"
            eprintfn "Assembly Location: %s" assemblyLocation
            eprintfn "Version Info: %A" versionInfo
            eprintfn "Tag: %s" clusterManagementTag
            clusterManagementName
        else sprintf "%s:%s" clusterManagementName clusterManagementTag


    let private plugins =
        let (-->) s1 s2 = { Name = s1; Tag = s2 }
        [ "rexray/ebs" --> "0.9.0"
          "rexray/s3fs" --> "0.9.0"
          clusterManagementName --> clusterManagementTag ]
        |> Seq.map (fun i -> i.Name, i)
        |> Map.ofSeq

    let getImageTag image =
        match plugins.TryFind image with
        | Some pl -> pl.Tag
        | None -> failwithf "Can not figure out which tag to use for image '%s'" image
        
module DockerWrapper =
    type HostSource =
        | Dir of string
        | NamedVolume of string
        override x.ToString() =
            match x with
            | Dir d -> d
            | NamedVolume n -> n
    type Mount = { HostSource : HostSource; ContainerDir : string }

    let dockerPath = ref "docker"
    let baseMounts = ref []

    let createProcess args =
        let env =
            System.Environment.GetEnvironmentVariables()
            |> Seq.cast<System.Collections.DictionaryEntry>
            |> Seq.map (fun kv -> string kv.Key, string kv.Value)
            |> Seq.toList

        CreateProcess.fromCommand (RawCommand (!dockerPath, args))
        |> CreateProcess.withWorkingDirectory (System.IO.Directory.GetCurrentDirectory())
        |> CreateProcess.withEnvironment env
    let createProcessWithOutput args =
        args
        |> createProcess
        |> CreateProcess.redirectOutput

    module ContainerInspect =
        // otherwise compiler needs inspect-example for projects referencing this assembly :(
        type internal InspectJson = FSharp.Data.JsonProvider< "inspect-example.json" >

        let internal getFirstInspectJson json =
            let json = InspectJson.Load(new System.IO.StringReader(json))
            json.[0]

        type InspectConfigLabels = { ComDockerSwarmServiceName : string option }
        type InspectConfig = { Labels : InspectConfigLabels }
        type InspectMount = { Name :string option; Source: string; Destination: string; Driver : string option}
        type Inspect =
            { Id : string; Name : string; Mounts : InspectMount list; Config : InspectConfig }

        //Config.Labels.ComDockerSwarmServiceName
        let parseInspect json =
            let tp = getFirstInspectJson json
            let parseMount (m:InspectJson.Mount) =
                { Name = m.Name; Source = m.Source; Destination = m.Destination; Driver = m.Driver }
            let parseLabels (m:InspectJson.Labels) =
                { ComDockerSwarmServiceName = m.ComDockerSwarmServiceName }
            let parseConfig (m:InspectJson.Config2) =
                { Labels = parseLabels m.Labels }
            {Id = tp.Id; Name= tp.Name; Mounts = tp.Mounts |> Seq.map parseMount |> Seq.toList; Config = parseConfig tp.Config }

    let ensureWorking() =
      async {
        do! CreateProcess.fromRawWindowsCommandLine !dockerPath "version"
            |> CreateProcess.redirectOutput
            |> CreateProcess.ensureExitCode
            |> Proc.startAndAwait
            |> Async.Ignore

        // Find our own container-id and save all binds for later mapping.
        if System.IO.File.Exists("/proc/self/cgroup") then
            let searchStr = ":/docker/"
            let cgroupString = System.IO.File.ReadAllLines("/proc/self/cgroup")
            let dockerId =
                cgroupString
                |> Seq.choose (fun l ->
                    let i = l.IndexOf(searchStr)
                    if i >= 0 then
                        Some <| l.Substring(i + searchStr.Length)
                    else None)
                |> Seq.filter (fun s -> s.Length > 0)
                |> Seq.tryHead
            match dockerId with
            | Some id ->
                Env.isContainerized <- true
                let! stdOut =
                    [| "inspect"; id |]
                    |> Arguments.OfArgs
                    |> createProcess
                    |> CreateProcess.redirectOutput
                    |> CreateProcess.ensureExitCode
                    |> CreateProcess.map (fun o -> o.Output)
                    |> Proc.startAndAwait

                let first = ContainerInspect.getFirstInspectJson stdOut
                let binds =
                    first.HostConfig.Binds
                    |> Seq.map (fun m ->
                        let s = m.Split [|':'|]
                        let host, container = s.[0], s.[1]
                        let source =
                            if host.StartsWith "/" then HostSource.Dir host else HostSource.NamedVolume host
                        { HostSource = source; ContainerDir = container })
                    |> Seq.toList
                baseMounts := binds
            | None ->
              if Env.isVerbose then
                printfn "Docker-Id not found in /proc/self/cgroup: '%s'" (System.String.Join(System.Environment.NewLine, cgroupString))
        else
          if Env.isVerbose && Env.isLinux then printfn "Could not find /proc/self/cgroup"
      }

    // outer container /c/test/dir/currentDir:/currentDir
    // now map /currentDir/test to /c/test/dir/currentDir
    let mapHostDir (currentDir:string) =
        let matchingMount =
            !baseMounts
            |> Seq.filter (fun m -> currentDir.StartsWith m.ContainerDir)
            |> Seq.sortByDescending (fun m -> m.ContainerDir.Length)
            |> Seq.tryHead
        match matchingMount with
        | Some matchingMount ->
            match matchingMount.HostSource with
            | HostSource.Dir dir ->
                HostSource.Dir <| currentDir.Replace(matchingMount.ContainerDir, dir)
            | HostSource.NamedVolume n ->
                if currentDir = matchingMount.ContainerDir then
                    HostSource.NamedVolume n
                else
                    failwithf "subdirectories of named volumes are not supported. Volume: '%s'" n
        | None ->
            failwithf "cannot use '%s' within docker container, as it is not mapped. Try to map it via '-v /some/dir:%s'" currentDir currentDir

    let mapGivenPath (path:string) =
        if Env.isContainerized then
            if System.IO.Path.IsPathRooted(path) then
                // look into /host
                raise <| System.NotImplementedException "Using full paths and paths going outside the working directory is not supported jet."
                "/host" + path
            else
                // append to /workDir (we can leave it relative)
                path.Replace("\\", "/")
        else
            path

    type DockerServiceReplicas = { Current : int; Requested : int}
    type DockerService =
        { Id : string; Name : string; Mode : string; Replicas : DockerServiceReplicas; Image : string; Ports : string option }
    let parseServices (out:string) =
        let splitLine (line:string) =
            let (s:string array) = line.Split ([|' '; '\t'|], System.StringSplitOptions.RemoveEmptyEntries)
            assert (s.Length = 5 || s.Length = 6)
            if s.Length <> 5 && s.Length <> 6 then
                if s.Length > 6
                    then eprintfn "Could not parse output line from 'docker service ls': %s" line
                    else failwithf "Could not parse output line from 'docker service ls': %s" line
            let (rep:string array) = s.[3].Split([|'/'|])
            if rep.Length <> 2 then
                if rep.Length > 2
                    then eprintfn "Could not parse output (rep) line from 'docker service ls': %s" line
                    else failwithf "Could not parse output (rep) line from 'docker service ls': %s" line
            let currentRep =
                match System.Int32.TryParse(rep.[0]) with
                | true, i -> i
                | _ -> failwithf "Could not parse output line (currentRep) from 'docker service ls': %s" line
            let maxRep =
                match System.Int32.TryParse(rep.[1]) with
                | true, i -> i
                | _ -> failwithf "Could not parse output line (maxRep) from 'docker service ls': %s" line
            { Id = s.[0]; Name = s.[1]; Mode = s.[2]; Replicas = { Current = currentRep; Requested = maxRep }; Image = s.[4]; Ports = if s.Length > 5 then Some s.[5] else None }

        out.Split([| '\r'; '\n' |], System.StringSplitOptions.RemoveEmptyEntries)
        |> Seq.skip 1
        |> Seq.map splitLine
        |> Seq.toList


    type DockerPsQuietRow = { ContainerId : string }
    let internal parseDockerPsQuiet (stdOut:string) =
        stdOut.Split ([|'\r';'\n'|], System.StringSplitOptions.RemoveEmptyEntries)
        |> Seq.map (fun line -> { ContainerId = line.Trim() } )
        |> Seq.toList

    let ps () =
        createProcess ([|"ps"; "-q"|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> parseDockerPsQuiet o.Output)

    let inspect containerId =
        createProcess ([|"inspect"; containerId|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> ContainerInspect.parseInspect o.Output)

    let kill containerId =
        createProcess ([|"kill"; containerId|] |> Arguments.OfArgs)
        |> CreateProcess.ensureExitCode

    let remove force containerId =
        createProcess ([|yield "rm"; if force then yield "-f"; yield containerId|] |> Arguments.OfArgs)
        //|> CreateProcess.ensureExitCode

    let listServices () =
        createProcess ([|"service"; "ls"|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> parseServices o.Output)

    module ServiceInspect =
        type internal ServiceInspectJson = FSharp.Data.JsonProvider< "service-inspect-example.json" >
        type VirtualIp = { NetworkId : string; Addr : string; NetmaskBits : int }
        type Endpoint = { VirtualIps : VirtualIp list }
        type Inspect =
            { Id : string
              Endpoint : Endpoint }
        let getServiceInspectJson json =
            let json = ServiceInspectJson.Load(new System.IO.StringReader(json))
            let inspectRaw = json.[0]
            { Id = inspectRaw.Id
              Endpoint =
                { VirtualIps =
                    inspectRaw.Endpoint.VirtualIPs
                    |> Seq.map (fun ip ->
                        let addrSplit = ip.Addr.Split([|'/'|])
                        { NetworkId = ip.NetworkId; Addr = addrSplit.[0]; NetmaskBits = System.Int32.Parse(addrSplit.[1]) })
                    |> Seq.toList
                }
            }

    let inspectService serviceName =
        createProcess ([|"service"; "inspect"; serviceName|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> ServiceInspect.getServiceInspectJson o.Output)

    module NetworkInspect =
        type internal NetworkInspectJson = FSharp.Data.JsonProvider< "network-inspect-example.json" >
        type Inspect =
            { Name : string
              Id : string
              Scope : string
              Driver : string }
        let getNetworkInspectJson json =
            let json = NetworkInspectJson.Load(new System.IO.StringReader(json))
            let inspectRaw = json.[0]
            { Id = inspectRaw.Id
              Name = inspectRaw.Name
              Scope = inspectRaw.Scope
              Driver = inspectRaw.Driver
            }

    let inspectNetwork networkName =
        createProcess ([|"network"; "inspect"; networkName|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> NetworkInspect.getNetworkInspectJson o.Output)

    module VolumeInspect =
        type internal VolumeInspectJson = FSharp.Data.JsonProvider< "volume-inspect-example.json" >
        type Inspect =
            { Mountpoint : string
              Name : string
              Scope : string
              Driver : string }
        let getVolumeInspectJson json =
            let json = VolumeInspectJson.Load(new System.IO.StringReader(json))
            let inspectRaw = json.[0]
            { Mountpoint = inspectRaw.Mountpoint
              Name = inspectRaw.Name
              Scope = inspectRaw.Scope
              Driver = inspectRaw.Driver
            }

    let inspectVolume volumeName =
        createProcess ([|"volume"; "inspect"; volumeName|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> VolumeInspect.getVolumeInspectJson o.Output)

    type DockerVolume =
        { Driver : string; Name : string }
    let parseVolumes (out:string) =
        let splitLine (line:string) =
            let (s:string array) = line.Split ([|' '; '\t'|], System.StringSplitOptions.RemoveEmptyEntries)
            assert (s.Length = 2)
            if s.Length <> 2 then
                if s.Length > 2
                then eprintfn "Could not parse output line from 'docker volume ls': %s" line
                else failwithf "Could not parse output line from 'docker volume ls': %s" line
            { Driver = s.[0]; Name = s.[1] }

        out.Split([| '\r'; '\n' |], System.StringSplitOptions.RemoveEmptyEntries)
        |> Seq.skip 1
        |> Seq.map splitLine
        |> Seq.toList

    let listVolumes () =
        createProcess ([|"volume"; "ls"|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> parseVolumes o.Output)

    type DockerPlugin =
        { Id : string; Image : string; Tag : string; Description : string; Enabled : bool }
    let parsePlugins (out:string) =
        let splitLine (line:string) =
            let (s:string array) = line.Split ([|'|'|], System.StringSplitOptions.RemoveEmptyEntries)
            assert (s.Length = 5)
            if s.Length <> 5 then
                if s.Length > 5
                then eprintfn "Could not parse output line from 'docker volume ls': %s" line
                else failwithf "Could not parse output line from 'docker volume ls': %s" line
            let sn = s.[2].Split([|':'|], System.StringSplitOptions.RemoveEmptyEntries)
            assert (sn.Length = 2)
            let image, tag =
                if sn.Length > 1 then sn.[0], sn.[1]
                else s.[2], "latest"
               
            
            { Id = s.[1]; Image = image; Tag = tag; Description = s.[4]; Enabled = bool.Parse(s.[0]) }

        out.Split([| '\r'; '\n' |], System.StringSplitOptions.RemoveEmptyEntries)
        |> Seq.map splitLine
        |> Seq.toList

    let listPlugins () =
        createProcess ([|"plugin"; "ls"; "--format"; "{{.Enabled}}|{{.ID}}|{{.Name}}|{{.PluginReference}}|{{.Description}}"|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> CreateProcess.map (fun o -> parsePlugins o.Output)

    let removeVolume volume =
        createProcess ([|"volume"; "rm"; volume|] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode

    let createVolume volume driver options =
        let args1 = ["volume"; "create"; sprintf "--name=%s" volume; sprintf "--driver=%s" driver ]
        let args2 = options |> Seq.map (fun (name, value) -> sprintf "--opt=%s=%s" name value) |> Seq.toList
        createProcess (args1 @ args2 |> List.toArray |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode

    let removeService service =
        createProcess ([|"service"; "rm"; service|] |> Arguments.OfArgs)
        //|> CreateProcess.ensureExitCode

    let exec containerId (proc:CreateProcess<_>) =
        let cmdLine =
            match proc.Command with
            | ShellCommand s -> s
            | RawCommand (f, arg) -> sprintf "%s %s" f arg.ToWindowsCommandLine
            |> Arguments.OfWindowsCommandLine
        createProcess ([| yield! ["exec"; "-i"; containerId ]; yield! cmdLine.Args |] |> Arguments.OfArgs)
        |> CreateProcess.withResultFunc proc.GetResult
        |> CreateProcess.addSetup proc.Setup
        |> fun c -> match proc.Environment with | Some env -> c |> CreateProcess.withEnvironment env | None -> c
        |> fun c -> match proc.WorkingDirectory with | Some wd -> c |> CreateProcess.withWorkingDirectory wd | None -> c

module DockerMachineWrapper =
    let dockerMachinePath = ref "docker-machine"
    let dockerMachineStoragePath = "/docker-machine/storage"
    let ensureWorking() =
        CreateProcess.fromRawCommand !dockerMachinePath [|"version"|]
        |> CreateProcess.redirectOutput
        |> CreateProcess.ensureExitCode
        |> Proc.startAndAwait
        |> Async.Ignore

    let createProcess confDir args =
        let t = dockerMachineStoragePath

        let env =
            System.Environment.GetEnvironmentVariables()
            |> Seq.cast<System.Collections.DictionaryEntry>
            |> Seq.map (fun kv -> string kv.Key, string kv.Value)
            |> fun s -> Seq.append s ["MACHINE_STORAGE_PATH", t]
            |> Seq.toList

        CreateProcess.fromCommand (RawCommand (!dockerMachinePath, args))
        |> CreateProcess.withWorkingDirectory (System.IO.Directory.GetCurrentDirectory())
        |> CreateProcess.withEnvironment env
        |> CreateProcess.addSetup (fun _ ->
            if System.IO.Directory.Exists t then
                System.IO.Directory.Delete(t, true)
            System.IO.Directory.CreateDirectory(t) |> ignore
            IO.cp { IO.CopyOptions.Default with IntegrateExisting = true; IsRecursive = true }
                confDir t

            IO.chmod IO.CmodOptions.Rec (LanguagePrimitives.EnumOfValue 0o0600u) t

            { new IProcessHook with
                member x.Dispose () =
                    System.IO.Directory.Delete (t, true)
                member x.ProcessExited e =
                    System.IO.Directory.Delete(confDir, true)
                    IO.cp { IO.CopyOptions.Default with IntegrateExisting = true; IsRecursive = true }
                        t confDir
                member x.ParseSuccess _ = ()
            })

    let createProcessWithOutput confDir args =
        createProcess confDir args
        |> CreateProcess.redirectOutput
