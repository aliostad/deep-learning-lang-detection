namespace ClusterManagement

open System.IO

module Sudo =
    let wrapCommand (createProcess:CreateProcess<_>) =
        let cmdLine =
            match createProcess.Command with
            | ShellCommand s -> s
            | RawCommand (f, arg) -> sprintf "%s %s" f arg.ToWindowsCommandLine
        CreateProcess.fromCommand (RawCommand ("sudo", cmdLine |> Arguments.OfWindowsCommandLine))
        |> CreateProcess.withResultFunc createProcess.GetResult
        |> CreateProcess.addSetup createProcess.Setup
        |> fun c -> match createProcess.Environment with | Some env -> c |> CreateProcess.withEnvironment env | None -> c
        |> fun c -> match createProcess.WorkingDirectory with | Some wd -> c |> CreateProcess.withWorkingDirectory wd | None -> c

module Bash =
        
    let runCommand command =
        let usingArgs =
            ([| yield "-c"; yield command |] |> Arguments.OfArgs)
        CreateProcess.fromCommand (RawCommand ("/bin/bash", usingArgs))

    let wrapToEvaluateArguments (createProcess:CreateProcess<_>) =
        let cmdLine =
            match createProcess.Command with
            | ShellCommand s -> s
            | RawCommand (f, arg) -> sprintf "%s %s" f arg.ToWindowsCommandLine
        runCommand cmdLine
        |> CreateProcess.withResultFunc createProcess.GetResult
        |> CreateProcess.addSetup createProcess.Setup
        |> fun c -> match createProcess.Environment with | Some env -> c |> CreateProcess.withEnvironment env | None -> c
        |> fun c -> match createProcess.WorkingDirectory with | Some wd -> c |> CreateProcess.withWorkingDirectory wd | None -> c
