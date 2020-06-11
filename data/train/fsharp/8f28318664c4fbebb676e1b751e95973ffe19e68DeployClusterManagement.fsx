#if !CLUSTERMANGEMENT
#r "bin/Debug/ClusterManagement.exe"
#endif

open ClusterManagement

let d = Deploy.getInfo()
if Env.isVerbose then
    printfn "Deploying ClusterManagement to cluster '%s'" d.ClusterName

let runDockerRaw node args = DockerMachine.runSudoDockerOnNode d.ClusterName node args |> Proc.startRaw |> fun t -> t.GetAwaiter().GetResult()
let runDockerE node cmd =
    DockerWrapper.createProcess (cmd |> Arguments.OfWindowsCommandLine)
    |> CreateProcess.redirectOutput
    |> runDockerRaw node
let runDocker cmd = runDockerE "master-01" cmd

// Stop existing service
runDocker "service rm clustermanagement"
    |> ignore

// CM docker-machine -c <cluster> -- ssh blub-master-01 ifconfig -> get docker0 ip
let plugin =
    CloudProviders.defaultPlugin d.ClusterConfig
let volInfo =
    Volume.createEx false d.ClusterName "clustermanagement" plugin [("size", sprintf "%d" 1)]
    |> Async.RunSynchronously

// upload config to the volume
let tmpPath = System.IO.Path.GetTempFileName()
System.IO.File.Delete tmpPath
System.IO.Directory.CreateDirectory tmpPath
try
    let tmpConfig = System.IO.Path.Combine(tmpPath, StoragePath.clusterConfig)
    System.IO.File.Copy (StoragePath.getClusterConfigFile d.ClusterName, tmpConfig)
    // Add CLUSTER_NAME
    ClusterConfig.readConfigFromFile tmpConfig
        |> ClusterConfig.setConfig "CLUSTER_NAME" d.ClusterName
        |> ClusterConfig.writeClusterConfigToFile tmpConfig

    let source = StoragePath.getConfigFilesDir d.ClusterName
    let target = System.IO.Path.Combine(tmpPath, StoragePath.configFilesDirName)
    IO.cp { IO.CopyOptions.Default with DoOverwrite = true; IsRecursive = true } source target
    Volume.copyContents "." CopyDirection.Upload d.ClusterName volInfo.Info.Name tmpPath
        |> Async.RunSynchronously
finally
    System.IO.Directory.Delete(tmpPath, true)

runDocker
    (sprintf "service create --replicas 1 --name clustermanagement --mount type=volume,src=%s,dst=/workdir,volume-driver=%s --network swarm-net matthid/clustermanagement internal serveconfig"
        volInfo.Info.Name volInfo.Info.Driver)
    |> ignore

