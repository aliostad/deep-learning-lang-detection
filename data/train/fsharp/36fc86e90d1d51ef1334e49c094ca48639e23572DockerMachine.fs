namespace ClusterManagement

open System.IO

type CopyDirection =
    | Upload
    | Download

module DockerMachine =

    let getMachineName clusterName nodeName =
        sprintf "%s-%s" clusterName nodeName

    let createProcessRaw allowUnInitialized cluster args =
        let dockerMachineDir = StoragePath.getDockerMachineDir cluster
        DockerMachineWrapper.createProcess dockerMachineDir args
        |> CreateProcess.addSetup (fun () ->
            let c = ClusterConfig.readClusterConfig cluster
            if not (ClusterConfig.getIsInitialized c) && not allowUnInitialized then
                failwithf "Cannot run process for cluster '%s' when it is not initialized!" cluster

            let tokens = ClusterConfig.getTokens c
            let homeDir = System.Environment.GetFolderPath(System.Environment.SpecialFolder.UserProfile)
            let awsConfigDir = Path.Combine(homeDir, ".aws")
            let awsCredentials = Path.Combine(awsConfigDir, "credentials")
            let awsConfig = Path.Combine(awsConfigDir, "config")
            let restoreAwsConfig = if File.Exists awsConfig then File.Move (awsConfig, awsConfig + ".backup"); true else false
            let restoreAwsCredentials = if File.Exists awsCredentials then File.Move (awsCredentials, awsCredentials + ".backup"); true else false
            let cleanup () =
                if restoreAwsCredentials then File.Delete awsCredentials; File.Move (awsCredentials + ".backup", awsCredentials)
                if restoreAwsConfig then File.Delete awsConfig; File.Move (awsConfig + ".backup", awsConfig)
            try
                if Directory.Exists awsConfigDir |> not then Directory.CreateDirectory awsConfigDir |> ignore
                File.WriteAllText (awsCredentials, IO.getResourceText "aws_config" |> Config.replaceTokens tokens)
                File.WriteAllText (awsCredentials, IO.getResourceText "aws_credentials" |> Config.replaceTokens tokens)
            with _ -> cleanup(); reraise()
            { new IProcessHook with
                member __.ProcessExited _ = ()
                member __.ParseSuccess _ = ()
                member __.Dispose () = cleanup() }
            )

    let createProcess cluster args = createProcessRaw false cluster args
    let ssh cluster nodeName command =
        let machineName = getMachineName cluster nodeName
        let args = command |> Arguments.OfWindowsCommandLine
        if args.Args.Length < 0 then failwith "zero arguments (empty command) is not supported right now..."
        //let cmd = args.Args.[0]
        //let restArgs = { Args = args.Args.[1..args.Args.Length - 1] }
        //let usingArgs = ([|yield "ssh"; yield machineName; yield! args.Args |] |> Arguments.OfArgs)
        // ssh ALWAYS executes commands with $SHELL -c 'command', see http://serverfault.com/a/823466/158394
        // see http://unix.stackexchange.com/questions/184031/can-a-command-be-executed-over-ssh-with-a-nologin-user/184127
        // see http://unix.stackexchange.com/questions/10852/whats-the-difference-between-sbin-nologin-and-bin-false/10867#10867
        // TODO: The correct way -> Detect remote shell (echo $SHELL) and escape accordingly..
        let usingArgs = ([|yield "ssh"; yield machineName; yield args.ToLinuxShellCommandLine |] |> Arguments.OfArgs)
        createProcess cluster usingArgs

    let sshExt cluster nodeName (createProcess:CreateProcess<_>) =
        let cmdLine =
            match createProcess.Command with
            | ShellCommand s -> s
            | RawCommand (f, arg) -> sprintf "%s %s" (Path.GetFileNameWithoutExtension f) arg.ToWindowsCommandLine
        ssh cluster nodeName cmdLine
        |> CreateProcess.withResultFunc createProcess.GetResult
        |> CreateProcess.addSetup createProcess.Setup

    let runSudoDockerOnNode cluster nodeName proc =
        proc
        |> CreateProcess.mapFilePath (fun _ -> "docker")
        |> Sudo.wrapCommand
        |> sshExt cluster nodeName

    let getExternalIp cluster nodeName =
        let runIp arguments =
            CreateProcess.fromRawCommand "ip" arguments
        let machineName = getMachineName cluster nodeName
        runIp [|machineName|]
        |> sshExt cluster nodeName
        |> CreateProcess.redirectOutput
        |> CreateProcess.map (fun r -> r.Output.Trim())


    type internal InspectJson = FSharp.Data.JsonProvider<"machine-inspect-example.json">
    let internal parseInspectJson json =
        let json = InspectJson.Load(new System.IO.StringReader(json))
        json

    let internal inspect cluster nodeName =
        let machineName = getMachineName cluster nodeName
        createProcess cluster ([|"inspect"; machineName |] |> Arguments.OfArgs)
        |> CreateProcess.redirectOutput
        |> CreateProcess.map (fun r -> parseInspectJson (r.Output.Trim()))

    let internal parseIfConfig (ifConfigOut:string) =
        ifConfigOut.Split ([|'\r';'\n'|], System.StringSplitOptions.RemoveEmptyEntries)
        |> Seq.tryFind (fun line -> line.Contains "inet addr")
        |> Option.bind (fun line ->
            try
                line.Split ([| ' '; '\t'; '\r'; '\n' |], System.StringSplitOptions.RemoveEmptyEntries)
                |> Seq.skip 1
                |> Seq.tryHead
            with e ->
                if Env.isVerbose then eprintfn "Error: %O" e
                None)
        |> Option.bind (fun h ->
            try
                h.Split([|':'|])
                |> Seq.skip 1
                |> Seq.tryHead
            with e ->
                if Env.isVerbose then eprintfn "Error: %O" e
                None)


    let getIp networkInterface cluster nodeName =
        let runIfConfig arguments =
            CreateProcess.fromRawCommand "ifconfig" arguments
        let getIpFromInterface networkInterface =
            runIfConfig [|networkInterface|]
            |> CreateProcess.redirectOutput
            |> CreateProcess.map (fun o ->
                match parseIfConfig o.Output with
                | Some ip -> ip
                | None -> failwithf "Could not detect ip of interace via 'ifconfig %s | grep \"inet addr\"'" networkInterface)
        getIpFromInterface networkInterface
        |> sshExt cluster nodeName


    let getDockerIp cluster nodeName =
        getIp "docker0" cluster nodeName
    let getEth0Ip cluster nodeName =
        getIp "eth0" cluster nodeName

    let runDockerPs cluster nodeName =
        DockerWrapper.ps ()
        |> runSudoDockerOnNode cluster nodeName

    let internal runDockerInspect cluster nodeName containerId =
        DockerWrapper.inspect containerId
        |> runSudoDockerOnNode cluster nodeName

    let runDockerKill cluster nodeName containerId =
        DockerWrapper.kill containerId
        |> runSudoDockerOnNode cluster nodeName

    let runDockerRemove cluster nodeName force containerId =
        DockerWrapper.remove force containerId
        |> runSudoDockerOnNode cluster nodeName

    let remove force cluster machineName =
        createProcess cluster
            ([| yield "rm"
                if force then yield "-f"
                yield "-y";
                yield machineName |] |> Arguments.OfArgs)

    let copyContentsExt makeLocal makeRemote fileName direction localDir remoteDir  =
      async {
        let isRealLocal, makeLocal =
            match makeLocal with
            | Some f -> false, f
            | None -> true, id

        match direction with
        | Download ->
            if isRealLocal then
                System.IO.Directory.CreateDirectory(localDir) |> ignore
        | Upload ->
            if isRealLocal then
                if System.IO.Directory.Exists(localDir) |> not then
                    failwithf "To upload a directory it needs to exist (%s)!" localDir
            do! CreateProcess.fromRawCommand "mkdir" [|remoteDir|]
                |> makeRemote
                |> Proc.startAndAwait

        // We use tar to copy, because scp doesn't work because of permissions
        // see http://askubuntu.com/a/531904/400826
        let streamRef = StreamRef.Empty
        let compressProc =
            match direction with
            | Download ->
                CreateProcess.fromRawCommand "tar" [|"-c";"-C";remoteDir; fileName|]
                |> makeRemote
            | Upload ->
                CreateProcess.fromRawCommand "tar" [|"-c";"-C";localDir; fileName|]
                |> makeLocal
            |> CreateProcess.withStandardOutput (StreamSpecification.CreatePipe streamRef)
            |> CreateProcess.ensureExitCode
            |> Proc.start
        let extractProc =
            match direction with
            | Download ->
                CreateProcess.fromRawCommand "tar" [|"-x";"--no-same-owner";"-C";localDir|]
                |> makeLocal
            | Upload ->
                CreateProcess.fromRawCommand "tar" [|"-x";"--no-same-owner";"-C";remoteDir|]
                |> makeRemote
            |> CreateProcess.withStandardInput (StreamSpecification.UseStream(false, streamRef.Value))
            |> CreateProcess.ensureExitCode
            |> Proc.start

        do! compressProc |> Async.AwaitTask
        do! extractProc |> Async.AwaitTask
      }

    let copyContents fileName direction cluster node localDir remoteDir =
        let makeRemote =
            Sudo.wrapCommand >> sshExt cluster node
        let makeLocal = None
        copyContentsExt makeLocal makeRemote fileName direction localDir remoteDir

    let copyDir direction cluster node localDir remoteDir = copyContents "." direction cluster node localDir remoteDir