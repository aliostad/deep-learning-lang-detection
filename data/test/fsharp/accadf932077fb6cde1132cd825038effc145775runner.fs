namespace Runner

[<AutoOpen>]
module Helpers =
    let (@@) fn x = fn x

module LoggerConfig =
    open NLog
    open NLog.Config
    open NLog.Targets

    let setLogLevel level =
        let config = new LoggingConfiguration()
        let consoleTarget = new ColoredConsoleTarget()
        config.AddTarget("console", consoleTarget)
        let rule = new LoggingRule("*", level, consoleTarget)
        config.LoggingRules.Add rule
        LogManager.Configuration <- config

module CLI =
    type Status =
    | Success of string
    | Failure of (string * int)

    let runCmd (cmd:string) =
        let proc = new System.Diagnostics.Process()

        // Escape quotes in the user command
        let saniCmd = cmd.Replace("\"", "\\\"")

        // Set up and run the command
        proc.StartInfo.FileName <- "/bin/bash"
        proc.StartInfo.Arguments <- "-c \"" + saniCmd + "\""
        proc.StartInfo.UseShellExecute <- false 
        proc.StartInfo.RedirectStandardOutput <- true
        proc.StartInfo.RedirectStandardError <- true
        proc.Start() |> ignore

        // Capture stdout
        let sbOut = new System.Text.StringBuilder()
        while not proc.HasExited do
            sbOut.Append(proc.StandardOutput.ReadToEnd()) |> ignore
        sbOut.Append(proc.StandardOutput.ReadToEnd()) |> ignore  // Do it again in case the process exits so quickly we never enter the loop
        let output = sbOut.ToString().Trim()

        // Capture stderr
        let sbErr = new System.Text.StringBuilder()
        while not proc.HasExited do
            sbErr.Append(proc.StandardError.ReadToEnd()) |> ignore
        sbErr.Append(proc.StandardError.ReadToEnd()) |> ignore  // Do it again in case the process exits so quickly we never enter the loop

        let output' = output + sbErr.ToString().Trim()

        match proc.ExitCode with
        | 0 -> Success output
        | _ -> Failure (output', proc.ExitCode)

module DriveManager =
    open NLog
    let logger = LogManager.GetLogger("DriveManager")

    type IDevice =
        abstract member device: string

    type Partition =
        {device:string; size:string; filesystem:string}
        interface IDevice with
            member this.device = this.device

    type Drive =
        {device:string; size:string; name:string; partitions:Partition list}
        interface IDevice with
            member this.device = this.device

    let parseDrive (lines:string list) =
        let lines' =
            match lines with  // We don't need the first line of the parted output
            | x::xs when x = "BYT;" -> xs
            | _ -> lines

        let driveLine = List.head lines'
        let partitionLines = List.tail lines'

        logger.Debug(sprintf "Parsing drive: %s" driveLine)

        let drive =
            let splits = driveLine.Split(':')
            {
                Drive.device = splits.[0];
                size = splits.[1];
                name = splits.[6];
                partitions = []
            }

        let partitions =
            partitionLines
            |> List.map (fun partitionLine ->
                logger.Debug(sprintf "Parsing partition: %s" partitionLine)
                let splits = partitionLine.Split(':')
                {
                    Partition.device = drive.device + splits.[0];
                    size = splits.[3];
                    filesystem = splits.[4]
                }
            )

        {drive with partitions=partitions}

    let parseDrives (driveList:string) =
        driveList.Split([|System.Environment.NewLine|], System.StringSplitOptions.None)
        |> List.ofArray
        |> List.fold (fun drives line ->
            let (current, done_) =
                match drives with
                | [] -> ([], [])
                | x::xs -> (x,xs)

            match line with
            | "" -> []::current::done_  // End of current drive. Prepend a new one to the list.
            | _ -> (List.append current [line])::done_
        ) []
        |> List.map parseDrive

    let getDrives () =
        CLI.runCmd "sudo parted -lm"
        |> (fun res ->
            match res with
            | CLI.Failure(err,_) ->
                logger.Fatal(sprintf "Could not list drives!\n\n%s" err)
                []
            | CLI.Success output ->
                parseDrives output
        )

module VirtualBox =
    open System.IO
    open DriveManager
    open NLog
    let logger = LogManager.GetLogger("VirtualBox")

    let createVM name =
        let couldCreate = CLI.runCmd @@ sprintf "sudo VBoxManage createvm --name '%s' --register" name
        match couldCreate with
        | CLI.Success _ -> ()
        | CLI.Failure (msg,_) -> logger.Fatal(sprintf "Could not create VM: %s" msg)

        logger.Info(sprintf "Created VM %s" name)

    let deleteVM name =
        let couldDelete = CLI.runCmd @@ sprintf "sudo VBoxManage unregistervm '%s' --delete" name
        match couldDelete with
        | CLI.Success _ -> ()
        | CLI.Failure (msg,_) -> logger.Error(sprintf "Could not delete VM: %s" msg)

        logger.Info(sprintf "Deleted VM %s" name)

    let private acquireSpinriteISO (partition:Partition) =
        let mountpoint = "/tmp/spinmount"
        let spinRiteFileName = "spinrite.iso"
        let spinRiteFile= Path.Combine("/tmp", spinRiteFileName)

        match File.Exists(spinRiteFile) with
        | true -> File.Delete spinRiteFile |> ignore
        | false -> ()

        Directory.CreateDirectory(mountpoint) |> ignore
        CLI.runCmd @@ sprintf "sudo mount %s %s" partition.device mountpoint

        File.Copy(Path.Combine(mountpoint, spinRiteFileName), spinRiteFile)

        CLI.runCmd @@ sprintf "sudo umount %s" mountpoint
        Directory.Delete(mountpoint) |> ignore

        spinRiteFile

    let mountSpinRite name (partition:Partition) =
        let spinRiteFile = acquireSpinriteISO partition

        CLI.runCmd @@ sprintf "sudo VBoxManage storagectl '%s' --name 'SATA Controller' --add sata" name
        CLI.runCmd @@ sprintf "sudo VBoxManage storageattach '%s' --storagectl 'SATA Controller' --port 0 --device 0 --type dvddrive --medium %s" name spinRiteFile

    let attachDrives name (drives:Drive list) =
        let baseIndex = 1  // index 0 is the SpinRite boot disk
        drives
            |> List.mapi (fun i drive ->
                let portIndex = i + baseIndex
                let rawDirectory = "/tmp/rawDisks"
                Directory.CreateDirectory(rawDirectory) |> ignore
                let filename = sprintf "%s.vmdk" @@ Path.Combine(rawDirectory, drive.device.Replace("/", "_"))

                let status = CLI.runCmd @@ sprintf "sudo VBoxManage internalcommands createrawvmdk -filename %s -rawdisk %s" filename drive.device
                match status with
                | CLI.Failure (msg,_) -> logger.Fatal(sprintf "Could not attach raw disk %s: %s" drive.device msg)
                | CLI.Success _ ->
                    CLI.runCmd @@ sprintf "sudo chmod go+rw %s" filename
                    let couldAttachDisk = CLI.runCmd @@ sprintf "sudo VBoxManage storageattach '%s' --storagectl 'SATA Controller' --port %d --device 0 --type hdd --medium %s" name portIndex filename
                    match couldAttachDisk with
                    | CLI.Failure (msg,_) -> logger.Error(sprintf "Could not attach raw disk %s: %s" filename msg)
                    | CLI.Success _ -> ()

                filename
            )

    let cleanUpRawDisks rawDisks =
        rawDisks
            |> List.iter (fun rawDisk ->
                File.Delete rawDisk
                logger.Info(sprintf "Cleaned up raw disk file %s" rawDisk)
            )

    let startVM name =
        logger.Info("Starting VM")
        let status = CLI.runCmd @@ sprintf "sudo VBoxManage startvm %s --type gui" name

        match status with
        | CLI.Failure (msg, _) -> logger.Fatal(sprintf "Error starting VM: %s" msg)
        | _ -> ()

    let rec waitForClose name =
        let vmDetails = CLI.runCmd @@ sprintf "sudo VBoxManage showvminfo %s --machinereadable" name
        match vmDetails with
        | CLI.Failure _ -> ()
        | CLI.Success vmDetails ->
            let status =
                vmDetails.Split([|System.Environment.NewLine|], System.StringSplitOptions.None)
                |> List.ofArray
                |> List.map (fun detail -> detail.Split([|'='|]))
                |> List.find (fun detail ->
                    detail.[0] = "VMState"
                )
                |> (fun detail -> detail.[1].Trim([|'"'|]))

            match status with
            | "poweroff"
            | "saved" ->
                logger.Debug(sprintf "VM status: %s" status)
                logger.Debug("VM has closed")
                ()
            | status ->
                logger.Debug(sprintf "Waiting for VM to close. VM status is %s." status)
                System.Threading.Thread.Sleep 3000
                waitForClose name

module main =
    open NLog
    open DriveManager

    LoggerConfig.setLogLevel LogLevel.Debug
    let logger = LogManager.GetLogger("main")

    let rec promptDevices devices =
        devices
            |> List.iteri (fun i (name, _) -> printfn "%i\t%s" i name)

        printfn "Which device do you want to use?"
        let selection = System.Console.ReadLine()

        match (System.Int32.TryParse(selection)) with
        | (true, i) when i < List.length devices ->
            devices.[i]
            |> (fun (_, device) -> device)
        | (false, _)
        | _ ->
            printfn "You must select at least one device"
            promptDevices devices

    [<EntryPoint>]
    let main args =
        let vmName = "runner"
        VirtualBox.createVM vmName
        let allDrives = DriveManager.getDrives()
        let selectedPartition =
            allDrives
            |> List.map (fun drive -> drive.partitions)
            |> List.concat
            |> List.map (fun partition ->
                (
                    sprintf "%s\t(%s, %s)" partition.device partition.size partition.filesystem,
                    partition
                )
            )
            |> promptDevices
        selectedPartition
            |> VirtualBox.mountSpinRite vmName

        let rawDisks =
            allDrives
            |> VirtualBox.attachDrives vmName

        VirtualBox.startVM vmName
        VirtualBox.waitForClose vmName
        VirtualBox.deleteVM vmName
        VirtualBox.cleanUpRawDisks rawDisks
        0
