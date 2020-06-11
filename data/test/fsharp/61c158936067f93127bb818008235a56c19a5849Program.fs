open System
open System.Diagnostics
open System.Threading
open System.Runtime.InteropServices

let mutable procReference = null : Process

let dispose () =
    match procReference with
        | null -> printfn "%O Process was closed properly." DateTime.UtcNow
        | r -> 
            r.Refresh()
            r.CloseMainWindow() |> ignore
    procReference <- null

type CtrlType =
    |  CTRL_C_EVENT = 0
    |  CTRL_BREAK_EVENT = 1
    |  CTRL_CLOSE_EVENT = 2
    |  CTRL_LOGOFF_EVENT = 5
    |  CTRL_SHUTDOWN_EVENT = 6

/// http://msdn.microsoft.com/en-us/library/windows/desktop/ms683242%28v=vs.85%29.aspx
let handleUnmanagedExit (ctrlType: int) =
    printfn "%O Application is exiting." DateTime.UtcNow
    dispose()
    true

//type EventHandler = delegate of CtrlType -> bool
type EventHandler = delegate of int -> bool
let _handler : EventHandler = new EventHandler(handleUnmanagedExit)

/// http://msdn.microsoft.com/en-gb/library/windows/desktop/ms686016%28v=vs.85%29.aspx
[<DllImport("Kernel32", CallingConvention = CallingConvention.Cdecl)>]
extern bool SetConsoleCtrlHandler(EventHandler handler, bool add)

/// Executed when process is shutting down.
let processExit eventArgs = 
    printfn "%O Process is exiting..." DateTime.UtcNow
    dispose()
    

/// Unhandled exception occured
let unhandledException (eventArgs : UnhandledExceptionEventArgs) =
    printfn "%O Unhandled exception: %O" DateTime.UtcNow eventArgs.ExceptionObject


/// Main entry point for the app.
[<EntryPoint>]
let main argv = 
    //AppDomain.CurrentDomain.ProcessExit.Add processExit
    //AppDomain.CurrentDomain.UnhandledException.Add unhandledException
    SetConsoleCtrlHandler(_handler, true) |> ignore
    let executabeCommand = System.Configuration.ConfigurationManager.AppSettings.["executabeCommand"]
    let timeout = System.Configuration.ConfigurationManager.AppSettings.["timeout"]
    while true do
        printfn "%O Starting process... (%O)" DateTime.UtcNow executabeCommand
        use proc = Process.Start(executabeCommand);
        procReference <- proc
        printfn "%O Started." DateTime.UtcNow
        try
            printfn "%O Sleeping %O for seconds" DateTime.UtcNow timeout
            Thread.Sleep(Int32.Parse(timeout) * 1000) 
        finally            
            printfn "%O Closing process..." DateTime.UtcNow
            proc.Refresh()
            proc.CloseMainWindow() |> ignore
            proc.WaitForExit()
            proc.Close()
            printfn "%O Closed." DateTime.UtcNow
    
    0 // return an integer exit code