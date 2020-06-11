// ----------------------------------------------------------------------------
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.
// ----------------------------------------------------------------------------
namespace Yaaf.SyncLib.Ui 

open System
open System.Runtime.InteropServices 

module GtkUtils = 

    [<DllImport ("user32.dll", SetLastError = true)>]
    extern System.UInt32 GetWindowThreadProcessId ( System.IntPtr hWnd, int* lpdwProcessId)

    [<DllImport("user32.dll")>]
    extern IntPtr GetForegroundWindow ();

    
    [<DllImport ("user32.dll")>]
    extern [<MarshalAs (UnmanagedType.Bool)>] bool SetForegroundWindow (IntPtr hWnd);

    let bringToForeground() =
        try
            let current_proc = System.Diagnostics.Process.GetCurrentProcess()
            let current_proc_id = current_proc.Id
            let mutable set_foreground_window = true
            let mutable window_handle = GetForegroundWindow ()

            if (window_handle <> IntPtr.Zero) then
                set_foreground_window <- false

                let mutable window_handle_proc_id = 0
                GetWindowThreadProcessId (window_handle, &&window_handle_proc_id) |> ignore

                if (window_handle_proc_id <> current_proc_id) then
                    set_foreground_window <- true;


            if (set_foreground_window) then
                window_handle <- current_proc.MainWindowHandle
                if (window_handle <> IntPtr.Zero) then
                    SetForegroundWindow (window_handle) |> ignore       
        with
            | exn ->
                System.Console.WriteLine("Error pulling Tomboy to foreground: {0}", exn);
