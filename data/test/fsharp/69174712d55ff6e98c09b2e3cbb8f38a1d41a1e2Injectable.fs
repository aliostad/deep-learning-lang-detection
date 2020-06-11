/// This module contains the injected DLL which will create the local hooks.
module Injectable
open System.Reflection
open System
open System.Diagnostics
open EasyHook
open System.Windows.Forms
open System.Runtime.InteropServices

type MessageBoxOptions =
    | IconInformation = 0x00000040
    | IconAsterisk = 0x00000040
    | IconQuestion = 0x00000020
    | ButtonOk = 0x00000000
    | ButtonYesNo = 0x00000004

// Import the native method that we wish to hook by using P/Invoke
[<DllImport("user32.dll", CharSet = CharSet.Auto)>]
extern int MessageBox(IntPtr hWnd, String text, String caption, int options);

// A delegate must be created with a signature corresponding to the P/Invoke method
// The delegate has to be decorated with the UnmanagedFunctionPointerAttribute
[<UnmanagedFunctionPointer(CallingConvention.StdCall, CharSet = CharSet.Unicode, SetLastError = true)>]
type MessageBoxDelegate = delegate of IntPtr * String * String * int -> int

// Very simple Logging implementation, do notice that a Logging object MUST inherit from MarshalByRefObject
type Logger() =
    inherit MarshalByRefObject()
    member __.Log msg =
        printfn "[LOGGER] %s" msg

/// This is our hooked function which will always contain the same message
let messageBox hWnd (msg:string) caption options =
    MessageBox(hWnd, "HAHA I HACKED YOU!", caption, options)

type Main(context:RemoteHooking.IContext, inChannelName:string) as self =
    // Connect to the logging channel by using the provided channel name
    let remoteLog = RemoteHooking.IpcConnectClient<Logger> inChannelName
    do
        remoteLog.Log "I AM ALIVE!!!"

    // The entry point class must be marked with this interface there should be no more than one
    // class with this interface per assembly.
    interface IEntryPoint

    // This method will be invoked on injection
    member __.Run(ctx: RemoteHooking.IContext, inChannelName: string) =
        // This will be the Injector process not the winforms app
        let hostProcess = Process.GetProcessById ctx.HostPID
        remoteLog.Log (sprintf "Creating LocalHook on process <%s>..." hostProcess.ProcessName)

        //Install the local hook
        use localHook =
            LocalHook.Create(
                // Get native method handle
                LocalHook.GetProcAddress("user32.dll", "MessageBoxW"),

                // Initialize the corresponding delegate
                MessageBoxDelegate(messageBox),

                // Callback object should be this instance
                self)

        // Only apply this hook to the current thread
        localHook.ThreadACL.SetExclusiveACL [|0|]

        // Because the hook will be uninstalled on Dispose() we must keep this stack alive if
        // we want to persist the hook during the process lifetime
        Async.AwaitEvent hostProcess.Exited
        |> Async.RunSynchronously