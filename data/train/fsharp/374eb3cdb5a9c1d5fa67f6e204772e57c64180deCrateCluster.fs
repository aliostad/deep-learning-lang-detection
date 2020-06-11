namespace Crate.Testing

open System.Threading
open System
open System.IO
open System.Net
open ICSharpCode.SharpZipLib.GZip
open ICSharpCode.SharpZipLib.Tar
open Crate.Client


module Cluster =

    let versionToUri version =
        sprintf "https://cdn.crate.io/downloads/releases/crate-%s.tar.gz" version

    let download uri =
        use client = new WebClient()
        client.DownloadData(uri:string)

    let extract targetUri bytes =
        use ms = new MemoryStream(buffer=bytes)
        use gzipStream = new GZipInputStream(ms)
        use archive = TarArchive.CreateInputTarArchive(gzipStream)
        archive.ExtractContents targetUri

    let createProcess fileName =
        let p = new System.Diagnostics.Process()
        p.StartInfo.FileName <- fileName
        p.StartInfo.CreateNoWindow <- true
        p

    let isPosixSystem =
        match Environment.OSVersion.Platform with
        | PlatformID.Unix -> true
        | PlatformID.MacOSX -> true
        | _ -> false

    let crateBinary =
        match isPosixSystem with
        | true -> "crate"
        | false -> "crate.bat"

    let tmpFolder =
        Path.Combine(Path.GetTempPath(), "crate-testing")

    let execSql hostUri sql =
        let path = Uri(hostUri, "_sql").AbsoluteUri
        let resp = SqlClient.Execute(path, new SqlRequest(sql, Array.empty))
        resp.Wait()

    let downloadAndCreateProcess version =
        let subFolder = "crate-" + version
        let binaryPath = Path.Combine(tmpFolder, subFolder, "bin", crateBinary)
        printfn "full path to crate executable: %s" binaryPath

        if File.Exists(binaryPath) then
            ()
        else
            versionToUri version
            |> download
            |> extract tmpFolder

            // extract doesn't set the executable permissions correctly.
            // There would be Mono.Unix.Native stuff to set the permissions
            // but well, this hack works also
            if isPosixSystem then
                let argument = sprintf "u+x \"%s\"" binaryPath
                let p = System.Diagnostics.Process.Start("chmod", argument)
                p.WaitForExit()
        createProcess binaryPath


type CrateCluster(name, version) =
    let name = name
    let version = version
    let cancellationSource = new CancellationTokenSource()
    let proc = Cluster.downloadAndCreateProcess version

    let launchProcess = async {
        proc.Start() |> ignore
    }

    let waitForCluster () =
        let uri = Uri("http://localhost:4200")
        let mutable continueLoop = true
        while continueLoop do
            try
                let resp = Cluster.execSql uri "select id from sys.cluster"
                printfn "Cluster is online"
                continueLoop <- false
            with ex ->
                printfn "Waiting for cluster to come online"
                Thread.Sleep(200)
                if proc.HasExited then
                    printfn "%A" ex
                    let errorMessage = proc.StandardError.ReadToEnd()
                    failwith errorMessage
                ()

    member x.Stop() =
        proc.Kill()
        cancellationSource.Cancel()
    member x.Start() =
        Async.Start (launchProcess, cancellationSource.Token)
        waitForCluster()

    interface IDisposable with
       member x.Dispose() = x.Stop()
