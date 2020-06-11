[<AutoOpen>]
module shelly.Shell

open System
open System.IO

let inline shellexecute cmd args =
    let proc = new System.Diagnostics.ProcessStartInfo(cmd)
    proc.RedirectStandardOutput <- false
    proc.UseShellExecute <- true
    proc.Arguments <- args
    let p = System.Diagnostics.Process.Start(proc)
    p.WaitForExit()
let inline shell cmd args =
    let proc = new System.Diagnostics.ProcessStartInfo(cmd)
    proc.RedirectStandardOutput <- true
    proc.UseShellExecute <- false
    proc.Arguments <- args
    let p = System.Diagnostics.Process.Start(proc)
    let tool_output = p.StandardOutput.ReadToEnd()
    p.WaitForExit()
    tool_output
let inline shellx a b = cprintf ConsoleColor.DarkGray <| "%s" <| shell a b
let inline shellxf a b = cprintf ConsoleColor.DarkCyan  <| "%s\n" <| shell a b
let inline shellxn a b = cprintf ConsoleColor.DarkGreen <| "%s\n" <| shell a b
