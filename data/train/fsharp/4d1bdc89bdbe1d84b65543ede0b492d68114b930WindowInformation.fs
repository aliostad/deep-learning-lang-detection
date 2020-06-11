namespace BucklingSprings.Aware.Collector


open BucklingSprings.Aware.Core
open BucklingSprings.Aware.Core.Diagnostics
open BucklingSprings.Aware.Core.Models

open System.Text
open System.Management
open System.Diagnostics
open System.Runtime.InteropServices
open System.Linq


module NativeWindowInformation =
    [<DllImport("user32.dll")>]
    extern System.IntPtr GetForegroundWindow()
    [<DllImport("user32.dll")>]
    extern int GetWindowTextLength(System.IntPtr hWnd)
    [<DllImport("user32.dll")>]
    extern int GetWindowText(System.IntPtr hWnd, [<Out>] System.Text.StringBuilder lpString, int nMaxCount);

    [<DllImport("user32.dll")>]
    extern int GetWindowThreadProcessId(System.IntPtr hWnd, [<Out>] int& lpdwProcessId)


module WindowInformation =

    let extractCommandLine (prc : Process) fallback =
        try
            let q = sprintf "Select * From Win32_Process Where ProcessID = %d" prc.Id
            use searcher = new ManagementObjectSearcher(q)
            let processList = searcher.Get()
            if processList.Count > 0 then
                let en = processList.GetEnumerator()
                en.MoveNext() |> ignore
                let p = en.Current
                (p.GetPropertyValue("CommandLine") :?> string)
            else
                prc.ProcessName
        with
            | ex -> fallback

    
    let extractProcessName (title : string) (prc : Process) = 
        let fallBack =  prc.ProcessName
        let processName = try
                            let descr = prc.MainModule.FileVersionInfo.FileDescription
                            if (System.String.IsNullOrWhiteSpace(descr)) then fallBack else descr
                          with
                            | _ -> fallBack
        (* Windows 8 Compat and other hosts *)
        if processName = "Microsoft WWA Host" then
            title
        elif processName = "Application Frame Host" && title.EndsWith("Microsoft Edge") then
            "Microsoft Edge"
        elif processName = "Application Frame Host" then
            title
        elif processName = "Java(TM) Platform SE binary" then
            extractCommandLine prc title
        else
            processName

    let ensureContent p =
        let processName, title = p
        if System.String.IsNullOrWhiteSpace(processName) && (not (System.String.IsNullOrWhiteSpace(title))) then
            (title, title)
        elif System.String.IsNullOrWhiteSpace(title) && (not(System.String.IsNullOrWhiteSpace(processName))) then
            (processName, processName)
        elif System.String.IsNullOrWhiteSpace(title) && System.String.IsNullOrWhiteSpace(processName) then
            (PrimitiveConstants.unknownProgramTitle, PrimitiveConstants.unknownProgram)
        else
            p

    
    let getForeGroundWindowInformation () : (string * string) =
        try
            let hWnd = NativeWindowInformation.GetForegroundWindow()
            if System.IntPtr.Zero.Equals(hWnd) then
                (PrimitiveConstants.unknownProgramTitle, PrimitiveConstants.unknownProgram)
            else
                let sb = StringBuilder(NativeWindowInformation.GetWindowTextLength(hWnd)+1)
                ignore(NativeWindowInformation.GetWindowText(hWnd, sb, sb.Capacity))
                let mutable pid = 0
                if NativeWindowInformation.GetWindowThreadProcessId(hWnd, &pid) > 0 then
                    use proc = Process.GetProcessById(pid) // Might throw ArgumentException if no longer running
                    let title = sb.ToString()
                    ensureContent ((extractProcessName title proc), title)
                else
                    (PrimitiveConstants.unknownProgramTitle, PrimitiveConstants.unknownProgram)
         with
            | ex ->
                    (PrimitiveConstants.unknownProgramTitle, PrimitiveConstants.unknownProgram)
