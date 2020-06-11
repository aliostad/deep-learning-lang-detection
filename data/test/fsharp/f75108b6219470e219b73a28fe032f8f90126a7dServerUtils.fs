namespace DotNetMon

module ServerUtils = 
    open System.Diagnostics
    open Cli
    open IoUtils
    
    let stopServer() = 
        let dnx = Process.GetProcessesByName("dnx")
        if (dnx.Length > 0) then dnx.[0].Kill()
    
    let startServer (env : string) server path = 
        let start = processStartWrapper env (path + " " + server)
        start
    
    let startDnx server path = startServer "dnx" server path
    let startDnxKestrel path = startDnx "kestrel" path
    let startServerDefaults() = startDnxKestrel "."
