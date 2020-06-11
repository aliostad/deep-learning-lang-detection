namespace Pit.Build

open Microsoft.Build.Utilities
open Microsoft.Build.Framework
open System.Diagnostics.CodeAnalysis
open System
open System.Diagnostics
open System.Text.RegularExpressions
open System.IO
open System.Xml
open System.Xml.Linq
open System.Linq


type LibCompilerTask() =
    inherit Task()

    let create() =
        new ProcessStartInfo(UseShellExecute = false, RedirectStandardOutput = true, RedirectStandardError = true, CreateNoWindow = true, WorkingDirectory = Directory.GetCurrentDirectory(), FileName = Helper.pfcPath)

    let mutable outputPath = String.Empty
    let mutable solution = String.Empty
    let mutable slGuid = String.Empty
    let mutable format = "true"
    let mutable copyExternalResource = "false"

    member x.OutputPath
        with get() = outputPath
        and set(v) =
            outputPath <- v

    member x.SlnPath
        with get() = solution
        and set(v) =
            solution <- v

    member x.ProjGuid
        with get() = slGuid
        and set(v) =
            slGuid <- v

    member x.Format
        with get() = format
        and set(v) =
            format <- v

    member x.CopyExternalResource
        with get() = copyExternalResource
        and  set(v) =
            copyExternalResource <- v

    override this.Execute() =
        try
            let jsPath = this.OutputPath.Replace(".dll", ".js")
            let processInfo = create()
            processInfo.Arguments <- "\"" + this.OutputPath + "\"" + " /o:" + "\"" + (jsPath) + "\"" + " /ft:" + this.Format  + " /cr:" + this.CopyExternalResource
            let pfbuild = Process.Start(processInfo)
            pfbuild.WaitForExit()
            let stdout = pfbuild.StandardOutput.ReadToEnd()
            let err = pfbuild.StandardError.ReadToEnd()
            if err.Length = 0 then
                this.Log.LogMessage(MessageImportance.High, stdout)
                let solutionFolder = Path.GetDirectoryName(this.SlnPath)
                let matches =  File.ReadAllText(this.SlnPath) |> Helper.getRegexMatches
                for i in 0..matches.Count-1 do
                    let projectPathRelativeToSolution = matches.[i].Groups.["ProjectFile"].Value;
                    let projectPathOnDisk = Path.GetFullPath(Path.Combine(solutionFolder, projectPathRelativeToSolution))
                    let projectFile = projectPathRelativeToSolution
                    let projectGUID = matches.[i].Groups.["ProjectGUID"].Value |> Helper.getGuid
                    let projectDirectory = Path.GetDirectoryName(projectPathOnDisk)
                    let pGuid = Helper.getGuid(this.ProjGuid)
                    if projectGUID <> pGuid then
                        let xDoc = XDocument.Load(projectPathOnDisk)
                        let k = xDoc |> Helper.getProjGuids
                        if k.Contains(pGuid) then
                            let scriptsPath = Path.Combine(projectDirectory, "Scripts")
                            if not(Directory.Exists(scriptsPath)) then Directory.CreateDirectory(scriptsPath) |> ignore
                            File.Copy(jsPath , Path.Combine(scriptsPath, Path.GetFileName(jsPath)), true)
            else
                this.Log.LogError err
            pfbuild.Close()
        with e -> this.Log.LogErrorFromException(e)
        true

