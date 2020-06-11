
open System.IO
open System.Net
open System
open System.Linq
open System.Diagnostics

module Fget =

    let packagesDir = "packages"

    let log(message: string) =
        Console.ForegroundColor <- ConsoleColor.Green
        Console.WriteLine("{0} {1}", DateTime.Now.ToString(), message)

    let logs(fmt: string, args: string) =
        let message = String.Format(fmt, args)
        log(message)

    let moveContent(dirName: string, targetDir: string) =
        if Directory.Exists(targetDir) then
            Directory.Delete(targetDir, true)
            Directory.CreateDirectory(targetDir) |> ignore

        let dir = DirectoryInfo(packagesDir)
        let packages = dir.GetDirectories()
        let allDir = packages |> Seq.map ( fun x -> x.GetDirectories())
        let packageContents = seq { for dir in allDir do yield! dir}
        let contents = packageContents |> Seq.map (fun x -> x.GetDirectories())
        let flatContent = seq { for dir in contents do yield! dir} |> Seq.filter(fun x-> x.Name = dirName)
        let files = flatContent |> Seq.map(fun x -> x.GetFiles())

        let copy (files: seq<FileInfo>) =
            files |> Seq.iter(fun x ->
                        let target = Path.Combine(targetDir, x.Name)
                        if not(File.Exists(target)) then
                            logs("|| copy -> {0}", x.FullName)
                            File.Copy(x.FullName, target))

        files |> Seq.iter copy

    let install package =
        let command = sprintf "nuget.exe install %s -OutputDirectory %s" package packagesDir
        logs("|| install -> {0}", command)
        use ps = new Process()
        let startInfo = ProcessStartInfo()
        startInfo.FileName <- "mono"
        startInfo.Arguments <- command
        ps.StartInfo <- startInfo
        ps.Start() |> ignore
        ps.WaitForExit()

    let loadNuget() =
        let exist = File.Exists("nuget.exe")
        if not(exist) then
            log("|| download nuget get")
            use client = new WebClient()
            client.DownloadFile("https://dist.nuget.org/win-x86-commandline/latest/nuget.exe", "nuget.exe")

Fget.loadNuget()
Fget.install (fsi.CommandLineArgs.[1])
Fget.moveContent("Scripts", "dist/Scripts/library")
Fget.moveContent("Content", "dist/Content")
