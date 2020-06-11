open System.Diagnostics

type ShellExecArgs =
  { FileName : string
    Arguments : string option
    WorkingDirectory : string }
    with
    static member Defaults =
      { FileName = Unchecked.defaultof<string>
        Arguments = None
        WorkingDirectory = __SOURCE_DIRECTORY__ }

type Shell() =

    static member Exec(args:ShellExecArgs) =
        let info = ProcessStartInfo(fileName = args.FileName)
        match args.Arguments with Some a -> info.Arguments <- a | None -> ()
        info.WorkingDirectory <- info.WorkingDirectory
        info. WindowStyle <- ProcessWindowStyle.Hidden
        Process.Start(info)

    static member Exec(fileName:string, ?arguments, ?workingDirectory) =
        let args =
            { ShellExecArgs.Defaults with
                FileName = fileName
                Arguments = arguments
                WorkingDirectory = defaultArg workingDirectory __SOURCE_DIRECTORY__ }
        Shell.Exec(args)
