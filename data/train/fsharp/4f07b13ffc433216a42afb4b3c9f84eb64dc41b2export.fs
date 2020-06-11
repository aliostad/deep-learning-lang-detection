module Build.Dae.Export

open BuildSystem

open System.Diagnostics
open Microsoft.Win32

// maybe get string value for a backslash-delimited path and key name
let private getRegistryValue (reg: RegistryKey) (path: string) key =
    let pathTokens = path.Split('\\')
    let pathKey = Array.fold (fun (key: RegistryKey) subkey -> if key = null then null else key.OpenSubKey(subkey)) reg pathTokens
    let pathValue = if pathKey = null then null else pathKey.GetValue(key) :?> string
    if System.String.IsNullOrEmpty(pathValue) then None else Some(pathValue)

// get the first variant of registry value with the speficied name
let private getRegistryValueVariant variants path name =
    let keys = [for hive in [RegistryHive.CurrentUser; RegistryHive.LocalMachine] do for view in [RegistryView.Registry64; RegistryView.Registry32] -> RegistryKey.OpenBaseKey(hive, view)]
    let variations = [for key in keys do for var in variants -> key, var]
    List.tryPick (fun (key, var) -> getRegistryValue key (path var) name) variations

// get the product installation path
let private getProductPath name versions path key =
    match getRegistryValueVariant versions path key with
    | Some path -> path
    | None -> failwithf "Can't find any installed %s version (out of %A) in the registry" name versions

// get the highest version of installed Maya, consider both 64 and 32 bit versions
let private getMayaPath versions =
    getProductPath "Maya" versions (sprintf @"SOFTWARE\Autodesk\Maya\%s\Setup\InstallPath") "MAYA_INSTALL_LOCATION"

// highest installed Maya version
let private mayaPath = lazy (getMayaPath ["2011"; "2010"; "2009"; "2008"])

// start maya batch process
let private launchMayaBatch prompt (command: string) =
    let mayaBatch = mayaPath.Force() + @"\\bin\mayabatch.exe"

    // start mayabatch.exe with the export command
    let startInfo =
        ProcessStartInfo(mayaBatch,
            sprintf "-%s -noAutoloadPlugins -command \"%s\"" (if prompt then "prompt" else "batch") (command.Replace("'", "\\\"")),
            UseShellExecute = false, RedirectStandardInput = prompt, RedirectStandardOutput = true, RedirectStandardError = true)

    // work around Maya multi-threaded evaluation bugs
    startInfo.EnvironmentVariables.Add("MAYA_NO_TBB", "1")

    // launch the process
    Process.Start(startInfo)

// output handler
let private getOutputHandler source =
    DataReceivedEventHandler(fun _ args ->
        let s = args.Data
        if s <> null && s.Length > 0 then Output.echo s)

// build .dae file via standalone mayabatch
let private buildMayaStandalone source target =
    // export script is in the mel file, so source it and run export proc (' are replaced with \" in launchMayaBatch)
    let command = (sprintf "source './src/build/maya_dae_export.mel'; export('%s', '%s');" source target).Replace('\\', '/')

    // launch the process
    let proc = launchMayaBatch false command

    // echo process output
    let handler = getOutputHandler source

    proc.OutputDataReceived.AddHandler(handler)
    proc.BeginOutputReadLine()

    proc.ErrorDataReceived.AddHandler(handler)
    proc.BeginErrorReadLine()

    // wait for process exit, exit code is 0 if export succeeded (see maya_dae_export.mel)
    proc.WaitForExit()
    if proc.ExitCode <> 0 then failwithf "exit code %d" proc.ExitCode

// read stream data until prompt
let private readStreamUpTo (stream: System.IO.Stream) (prompt: string) =
    let sb = System.Text.StringBuilder()

    seq {
        // read stream byte by byte
        while sb.ToString() <> prompt do
            match stream.ReadByte() with
            | c when c >= 32 -> sb.Append(char c) |> ignore
            | 10 ->
                yield sb.ToString()
                sb.Clear() |> ignore
            | -1 -> failwithf "Premature stream termination while waiting for '%s'" prompt
            | _ -> ()
    }

// maya batch building service
let private createMayaBatcher () =
    // export script is in the mel file, so source it (' are replaced with \" in launchMayaBatch)
    let proc = launchMayaBatch true "source './src/build/maya_dae_export.mel'"
    let processOutput f = readStreamUpTo proc.StandardOutput.BaseStream "mel: " |> Seq.iter f

    // wait for initial output & start watchdog thread
    processOutput ignore
    proc.StandardInput.WriteLine(sprintf "startBatchWatchdog(%d);" (System.Diagnostics.Process.GetCurrentProcess().Id))
    processOutput ignore

    // process commands
    MailboxProcessor.Start (fun inbox -> async {
        while true do
            let! (chan: AsyncReplyChannel<_>, source, target) = inbox.Receive()

            // install error output handler
            let handler = getOutputHandler source

            proc.ErrorDataReceived.AddHandler(handler)
            proc.BeginErrorReadLine()

            // issue export command
            proc.StandardInput.WriteLine((sprintf "exportBatch(\"%s\", \"%s\");" source target).Replace('\\', '/'))

            // wait for response (export is successful if the last line is "Result: 0")
            let result = ref false
            processOutput (fun s ->
                result := s = "Result: 0"
                if s.Length > 0 && not !result then Output.echo s)

            // remove error output handler
            proc.CancelErrorRead()
            proc.ErrorDataReceived.RemoveHandler(handler)

            // finish processing
            chan.Reply(!result)
        })

// maya batcher instance
let private mayaBatcher = lazy (createMayaBatcher ())

// build .dae file via mayabatcher
let private buildMayaBatcher source target =
    match mayaBatcher.Force().PostAndReply(fun chan -> chan, source, target) with
    | true -> ()
    | false -> failwith "unknown error"

// get the highest version of installed Max, consider both 64 and 32 bit versions
let private getMaxPath versions =
    getProductPath "3dsmax" versions (sprintf @"SOFTWARE\Autodesk\3dsmax\%s\MAX-1:409") "Installdir"

// highest installed Max version
let private maxPath = lazy (getMaxPath ["13.0"; "12.0"; "11.0"; "10.0"; "9.0"])

// build .dae file via standalone 3dsmax
let private buildMax source target =
    let max = maxPath.Force() + @"\\3dsmax.exe"

    // export script is in the ms file, so include it and run export proc (' are replaced with \" below)
    let command = (sprintf "fileIn './src/build/max_dae_export.ms'; export '%s' '%s'" source target).Replace('\\', '/')

    // start 3dsmax.exe with the export command
    let proc = Process.Start(max, sprintf "-q -silent -vn -mip -mxs \"%s\"" (command.Replace("'", "\\\"")))

    // wait for process exit, exit code is always 0 :(
    proc.WaitForExit()

// build .dae file from DCC sources
let private build ext source target =
    match ext with
    | ".ma" | ".mb" -> buildMayaBatcher source target
    | ".max" -> buildMax source target
    | _ -> failwithf "source file %s has unknown extension" source

// .dae builder object
let builder = ActionBuilder("DaeExport", fun task ->
    let source = task.Sources.[0]
    let target = task.Targets.[0]

    build source.Info.Extension source.Info.FullName target.Info.FullName)
