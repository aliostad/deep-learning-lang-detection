namespace TaskbarExtender

module Controllers =
    open System
    open System.Collections.Generic
    open System.Linq
    open System.Text
    open System.IO
    open System.IO.Pipes
    open System.Runtime.InteropServices
    open System.ComponentModel
    open System.Threading
    open System.Diagnostics
    open System.Windows
    open System.Windows.Interop
    open TaskbarExtender.NativeMethods

    
    

    ///<summary>
    /// Starts a 32bit stub process and, if running on a 64 bit system, a 64 bit stub process.
    /// The processes connect OS hooks and then wait for the "close" message to come on stdin
    /// they release the hooks before they close. Implements IDisposable to close the stub processes.
    ///</summary>
    ///ordinal is the ordinal in the dll that will be registered as a callback (mangled names seem to differ in 32bit and 64bit dlls
    ///but the ordinals are the same).  SystemCall is the OS defined
    ///constant that identifies which hook to listen to (examples WH_CALLWNDPROC and WH_SHELL);
    type ProcessStubController (ordinal: int, systemCall: int) = 
        let createProcessStub (executableName: string) (dllName: string) =
            let processStub = new Process()
            processStub.StartInfo.FileName <- executableName
            processStub.StartInfo.Arguments <- sprintf "%s %s %d %d" executableName dllName ordinal systemCall
            processStub.StartInfo.UseShellExecute <- false
            processStub.StartInfo.RedirectStandardInput <- true
            processStub.Start() |> ignore
            processStub

        let stub32bitProcess = createProcessStub "ProcessStubs\\ProcessStub32.exe" @"Dlls\PipeHooks32Dll.dll"
        let stub64bitProcess = 
            if System.Environment.Is64BitOperatingSystem
                then 
                    Some(createProcessStub "ProcessStubs\\ProcessStub64.exe" @"Dlls\PipeHooks64Dll.dll")
                else None
           
 
        member this.writeToProcessStubs (msg: string) =
            stub32bitProcess.StandardInput.Write(msg)
            match stub64bitProcess with
                | Some(p) -> p.StandardInput.Write(msg)
                | None -> ()

        member this.closeProcesses () =
            this.writeToProcessStubs "close"

        interface IDisposable with
            member this.Dispose () = this.closeProcesses()

    [<Interface>]
    type IHookServerControlledObject =
        abstract member PointIsInRange: double -> bool
        abstract member TaskbarContainsWindow: UInt64 -> bool
        abstract member AddWindowToTaskbar: UInt64 -> unit
        abstract member RemoveWindowFromTaskbar: UInt64 -> unit
        abstract member SendWindowClosedSignal: UInt64 -> unit
        abstract member SendWindowOpenedSignal: UInt64 -> unit

    ///<summary>
    ///     A convenience function for duck typing
    ///</summary>
    let inline makeHookServerControllerInterface (x: ^a) =
        {new IHookServerControlledObject with
            member this.PointIsInRange y = (^a : (member PointIsInRange: double -> bool) (x, y))
            member this.TaskbarContainsWindow y = (^a : (member TaskbarContainsWindow: UInt64 -> bool) (x, y))
            member this.AddWindowToTaskbar y = (^a : (member AddWindowToTaskbar: UInt64 -> unit) (x, y))
            member this.RemoveWindowFromTaskbar y = (^a : (member RemoveWindowFromTaskbar: UInt64 -> unit) (x, y))
            member this.SendWindowClosedSignal y = (^a : (member SendWindowClosedSignal: UInt64 -> unit) (x, y))
            member this.SendWindowOpenedSignal y = (^a : (member SendWindowOpenedSignal: UInt64 -> unit) (x, y))
            }

    ///<summary>
    /// Connects the named pipe server to the taskbar model.  No public interface but other objects can listen to events, implements
    /// IDisposable to close the named pipe server when it is disposed
    ///</summary>
    ///     <param name="hookServerName">
    ///         a string used for the named pipe server, should be the same as that used for the named pipe client
    ///     </param>
    ///     <param name = "taskbar">
    ///         The TaskbarModel that will be connected to the named pipe server
    ///     </param>
    type HookServerController (hookServerName: string, fxns: IHookServerControlledObject) =
        let windowMoved (handle: UInt64, x: double) =
            match (handle, x) with
                | _ when fxns.PointIsInRange x && not (fxns.TaskbarContainsWindow handle) -> fxns.AddWindowToTaskbar handle
                | _ when not (fxns.PointIsInRange x) && fxns.TaskbarContainsWindow handle -> fxns.RemoveWindowFromTaskbar handle
                | _ -> ()
          
        let windowOpened (handle: UInt64, xpos: double) =
            fxns.AddWindowToTaskbar handle
        
        let windowClosed (handle: UInt64, xpos: double) =
            fxns.SendWindowClosedSignal handle          

        let nativeServer = new TaskbarExtender.NativeMethods.NativeHookServer(hookServerName)
        
        let windowMovedEvent = new Event<_>() 
        let windowOpenedEvent = new Event<_>()
        let windowClosedEvent = new Event<_>()

        let routeMessages (msg: ClrWindowMessage) =
            printf "got message of type: %s from %d\n" (msg.message_type.ToString()) msg.hwnd
            match msg.message_type with
                |TaskbarMessage.MSG_WINDOW_OPENED ->  windowOpenedEvent.Trigger(msg.hwnd, double msg.x)
                |TaskbarMessage.MSG_WINDOW_CLOSED -> windowClosedEvent.Trigger(msg.hwnd, double msg.x)
                |TaskbarMessage.MSG_SIZEMOVE_EXIT -> printf "x: %d\n" msg.x; windowMovedEvent.Trigger(msg.hwnd, double msg.x)
                |TaskbarMessage.MSG_WINDOW_DESTROYED -> printf "************destroyed %d****************" msg.hwnd
                |TaskbarMessage.MSG_SIZEMOVE_ENTER -> ()
                |TaskbarMessage.MSG_WINDOW_MOVED -> ()
                |TaskbarMessage.MSG_SIZE_MAXIMIZED -> ()
                |TaskbarMessage.MSG_SIZE_MINIMIZED -> ()
                |TaskbarMessage.MSG_SIZE_RESTORED -> ()
                |TaskbarMessage.MSG_WINDOW_ACTIVATED -> ()
                |TaskbarMessage.MSG_WINDOW_DEACTIVATED -> ()
                | _ -> raise <| new Exception("Illegal message type received from named pipe")

        //Some ugliness neccessitated by vc++ f# interop
        let makeAdapter (evt: Event<_>) = new TaskbarExtender.NativeMethods.WindowMessageDelegate(fun msg -> evt.Trigger(msg))
        let windowMessageEvent = new Event<_>()
        let windowMessageAdapter = makeAdapter windowMessageEvent

        do
            //glue code for vc++ f# interop
            nativeServer.add_MessageReceived(windowMessageAdapter)
            windowMessageEvent.Publish
                |> Event.add routeMessages 
                  
            //hook up events
            windowMovedEvent.Publish
                |> Event.add windowMoved
            windowOpenedEvent.Publish
                |> Event.filter (fun (handle, xpos) -> fxns.PointIsInRange xpos)
                |> Event.add windowOpened
            windowClosedEvent.Publish
                //we want to pass on all close events so the window can be removed from the cache (i.e. no filtering)
                |> Event.add windowClosed

            //this initializes the named pipe server and begins listening for messages
            let listenThread = new Thread(
                                new ThreadStart(fun () -> 
                                                    nativeServer.StartListening() ))
            listenThread.Start()

        [<CLIEvent>]
        member this.WindowMoved = windowMovedEvent.Publish
        [<CLIEvent>]
        member this.WindowOpened = windowOpenedEvent.Publish
        [<CLIEvent>]
        member this.WindowClosed = windowClosedEvent.Publish

        interface IDisposable with
            member this.Dispose () =
                nativeServer.Dispose()

    [<System.Runtime.InteropServices.DllImport("User32.dll", EntryPoint="BringWindowToTop")>]
    extern bool BringWindowToTop(IntPtr hwnd)

    type WindowController() =
        static member ActivateWindow (windowHandle: UInt64) =
            let ptr = new IntPtr(int windowHandle)
            BringWindowToTop(ptr)

    

