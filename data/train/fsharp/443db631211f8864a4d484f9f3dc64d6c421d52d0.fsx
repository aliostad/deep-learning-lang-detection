open System
open System.Diagnostics
open System.Runtime.InteropServices

let getOutlook() = Process.GetProcessesByName "OUTLOOK" |> Seq.toList

[<DllImport "user32.dll">]
extern void SetForegroundWindow(IntPtr hWnd)

let (|Exited|_|) (p: Process) =
    if p.HasExited then Some()
    else None

let (|Hidden|_|) (p: Process) =
    if p.MainWindowHandle = 0n then Some()
    else None

let start =
    let rec waitForExit () =
        async {
            do! Async.Sleep 10000

            return!
                match getOutlook() with
                | [] | Exited :: _ -> sleep()
                | _ -> waitForExit()
        }
    and sleep () =
        async {
            do! Async.Sleep (60 * 60 * 1000)
        
            match getOutlook() with
            | [] | (Hidden | Exited) :: _ ->
                async {
                    use p = Process.Start "OUTLOOK"
                    while not p.HasExited do
                        do! Async.Sleep 10000
                }
                |> Async.Start
            | p :: _ ->
                SetForegroundWindow p.MainWindowHandle

            return! waitForExit()
        }
    waitForExit >> Async.RunSynchronously

[<System.STAThread>]
do  start()

#if INTERACTIVE
let (++) a b = System.IO.Path.Combine(a, b)
let source = __SOURCE_DIRECTORY__ ++ __SOURCE_FILE__
let args = sprintf "--target:winexe %s -o:%s" source <| source.Replace("fsx", "exe")
System.Diagnostics.Process.Start(System.AppDomain.CurrentDomain.BaseDirectory ++ "fsc", args)
#endif