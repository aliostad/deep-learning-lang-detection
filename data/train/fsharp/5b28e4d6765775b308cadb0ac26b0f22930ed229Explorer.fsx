
let home = System.Environment.GetEnvironmentVariable("HOME")
let projects = System.Environment.GetEnvironmentVariable("PROJECTS")

open System
open System.Text
open System.Collections.Generic
open System.Runtime.InteropServices
open Microsoft.FSharp.NativeInterop


#nowarn "9"
[<AutoOpen>]
module User32 = 

    /// Copy the text of the specified window's title bar (if it has one) into a buffer. 
    //  If the specified window is a control, the text of the control is copied. 
    //  However, GetWindowText cannot retrieve the text of a control in another application.
    [<DllImport("user32.dll", CharSet = CharSet.Unicode)>]
    extern int GetWindowText(IntPtr hWnd, StringBuilder strText, int maxCount)

    [<DllImport("user32.dll", CharSet = CharSet.Unicode)>]
    extern int GetWindowTextLength(IntPtr hWnd)

    /// Copy the text for the window pointed to by hWnd into managed memory space.
    let CopyWindowText hWnd =
        let size = GetWindowTextLength(hWnd)
        if (size > 0) then
            let builder = new StringBuilder(size + 1)
            GetWindowText(hWnd, builder, builder.Capacity) |> ignore
            builder.ToString()
        else String.Empty

    // Delegate to filter which windows to include 
    type EnumWindowsProc = delegate of IntPtr * IntPtr -> bool

    /// Enumerate all top-level windows on the screen by passing the handle to each window, 
    /// in turn, to an application-defined callback function. EnumWindows continues 
    /// until the last top-level window is enumerated or the callback function returns false.
    [<DllImport("user32.dll")>]
    extern bool EnumWindows(EnumWindowsProc enumProc, IntPtr lParam)

    /// Retrieve a window handle to the specified window's parent or owner.
    [<DllImport("user32.dll")>]
    extern IntPtr GetParent(IntPtr hWnd)

    /// Retrieve the thread id and, optionally, the process id that created the specified window.  
    [<DllImport("user32.dll", CallingConvention = CallingConvention.Cdecl)>]
    extern int GetWindowThreadProcessId(IntPtr window, [<In; Out>] IntPtr processId)

    /// Change the position and dimensions of the specified window. 
    //  For a top-level window, the position and dimensions are relative to the upper-left corner of the screen. 
    //  For a child window, they are relative to the upper-left corner of the parent window's client area. 
    [<DllImport("User32.dll")>]
    extern bool MoveWindow(IntPtr handle, int x, int y, int width, int height, bool redraw)

    let SW_FORCEMINIMIZE   = 11
    let SW_HIDE            = 0
    let SW_MAXIMIZE        = 3
    let SW_MINIMIZE        = 6
    let SW_RESTORE         = 9
    let SW_SHOW            = 5
    let SW_SHOWDEFAULT     = 10
    let SW_SHOWMAXIMIZED   = 3
    let SW_SHOWMINIMIZED   = 2
    let SW_SHOWMINNOACTIVE = 7
    let SW_SHOWNA          = 8
    let SW_SHOWNOACTIVATE  = 4
    let SW_SHOWNORMAL      = 1
    /// Sets the specified window's show state.
    [<DllImport("User32.dll")>]
    extern bool ShowWindow(IntPtr handle, int nCmdShow)


[<AutoOpen>]
module Kernel32 = 
    let TH32CS_INHERIT      = 80000000u
    let TH32CS_SNAPHEAPLIST = 1u
    let TH32CS_SNAPMODULE   = 8u
    let TH32CS_SNAPMODULE32 = 10u
    let TH32CS_SNAPPROCESS  = 2u
    let TH32CS_SNAPTHREAD   = 4u
    let TH32CS_SNAPALL      = TH32CS_SNAPHEAPLIST ||| TH32CS_SNAPMODULE ||| TH32CS_SNAPPROCESS ||| TH32CS_SNAPTHREAD
    /// Takes a snapshot of the specified processes, as well as the heaps, 
    /// modules, and threads used by these processes.
    [<DllImport("kernel32.dll", SetLastError = true)>]
    extern IntPtr CreateToolhelp32Snapshot(uint32 dwFlags, uint32 th32ProcessID)

    /// Describe an entry from a list of the processes residing in the system address space 
    /// when a snapshot was taken.
    [<StructLayout(LayoutKind.Sequential)>]
    type PROCESSENTRY32 =
        val mutable dwSize              : uint32 
        val mutable cntUsage            : uint32
        val mutable th32ProcessID       : uint32
        val mutable th32DefaultHeapID   : IntPtr
        val mutable th32ModuleID        : uint32
        val mutable cntThreads          : uint32
        val mutable th32ParentProcessID : uint32
        val mutable pcPriClassBase      : uint32
        val mutable dwFlags             : uint32
        [<MarshalAs(UnmanagedType.ByValTStr, SizeConst = 260)>]
        val mutable szExeFile           : string

        new (dwSize              : uint32, 
             cntUsage            : uint32, 
             th32ProcessID       : uint32, 
             th32DefaultHeapID   : IntPtr, 
             th32ModuleID        : uint32, 
             cntThreads          : uint32, 
             th32ParentProcessID : uint32, 
             pcPriClassBase      : uint32, 
             dwFlags             : uint32,
             szExeFile           : string) = { 
             dwSize              = dwSize
             cntUsage            = cntUsage 
             th32ProcessID       = th32ProcessID 
             th32DefaultHeapID   = th32DefaultHeapID
             th32ModuleID        = th32ModuleID 
             cntThreads          = cntThreads 
             th32ParentProcessID = th32ParentProcessID 
             pcPriClassBase      = pcPriClassBase 
             dwFlags             = dwFlags
             szExeFile           = szExeFile }
        new () = {
             dwSize              = (uint32) (Marshal.SizeOf(typeof<PROCESSENTRY32>))
             cntUsage            = 0u 
             th32ProcessID       = 0u 
             th32DefaultHeapID   = IntPtr.Zero
             th32ModuleID        = 0u 
             cntThreads          = 0u 
             th32ParentProcessID = 0u 
             pcPriClassBase      = 0u 
             dwFlags             = 0u
             szExeFile           = "" }

    /// Retrieve information about the first process encountered in a system snapshot.
    [<DllImport("kernel32.dll", CallingConvention = CallingConvention.Cdecl)>]
    extern bool Process32First(IntPtr hSnapshot, [<In; Out>] PROCESSENTRY32 lppe)

    /// Retrieve information about the next process recorded in a system snapshot.
    [<DllImport("kernel32.dll", CallingConvention = CallingConvention.Cdecl)>]
    extern bool Process32Next(IntPtr hSnapshot, [<In; Out>] PROCESSENTRY32 lppe)

