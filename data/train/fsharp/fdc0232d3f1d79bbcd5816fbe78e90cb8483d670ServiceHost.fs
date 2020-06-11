module R4nd0mApps.TddStud10.Common.ServiceHost

open System.Diagnostics

let private logger = R4nd0mApps.TddStud10.Logger.LoggerFactory.logger

let rec commitSucideOnParentExit ppid = 
    async { 
        let pRunning = 
            SafeExec.safeExec2 (fun () -> Process.GetProcessById(ppid)) 
            |> Option.fold (fun _ e -> not e.HasExited) false
        if not pRunning then 
            logger.logInfof "Parent (ID = %d) is not running. Committing suicide..." ppid
            Process.GetCurrentProcess().Kill()
        do! Async.Sleep(60000)
        return! commitSucideOnParentExit ppid
    }
