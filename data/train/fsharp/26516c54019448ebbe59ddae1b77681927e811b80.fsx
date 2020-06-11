open System.Runtime.InteropServices
open System.Threading

type ConsoleCtrlDelegate = delegate of int -> bool

[<DllImport("kernel32.dll")>]
extern bool SetConsoleCtrlHandler(ConsoleCtrlDelegate handlerRoutine, bool add)

let cleanup () =
    printfn "Exiting..."

[<EntryPoint>]
let main _ =
    let handler = ConsoleCtrlDelegate(fun _ -> cleanup (); false)
    ignore (SetConsoleCtrlHandler(handler, true))

    try
        printfn "Press Ctrl+C to exit"
        Thread.Sleep Timeout.Infinite
        0
    finally
        ignore (SetConsoleCtrlHandler(handler, false))
