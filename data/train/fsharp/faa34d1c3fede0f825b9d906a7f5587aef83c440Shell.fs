namespace Notary

module Shell =
    open System
    open System.Diagnostics

    exception NonzeroExitException of int

    type ProcessResult =
        {
            proc  : Process
            stdOut: string
            stdErr: string
        }

    let createStartInfo filename arguments =
        ProcessStartInfo(
            FileName               = filename,
            Arguments              = arguments,
            RedirectStandardOutput = true,
            RedirectStandardError  = true,
            UseShellExecute        = false,
            CreateNoWindow         = true,
            WindowStyle            = ProcessWindowStyle.Hidden)

    let runSync (startInfo: ProcessStartInfo) =
        let proc = Process.Start(startInfo)
        let result =
            {
                proc = proc
                stdOut = proc.StandardOutput.ReadToEnd()
                stdErr = proc.StandardError.ReadToEnd()
            }
        proc.WaitForExit()
        result

    let getCommandText (startInfo: ProcessStartInfo) =
        sprintf "%s %s" startInfo.FileName startInfo.Arguments

    let filterCommand filter startInfo =
        startInfo
        |> getCommandText
        |> filter

    let printCommandFiltered filter startInfo =
        startInfo
        |> filterCommand filter
        |> printfn "%s"

        startInfo

    let printCommand = printCommandFiltered id

    let printIfZeroExit message (proc: Process) =
        if proc.ExitCode = 0 then printfn "%s" message else ()
        proc

    let printAndRaiseIfNonzeroExit message (proc: Process) =
        match proc.ExitCode with
        | 0 -> proc
        | exitCode ->
            printfn "ERROR (%s exit code: %d): %s" proc.StartInfo.FileName proc.ExitCode message
            raise (NonzeroExitException exitCode)

    let run filename arguments =
        arguments
        |> createStartInfo filename
        |> runSync
