namespace Pop

open System
open System.Diagnostics
open System.Threading
open System.IO
open Pop.Cs

module PopOpen =

    type Result<'TEntity> =
        | Success of 'TEntity
        | Failure of string

    
    type Input = { File: string; Prc: Process }

    let mutable Log = fun s -> printfn "%s" s
        

    let internal Start (file: string) = 
        {
            File = file;
            Prc = file |> Process.Start
        }

    let internal CheckTitle (input: Input) (windowTitle: string) =
        let fileName = (Path.GetFileNameWithoutExtension input.File).ToLowerInvariant()
        Log ("Filename: " + fileName)
        windowTitle.ToLowerInvariant().Contains fileName

    let internal FindProcessHandle (input : Input) =
        try
            Log(String.Format("FindProcessHandle: ProcessId - {0}, Handle - {1}, Title - {2}", input.Prc.Id, input.Prc.MainWindowHandle, input.Prc.MainWindowTitle))

            if CheckTitle input input.Prc.MainWindowTitle
            then Log "Found"
                 Success input.Prc.MainWindowHandle
            else Log "File not loaded yet"
                 Failure "FileNotLoadedYet"

        with
            | :? System.InvalidOperationException -> Failure "InvalidOperationException"
            | :? System.NullReferenceException -> Failure "NullReferenceException"


    let internal FindLockHandle (input: Input) =
        
        input.File
        |> fun f -> [f]
        |> InUseDetection.GetProcessesUsingFiles
        |> List.ofSeq<Process>
        |> fun ps -> match ps with
                     | [] ->    Log "Can't find the locking process"
                                Failure "Can't find the process"
                     
                     | p::_ ->  Log(String.Format("FindLockHandle: ProcessId - {0}, Handle - {1}, Title - {2}", p.Id, p.MainWindowHandle, p.MainWindowTitle))
                                if CheckTitle input p.MainWindowTitle
                                then Log "Found"
                                     Success p.MainWindowHandle
                                else Log "File not loaded yet" 
                                     Failure "FileNotLoadedYet"

    let BringToFront handle =
        let HWND_TOPMOST = new IntPtr -1
        let HWND_NOTOPMOST = new IntPtr -2;
        let SWP_SHOWWINDOW = 0x0040u

        let mutable rect = new InteropNative.RECT()
        let result = InteropNative.GetWindowRect(handle, &rect)

        Log (String.Format("Popping up {0}, Rect: {1} {2} {3} {4}", handle, rect.Top, rect.Left, rect.Right, rect.Bottom))
        
        rect.Width <- rect.Right - rect.Left
        rect.Height <- rect.Bottom - rect.Top

        InteropNative.SetWindowPos (handle, HWND_TOPMOST, rect.Left, rect.Top, rect.Width, rect.Height, SWP_SHOWWINDOW) |> ignore
        Thread.Sleep 300
        InteropNative.SetWindowPos (handle, HWND_TOPMOST, rect.Left, rect.Top, rect.Width, rect.Height, SWP_SHOWWINDOW) |> ignore
        InteropNative.SetWindowPos (handle, HWND_NOTOPMOST, rect.Left, rect.Top, rect.Width, rect.Height, SWP_SHOWWINDOW) |> ignore
        
        handle

    let internal FindHandle findLockHandle findProcessHandle (waitTime: float) (input: Input) =
        let timeToStop = DateTime.UtcNow.AddSeconds(waitTime)

        let rec loop handle =
            Thread.Sleep 200
            
            let handle =
                match findProcessHandle input with
                | Success h -> h
                | Failure f -> match findLockHandle input with
                               | Success h -> h
                               | Failure f -> 0n

            if handle <> 0n || DateTime.UtcNow > timeToStop
            then handle
            else loop handle
            
        loop 0n

    let OpenInternal start (waitTime: int) findLockHandle findProcessHandle file = 
        file 
        |> start 
        |> FindHandle findLockHandle findProcessHandle (float waitTime)
        |> BringToFront

    let WaitSeconds = 30

    let Open (file: string) = 
        OpenInternal Start WaitSeconds FindLockHandle FindProcessHandle file 

    let OpenW (file: string, waitSeconds) = 
        OpenInternal Start waitSeconds FindLockHandle FindProcessHandle file

    let logToFile (log: string) =
        let path = Path.Combine(Path.GetTempPath(), "pop.log")
        
        use writer = new StreamWriter(path, true)
        DateTime.UtcNow.ToString("YYYY-MM-DD hh:mmm:ss") + log |> writer.WriteLine |> ignore

    let OpenD ((file: string), (logFn: Action<string>)) = 
        Log <- fun s ->  logFn.Invoke(s)
        OpenInternal Start WaitSeconds FindLockHandle FindProcessHandle file
