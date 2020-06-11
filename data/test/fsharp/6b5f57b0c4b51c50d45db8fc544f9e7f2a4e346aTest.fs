namespace ClusterManagement.Tests

open NUnit.Framework
open ClusterManagement
open System.IO
open Swensen.Unquote

type SimulatedProcess =
    { AssertProcess : RawCreateProcess -> unit; Output : ProcessOutput; ExitCode : int }
    static member Error (cmdLine : string, exitCode, output, error) =
        let assertCmdLine (c:RawCreateProcess) =
            Assert.AreEqual (cmdLine, c.CommandLine)
        { AssertProcess = assertCmdLine; Output = { Output = output; Error = error }; ExitCode = exitCode }
    static member Simple (cmdLine : string, output) =
        SimulatedProcess.Error(cmdLine, 0, output, "")

module TestHelper =
    let setProcessAssertion processes =
        let arr = processes |> List.toArray
        let mutable cur = 0
        RawProc.processStarter <-
            { new IProcessStarter with
                member x.Start c =
                    if cur >= arr.Length then failwithf "Tried to start an unconfigured process \n%s \n\n %A" c.CommandLine c
                    let currentAssertion : SimulatedProcess = arr.[cur]
                    cur <- cur + 1

                    currentAssertion.AssertProcess c

                    let output =
                        match c.OutputRedirected with
                        | true -> Some currentAssertion.Output
                        | false -> None

                    async {
                        return currentAssertion.ExitCode, output
                    }
            }

    let changeTmpDir () =
        let dir = Path.GetTempFileName()
        File.Delete dir
        Directory.CreateDirectory dir |> ignore
        let oldDir = System.Environment.CurrentDirectory
        System.Environment.CurrentDirectory <- dir
        { new System.IDisposable with
            member x.Dispose() =
                System.Environment.CurrentDirectory <- oldDir
                Directory.Delete(dir, true) }

    let setupCluster cluster =

        ()

