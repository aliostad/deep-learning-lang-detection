// ----------------------------------------------------------------------------------------------
// Copyright (c) Mårten Rånge.
// ----------------------------------------------------------------------------------------------
// This source code is subject to terms and conditions of the Microsoft Public License. A
// copy of the license can be found in the License.html file at the root of this distribution.
// If you cannot locate the  Microsoft Public License, please send an email to
// dlr@microsoft.com. By using this source code in any fashion, you are agreeing to be bound
//  by the terms of the Microsoft Public License.
// ----------------------------------------------------------------------------------------------
// You must not remove this notice, or any other, from this software.
// ----------------------------------------------------------------------------------------------

// mst - Monadic Scenario Test
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

    let GetProcess : Scenario<Process> =
        scenario {
            return! Scenario.GetVariable State_Process
        }

    let WaitUntilIdle : Scenario<bool> =
        scenario {  
            let! proc = GetProcess
            return proc.WaitForInputIdle ()
        }