#nowarn "9"
[<AutoOpen>]
module Utils = 
    /// Find all windows that match the given filter,
    /// where filter returns true for windows that should be returned 
    //  and false for windows that should not be returned
    let FindWindows (filter : IntPtr -> IntPtr -> bool) : List<IntPtr> =
        let windows = new List<IntPtr>()
        let enumWindowsProc wnd param =
            if (filter wnd param)  then
                // only add the windows that pass the filter
                windows.Add(wnd)
            // but return true here so that we iterate all windows
            true
        EnumWindows(new EnumWindowsProc(enumWindowsProc), IntPtr.Zero) |> ignore
        windows

    /// Find all windows that contain the given title text
    /// <param name="titleText"> The text that the window title must contain. </param>
    let FindWindowsWithText titleText =
        FindWindows(fun wnd _ -> CopyWindowText(wnd).Contains(titleText))

    /// Retrieve all windows for a given process id.
    let GetWindowsByProcessId pid = 
        FindWindows(fun wnd _ -> 
            let mutable p' = nativeint 0
            GetWindowThreadProcessId(wnd, NativePtr.toNativeInt &&p') |> ignore
            p' = nativeint pid)
        |> Set.ofSeq
        |> Array.ofSeq
        |> Array.sort

    let SWP_NOZORDER = int 0x0004uy
    let SWP_NOSIZE = int 0x0001uy
    let SWP_SHOWWINDOW = int 0x0040uy

    /// Start process biolerplate.
    let StartProcess fileName arguments = 
        let p = new System.Diagnostics.Process()
        p.StartInfo.FileName <- fileName    //"explorer.exe"
        p.StartInfo.Arguments <- arguments  //(sprintf @"/n /e,%s" home)
        p.StartInfo.RedirectStandardOutput <- false
        p.StartInfo.UseShellExecute <- false
        p.Start() |> ignore
        p

    /// Prompt and wait for key.
    let WaitForKey () =
        printf "$ > "
        Console.ReadLine() |> ignore

    /// Take snapshot of all processes.
    let Process32Snapshot () = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0u)

    /// Retrieve from the given snapshot all process entries passing the filter function.
    let PROCESSENTRY32ByFilter snapshot filter = 
        let mutable procInfo = ref (PROCESSENTRY32())
        let mutable res = new List<PROCESSENTRY32>()
        let copy (r : PROCESSENTRY32 ref) =
            PROCESSENTRY32((!r).dwSize, (!r).cntUsage, (!r).th32ProcessID, (!r).th32DefaultHeapID, 
                           (!r).th32ModuleID, (!r).cntThreads, (!r).th32ParentProcessID, 
                           (!r).pcPriClassBase, (!r).dwFlags, (!r).szExeFile)
        if (Process32First(snapshot, !procInfo) = true) then
            if (filter (!procInfo)) then 
                res.Add (copy procInfo)
            let mutable cont = Process32Next(snapshot, !procInfo)
            while cont do
                if (filter (!procInfo)) then 
                    res.Add (copy procInfo)
                cont <- Process32Next(snapshot, !procInfo)
        res 
        |> Array.ofSeq

    /// Retrieve process entry for a process id from the given snapshot.
    let PROCESSENTRY32ByPid snapshot pid = 
        PROCESSENTRY32ByFilter snapshot (fun processEntry -> pid = processEntry.th32ProcessID)
        

StartProcess "explorer.exe" (sprintf @"/n /select,%s" home) |> ignore
StartProcess "explorer.exe" (sprintf @"/n /select,%s" projects) |> ignore

System.Threading.Thread.Sleep (3000)

Diagnostics.Process.GetProcesses()
|> Array.filter (fun p -> 
    try p.HasExited |> not with _ -> false)
|> Array.filter (fun p -> p.ProcessName = "explorer")
|> Array.sortBy (fun p -> p.StartTime) 
|> fun x ->
    if x.Length >= 2 then
        MoveWindow (x.[x.Length-1].MainWindowHandle, 0, 0,   800, 860, true) |> ignore
        ShowWindow (x.[x.Length-1].MainWindowHandle, SW_SHOWNA)              |> ignore
        MoveWindow (x.[x.Length-2].MainWindowHandle, 800, 0, 800, 860, true) |> ignore
        ShowWindow (x.[x.Length-2].MainWindowHandle, SW_SHOW)                |> ignore
