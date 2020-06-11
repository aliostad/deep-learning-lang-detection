module Env =
    open Microsoft.Build.Utilities
    let runningOnMono =
        try match System.Type.GetType("Mono.Runtime") with null -> false |  _ -> true
        with e ->  false 

    let private msbuildLocation() =
        let currentVersion = ToolLocationHelper.CurrentToolsVersion
        let location = ToolLocationHelper.GetPathToBuildToolsFile("msbuild.exe", currentVersion)
        location

    let buildLocation =
        if runningOnMono then "xbuild"
        else msbuildLocation()

module Project =
    open System
    let getReferences proj =
        let buildTool = Env.buildLocation
        let args = sprintf """%s /t:ResolveReferences /property:BuildingInsideVisualStudio="true" /verbosity:diag""" proj
        use msbuildProcess = new System.Diagnostics.Process()
        msbuildProcess.StartInfo.UseShellExecute <- false
        msbuildProcess.StartInfo.RedirectStandardOutput <- true
        msbuildProcess.StartInfo.FileName <- buildTool
        msbuildProcess.StartInfo.Arguments <- args
        let result = msbuildProcess.Start()
        let output = msbuildProcess.StandardOutput.ReadToEnd()
        msbuildProcess.WaitForExit()
        let lines = output.Split( [|'\r';'\n'|], StringSplitOptions.RemoveEmptyEntries)
        let resolvedTo = "resolved to "
        let filtered =
            lines
            |> Array.choose (fun l -> if l.Contains resolvedTo then
                                          let start = l.IndexOf resolvedTo + resolvedTo.Length
                                          let finish = l.LastIndexOf ". CopyLocal" - 1
                                          Some (l.[start..finish])
                                      else None )
        filtered

[<EntryPoint>]
let main argv =
    let refs = Project.getReferences argv.[0]
    for ref in refs do
        printfn "%s" ref
    0 // return an integer exit code
