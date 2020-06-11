namespace SomeComany.BackUp

module Backup =
    open System
    open System.Net.Mail
    open System.Diagnostics
    open System.IO
    open SomeCompany.BackUp.Parser

    type CopyDirectoryResult = CopiedFiles | FailedToCopyFiles of String
    type PurgeFileResult = PurgedFiles | FailedToPurgeFiles of String
    type ServiceManagerAction = LocateService | StopService | StartService
    type ServiceManagerActionStatus = ActionSucceeded of Options | ActionFailed of string

    let execute (args: string[]) notifier logger directoryCopier filePurger serviceManager =
        let sendSuccessEmail (options: Options) =
            let content = String.Format("The backup utility successfully backed up data from \"{0}\" to \"{1}\" at {2} on {3}.",
                                            options.Source,
                                            options.Destination,
                                            DateTime.Now.ToShortTimeString(),
                                            DateTime.Now.ToShortDateString())
            let msg = new MailMessage(options.FromEmail, options.SuccessEmail, "File Backup Succeeded", content)
            notifier options msg

        let sendFailureEmail (options : Options) =
            let content = String.Format("The backup utility failed to back up data from \"{0}\" to \"{1}\" at {2} on {3}.\n\nCheck the affected system's event logs for details.",
                                            options.Source,
                                            options.Destination,
                                            DateTime.Now.ToShortTimeString(),
                                            DateTime.Now.ToShortDateString())
            let msg = new MailMessage(options.FromEmail, options.FailureEmail, "File Backup Failed!", content)
            notifier options msg

        let processSuccess options =
            sendSuccessEmail options
            0

        let processFailureNoOptions (message : string) =
            logger message
            -1

        let processFailure options (message : string) =
            sendFailureEmail options
            let extendedMessage = sprintf "The file backup utility failed while attempting to conduct a backup due to the following error:\n\n%s" message
            processFailureNoOptions extendedMessage

        let postCopyProcessing options =
            if options.Service.IsSome then
                match serviceManager StartService options with
                | ActionFailed s -> processFailure options (sprintf "The following error occured while attempted to start the specified service: %s" s)
                | ActionSucceeded options -> processSuccess options
            else
                processSuccess options

        let attemptServiceRestart failedActionName originalErrorMessage options =
            let mutable fullErrorMessage = "An error occured after a system process was stopped."
            match serviceManager StartService options with
            | ActionFailed message -> fullErrorMessage <- fullErrorMessage + (sprintf "\nThe process could not be restarted for the following reason: %s" originalErrorMessage)
            | ActionSucceeded options -> fullErrorMessage <- fullErrorMessage + "\nThe process was successfully restarted after the error."
            processFailure options (fullErrorMessage + (sprintf "\n The error occured while attempting '%s' action, and was reported as follows: %s" failedActionName originalErrorMessage))

        let postServiceProcessing options =
            match directoryCopier options with
            | FailedToCopyFiles s -> 
                if options.Service.IsSome then
                    attemptServiceRestart "copy files" s options
                else
                    processFailure options (sprintf "An error occured while attempting to copy files, and was reported as follows: %s" s)
            | CopiedFiles -> 
            match options.MaxDays with
            | None -> postCopyProcessing options
            | Some days -> 
            match filePurger options.Destination days with
            | FailedToPurgeFiles s ->
                if options.Service.IsSome then
                    attemptServiceRestart "purge files" s options
                else
                    processFailure options (sprintf "An error occured while attempting to purge files, and was reported as follows: %s" s)
            | PurgedFiles -> postCopyProcessing options
            
        match parseArgs args with
        | Failure s -> processFailureNoOptions s
        | Success options -> 
            if options.Service.IsSome then
                match serviceManager LocateService options with
                | ActionFailed s -> processFailure options (sprintf "The following error occured while attempted to locate the specified service: %s" s)
                | ActionSucceeded options ->
                match serviceManager StopService options with
                | ActionFailed s -> processFailure options (sprintf "The following error occured while attempted to stop the specified service: %s" s)
                | ActionSucceeded options -> postServiceProcessing options
            else
                postServiceProcessing options

    [<EntryPoint>]
    let main (args: string[]) =
        let notifier options msg = 
            let s = new SmtpClient(options.SmtpServer)
            s.Send(msg)

        let logger msg = 
            EventLog.WriteEntry("File Backup Utility", msg, EventLogEntryType.Error)

        let filePurger dstPath days=
            let rec filePurgeRec dstPath days =
                match Directory.Exists(dstPath) with
                | false -> FailedToPurgeFiles "No destination directory was found to purge."
                | true ->
                    let dstDir = new System.IO.DirectoryInfo(dstPath)
                    let daysToPurge = -1.0 * (double)days
                    try
                        dstDir.GetFiles()
                        |> Array.map (fun fileToDelete ->
                            if fileToDelete.LastWriteTime < DateTime.Now.AddDays(daysToPurge) then
                                fileToDelete.Delete())
                        |> ignore

                        dstDir.GetDirectories()
                            |> Array.map (fun subdir ->
                                let dstSubDir = System.IO.Path.Combine(dstPath, subdir.Name)
                                filePurgeRec dstSubDir)
                            |> ignore
                        PurgedFiles     
                    with
                        | _ as ex -> FailedToPurgeFiles ex.Message
            filePurgeRec dstPath days

        let directoryCopier options =
            let rec directoryCopy srcPath dstPath =
                match Directory.Exists(srcPath) with
                    |false -> FailedToCopyFiles "The source directory does not exist."
                    |true ->
                        if not <| Directory.Exists(dstPath) then
                            Directory.CreateDirectory(dstPath) |> ignore

                        let srcDir = new DirectoryInfo(srcPath)
                        srcDir.GetFiles()
                        |> Array.map (fun file ->
                            let temppath = Path.Combine(dstPath, file.Name)
                            file.CopyTo(temppath, true) |> ignore
                            file.Delete())
                        |> ignore

                        srcDir.GetDirectories()
                        |> Array.map (fun subdir ->
                            let dstSubDir = System.IO.Path.Combine(dstPath, subdir.Name)
                            directoryCopy subdir.FullName dstSubDir)
                        |> ignore
                        CopiedFiles
            directoryCopy options.Source options.Destination

        let serviceManager action options =
            match action with
            | LocateService -> ActionSucceeded options
            | StopService -> ActionSucceeded options
            | StartService -> ActionSucceeded options

        execute args notifier logger directoryCopier filePurger serviceManager