namespace UniFSharp
open System
open System.IO 
open System.Diagnostics 
open System.Text 
open System.Xml
open UnityEditor

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module MSBuild =
  let private initOutputDir outputDirPath = 
    if (not <| Directory.Exists(outputDirPath)) then
      Directory.CreateDirectory(outputDirPath) |> ignore
    else
      Directory.GetFiles(outputDirPath) |> Seq.iter (fun file -> File.Delete(file))
      AssetDatabase.Refresh(ImportAssetOptions.ForceUpdate)

  let private getAssemblyName (projectFilePath:string) = 
    let xdoc = new XmlDocument()
    xdoc.Load(projectFilePath)
    let xnm = new XmlNamespaceManager(xdoc.NameTable)
    xnm.AddNamespace("ns", "http://schemas.microsoft.com/developer/msbuild/2003")
    let node = xdoc.SelectSingleNode("/ns:Project/ns:PropertyGroup/ns:AssemblyName", xnm)
    let node = xdoc.SelectSingleNode("/ns:Project/ns:PropertyGroup/ns:AssemblyName")
    if (node = null) then ""
    else node.InnerText

  let private getAargs (projectFilePath:string) (outputDirPath:string) isDebug =
    let projectFilePath = projectFilePath |> replaceDirAltSepFromSep
    let outputDirPath = outputDirPath |> replaceDirAltSepFromSep

    // http://msdn.microsoft.com/ja-jp/library/bb629394.aspx
    let args = new StringBuilder()
    args.AppendFormat("\"{0}\"", projectFilePath)
        .AppendFormat(" /p:Configuration={0}", if isDebug then "Debug" else "Release")
        .AppendFormat(" /p:OutputPath=\"{0}\"", outputDirPath)
        .Append(" /p:OptionExplicit=true")
        .Append(" /p:OptionCompare=binary")
        .Append(" /p:OptionStrict=true")
        .Append(" /p:OptionInfer=true")
        .Append(" /p:BuildProjectReferences=false")
        .AppendFormat(" /p:DebugType={0}", if isDebug then "full" else "pdbonly")
        .AppendFormat(" /p:DebugSymbols={0}", if isDebug then "true" else "false")
        .AppendFormat(" /p:VisualStudioVersion={0}", "12.0") // TODO : これによって、使われるfsc.exeのバージョンが変わる.
        //.AppendFormat("{0}", String.Format(" /p:DocumentationFile={0}/{1}.xml", outputDirPath, getAssemblyName projectFilePath))
        .AppendFormat(" /l:FileLogger,Microsoft.Build.Engine;logfile={0}", String.Format("{0}/{1}.log", outputDirPath, if isDebug then "DebugBuild" else "ReleaseBuild"))
        .Append(" /t:Clean;Rebuild")
        |> string

  let getMSBuildPath (version:string) = 
    let msBuildPath = (String.Format(@"SOFTWARE\Microsoft\MSBuild\{0}", version), @"MSBuildOverrideTasksPath") ||> UniFSharp.Registory.getReg
    Path.Combine(msBuildPath, "MSBuild.exe")

  let execute msBuildVersion projectFilePath outputDirPath isDebug outputDataReceivedEventHandler errorDataReceivedEventHandler = 
    use p = new Process()
    outputDirPath |> initOutputDir

    p.StartInfo.WindowStyle <- ProcessWindowStyle.Hidden
    p.StartInfo.CreateNoWindow <- true
    p.StartInfo.UseShellExecute <- true
    p.StartInfo.FileName <- getMSBuildPath msBuildVersion
    p.StartInfo.Arguments <- getAargs projectFilePath outputDirPath isDebug

    if (outputDataReceivedEventHandler = null |> not || errorDataReceivedEventHandler = null |> not) then
        p.StartInfo.UseShellExecute <- false
        p.StartInfo.CreateNoWindow <- true
        p.StartInfo.WindowStyle <- ProcessWindowStyle.Hidden

        if (outputDataReceivedEventHandler = null |> not) then
          p.StartInfo.RedirectStandardOutput <- true
          p.OutputDataReceived.AddHandler outputDataReceivedEventHandler

        if (errorDataReceivedEventHandler = null |> not) then
          p.StartInfo.RedirectStandardError <- true
          p.ErrorDataReceived.AddHandler errorDataReceivedEventHandler

    if p.Start() then
      if (outputDataReceivedEventHandler = null |> not) then
        p.BeginOutputReadLine()

      if (errorDataReceivedEventHandler = null |> not) then
        p.BeginErrorReadLine()

      p.WaitForExit()
      p.ExitCode
    else
      p.ExitCode 

