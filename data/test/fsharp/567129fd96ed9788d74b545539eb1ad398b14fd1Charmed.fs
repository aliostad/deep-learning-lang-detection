#nowarn "51"

open Piper
open Phoebe
open Prue

open System
open System.Collections
open System.Text
open System.Diagnostics
open System.Runtime.InteropServices
open Microsoft.FSharp.NativeInterop

let VK_TAB = 0x09uy
let VK_ENTER = 0x0Duy

let KEYEVENTF_KEYUP = 0x2u

let ☭ keyCode =
    let KEYEVENTF_EXTENDEDKEY   = 0x1u
    let KEYEVENTF_KEYUP         = 0x2u
    keybd_event( keyCode, 0x45uy, KEYEVENTF_EXTENDEDKEY, System.UIntPtr.Zero )
    keybd_event( keyCode, 0x45uy, KEYEVENTF_EXTENDEDKEY ||| KEYEVENTF_KEYUP, System.UIntPtr.Zero )

let ♥ (inStringI : string) (speed : int) =
    let x = ref 0
    let InString=inStringI.ToUpperInvariant()
    let rec go (inStringChar : char ref) =
        let mutable mInput : INPUT  = INPUT()
        let mutable ki : KEYBDINPUT = KEYBDINPUT()
        mInput.typefield    <- 1
        ki.wVk              <- !inStringChar
        mInput.ki           <- ki
        System.Threading.Thread.Sleep(speed)
        SendInput(1u, &mInput, Marshal.SizeOf(typedefof<INPUT>)) |> ignore
        x := !x + 1
        if !x <> InString.Length then
            inStringChar := InString.Chars(!x)
            go inStringChar
    go <| ref ( InString.Chars(0) )

let mutable TargetWindow        = ""
let mutable SearchByWindowName  = true
let ★ (data : byte array) (baseAddress : IntPtr) =
    let mutable ProcID = 0u
    let WindowHandle = FindWindow(null, TargetWindow)
    if SearchByWindowName then
        GetWindowThreadProcessId(WindowHandle, &ProcID)
        |> ignore
    else ProcID <- UInt32.Parse(TargetWindow) 

    let dwDesiredAccess =
        ProcessAccess.VMOperation
        ||| ProcessAccess.VMRead
        ||| ProcessAccess.VMWrite
    let ps = OpenProcess(dwDesiredAccess, false, ProcID)
    printfn "process: %A" ps
    
    let mutable memory = VirtualAllocEx(  ps
                                        , baseAddress //IntPtr.Zero
                                        , Convert.ToUInt32(data.Length)
                                        , AllocationType.Commit
                                        , MemoryProtection.ReadWrite)
    printfn "memory: %A" memory

    let mutable bytesWritten = 0;
    WriteProcessMemory(   ps
                        , memory
                        , data
                        , Convert.ToUInt32(data.Length)
                        , &bytesWritten
                        ) |> ignore
    printfn "bytesWritten: %A" bytesWritten
    
let pro = new System.Diagnostics.Process()
pro.StartInfo.FileName <- "notepad.exe"
if not <| pro.Start() then
    printfn "Can't find your notepad"
else
    let rHandle = pro.Handle
    if rHandle = System.IntPtr.Zero then
        printfn "can't run %s" pro.StartInfo.FileName
    System.Threading.Thread.Sleep(200) // let it open
    ♥ "The Charmed" 100; ☭ VK_ENTER; ☭ VK_ENTER
    try
        ★ <| decode "0xffd8ffe0" <| new System.IntPtr(1000)
        ♥ "Success" 100; ☭ VK_ENTER
    with
    | _ as ex -> ♥ ex.Message 20; ☭ VK_ENTER
    System.Threading.Thread.Sleep(1500)
    pro.Kill()
    pro.Close()
    
