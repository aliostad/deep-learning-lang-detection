namespace ClusterManagement

module Which =
    let resolveCygwinPath (fileName:string) =
      async {
        if not Env.isLinux && fileName.StartsWith "/" then
            let cygPath = @"C:\Program Files\Git\usr\bin\cygpath.exe"
            if not (System.IO.File.Exists cygPath) then
                failwithf "Please install git bash on default location for this program to work! ('%s' not found)" cygPath

            let! result =
                CreateProcess.fromRawCommand cygPath [| "-w"; fileName |]
                |> CreateProcess.redirectOutput
                |> CreateProcess.ensureExitCode
                |> CreateProcess.map (fun r -> r.Output)
                |> Proc.startAndAwait
            if Env.isVerbose then
                printfn "Resolved Path '%s' to %s" fileName result
            return result
        else return fileName
      }

    let resolveCygwinPathInRawCommand (c:CreateProcess<_>) =
      async {
        match c.Command with
        | RawCommand (fileName, args) ->
            let! result = resolveCygwinPath fileName
            return { c with Command = RawCommand (result, args) }
        | _ -> return c
      }
    let getToolPath toolName =
      async {
        let! toolPath =
            CreateProcess.fromRawCommand "/usr/bin/which" [| toolName |]
            |> CreateProcess.redirectOutput
            |> CreateProcess.map (fun r -> r.Output)
            |> CreateProcess.ensureExitCodeWithMessage (sprintf "Tool '%s' was not found with which! Make sure it is installed." toolName)
            |> resolveCygwinPathInRawCommand
            |> Async.bind (Proc.startAndAwait)

        let toolPath =
            if toolPath.EndsWith("\n") then toolPath.Substring(0, toolPath.Length - 1)
            else toolPath
        if System.String.IsNullOrWhiteSpace toolPath then
            failwith "which returned an empty string"

        let! resolvedToolPath = resolveCygwinPath toolPath
        return resolvedToolPath
      }