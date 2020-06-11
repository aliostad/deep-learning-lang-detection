namespace mst

open System.Diagnostics

module ProcessScenario =
    
    let State_Process   = "PROCESSSCENARIO_STATE_PROCESS"

    let StartProcess (exePath : string) : Scenario<int> =
        scenario {  
            do! Scenario.LiftStackFrame

            let proc = new Process()
            do! Scenario.SetCleanupAction (fun () -> proc.Dispose())
            proc.StartInfo <- new ProcessStartInfo(exePath)
            if proc.Start() then
                do! Scenario.SetCleanupAction (fun () -> proc.Kill())
                if proc.WaitForInputIdle() then
                    do! Scenario.SetVariable State_Process proc
                    return proc.Id
                else
                    return! Scenario.Raise ("Failed to start as application never went idle: " + exePath)
            else
                return! Scenario.Raise ("Failed to start: " + exePath)
        }