[<TestFixture>]
type Test() = 
    [<Test>]
    member __.``Test Yaml Config load`` () =
        let c = Path.GetTempFileName()
        File.WriteAllText(c, @"secrets:
  - clustername: test
    secret: secret
  - clustername: test2
    secret: secret
"            )

        let cc = GlobalConfig.ClusterManagementConfig()
        //cc.secrets.Clear()
        if Env.isVerbose then
            printfn "loading global config file '%s'" c
        if File.Exists c then
            cc.Load c
        
        File.Delete c
        ()
        
    [<Test>]
    member __.``Parse plugin ls`` () =
        let out = """true|b48750a02133|rexray/ebs:latest|docker.io/rexray/ebs:0.9.0|REX-Ray for Amazon EBS"""
        let result = DockerWrapper.parsePlugins out
        Assert.AreEqual(
            [{ DockerWrapper.DockerPlugin.Id = "b48750a02133"
               DockerWrapper.DockerPlugin.Image = "rexray/ebs"; DockerWrapper.DockerPlugin.Tag = "latest"
               DockerWrapper.DockerPlugin.Enabled = true; DockerWrapper.DockerPlugin.Description = "REX-Ray for Amazon EBS" } ],
            result)

    [<Test>]
    member __.``Test Volume Create when cluster was not initialized`` () =
        use dir = TestHelper.changeTmpDir()
        [ ] |> TestHelper.setProcessAssertion
        ClusterConfig.setInitialConfig "cluster" false
        let res = Assert.Throws<exn>(fun _ ->
            Volume.create "cluster" "volume" 1024L
                |> Async.StartImmediateAsTask
                |> fun t -> t.GetAwaiter().GetResult()
                |> ignore)
        Assert.IsTrue(res.Message.Contains "Cannot run process for cluster 'cluster' when it is not initialized!")

    [<Test>]
    member __.``Test Volume Create when no matching one exists`` () =
        use dir = TestHelper.changeTmpDir()
        let lspluginOut = """true|b48750a02133|rexray/ebs:latest|docker.io/rexray/ebs:0.9.0|REX-Ray for Amazon EBS"""
        let lsout = """
DRIVER              VOLUME NAME
flocker             backup_yaaf-prod-ldap
flocker             yaaf-prod-clustermanagement
rexray/ebs:latest   yaaf-prod_unmounted
rexray/ebs:latest   yaaf-teamspeak_clustermanagement
rexray/ebs:latest   yaaf-teamspeak_teamspeak"""

        [ SimulatedProcess.Simple("""docker-machine "ssh" "cluster-master-01" "'sudo' 'docker' 'plugin' 'ls' '--format' '{{.Enabled}}|{{.ID}}|{{.Name}}|{{.PluginReference}}|{{.Description}}'" """.TrimEnd(), lspluginOut)
          SimulatedProcess.Simple("""docker-machine "ssh" "cluster-master-01" "'sudo' 'docker' 'volume' 'ls'" """.TrimEnd(), lsout)
          // Note: Size needs to be roundet to 1 (which is the minimum acceptable value)
          SimulatedProcess.Simple("""docker-machine "ssh" "cluster-master-01" "'sudo' 'docker' 'volume' 'create' '--name=cluster_volume' '--driver=rexray/ebs' '--opt=size=1'" """.TrimEnd(), "")
        ]
            |> TestHelper.setProcessAssertion
        ClusterConfig.setInitialConfig "cluster" false
        ClusterConfig.setClusterInitialized "cluster" true
        let result =
            Volume.create "cluster" "volume" 1024L
                |> Async.RunSynchronously

        let ci = Some { Volume.ClusterDockerInfo.SimpleName = "volume"; Volume.ClusterDockerInfo.Cluster = "cluster" }
        let expected =
            { Volume.ClusterDockerVolume.Info = { Name = "cluster_volume"; Driver = "rexray/ebs" }
              Volume.ClusterDockerVolume.ClusterInfo = ci }
        Assert.AreEqual(expected, result)
        
    
    [<Test>]
    member __.``Test Machine create uses ROOT_SIZE`` () =
        use dir = TestHelper.changeTmpDir()
    
        [ SimulatedProcess.Simple("""docker-machine "create" "--driver" "amazonec2" "--amazonec2-root-size" "32" "--amazonec2-region" "region" "machine" """.TrimEnd(), "")
        ]
            |> TestHelper.setProcessAssertion
        ClusterConfig.setInitialConfig "cluster" false
        ClusterConfig.setClusterInitialized "cluster" true
        let clusterConf =
            ClusterConfig.readClusterConfig "cluster"
                |> ClusterConfig.setConfig "ROOT_SIZE" "32"
                |> ClusterConfig.setConfig "AWS_REGION" "region"
            //|> ClusterConfig.writeClusterConfig "cluster"
        
        CloudProviders.createMachine "cluster" "machine" clusterConf
            |> Async.RunSynchronously
    
    [<Test>]
    member __.``Install ebs Plugin executes correct docker commands when not already installed`` () =
        use dir = TestHelper.changeTmpDir()
    
        [ SimulatedProcess.Error("""docker "plugin" "inspect" "rexray/ebs" """.TrimEnd(), 1, "[]", "Error: No such object: rexray/ebs")
          SimulatedProcess.Simple("""docker "plugin" "install" "--disable" "--grant-all-permissions" "rexray/ebs" "EBS_ACCESSKEY=awskey" "EBS_SECRETKEY=awssecret" "EBS_REGION=region" """.TrimEnd(), "")
          SimulatedProcess.Simple("""docker "plugin" "upgrade" "--skip-remote-check" "--grant-all-permissions" "rexray/ebs" "rexray/ebs:0.9.0" """.TrimEnd(), "")
          SimulatedProcess.Simple("""docker "plugin" "enable" "rexray/ebs" """.TrimEnd(), "")
        ]
            |> TestHelper.setProcessAssertion
        ClusterConfig.setInitialConfig "cluster" false
        ClusterConfig.setClusterInitialized "cluster" true
        let clusterConf =
            ClusterConfig.readClusterConfig "cluster"
                |> ClusterConfig.setConfig "AWS_ACCESS_KEY_ID" "awskey"
                |> ClusterConfig.setConfig "AWS_ACCESS_KEY_SECRET" "awssecret"
                |> ClusterConfig.setConfig "AWS_REGION" "region"
            //|> ClusterConfig.writeClusterConfig "cluster"
        
        Plugins.installPlugin id Plugin.Ebs clusterConf
            |> Async.RunSynchronously
        
    [<Test>]
    member __.``Install s3fs Plugin executes correct docker commands when not already installed`` () =
        use dir = TestHelper.changeTmpDir()
    
        [ SimulatedProcess.Error("""docker "plugin" "inspect" "rexray/s3fs" """.TrimEnd(), 1, "[]", "Error: No such object: rexray/s3fs")
          SimulatedProcess.Simple("""docker "plugin" "install" "--disable" "--grant-all-permissions" "rexray/s3fs" "S3FS_ACCESSKEY=awskey" "S3FS_SECRETKEY=awssecret" "S3FS_REGION=region" """.TrimEnd(), "")
          SimulatedProcess.Simple("""docker "plugin" "upgrade" "--skip-remote-check" "--grant-all-permissions" "rexray/s3fs" "rexray/s3fs:0.9.0" """.TrimEnd(), "")
          SimulatedProcess.Simple("""docker "plugin" "enable" "rexray/s3fs" """.TrimEnd(), "")
        ]
            |> TestHelper.setProcessAssertion
        ClusterConfig.setInitialConfig "cluster" false
        ClusterConfig.setClusterInitialized "cluster" true
        let clusterConf =
            ClusterConfig.readClusterConfig "cluster"
                |> ClusterConfig.setConfig "AWS_ACCESS_KEY_ID" "awskey"
                |> ClusterConfig.setConfig "AWS_ACCESS_KEY_SECRET" "awssecret"
                |> ClusterConfig.setConfig "AWS_REGION" "region"
            //|> ClusterConfig.writeClusterConfig "cluster"
        
        Plugins.installPlugin id Plugin.S3fs clusterConf
            |> Async.RunSynchronously
            
            
     
    
    [<Test>]
    member __.``Test list cluster plugins`` () =
        use dir = TestHelper.changeTmpDir()
    
        let lspluginOut = """true|b48750a02133|rexray/ebs:latest|docker.io/rexray/ebs:0.9.0|REX-Ray for Amazon EBS"""
        [ SimulatedProcess.Simple("""docker-machine "ssh" "cluster-master-01" "'sudo' 'docker' 'plugin' 'ls' '--format' '{{.Enabled}}|{{.ID}}|{{.Name}}|{{.PluginReference}}|{{.Description}}'" """.TrimEnd(), lspluginOut)
        ]
            |> TestHelper.setProcessAssertion
        ClusterConfig.setInitialConfig "cluster" false
        ClusterConfig.setClusterInitialized "cluster" true
        
        let result = 
            Plugins.listClusterPlugins "cluster"
            |> Async.RunSynchronously
        let expected = [ Plugins.getPlugin Plugin.Ebs ]
        Assert.AreEqual (expected, result)