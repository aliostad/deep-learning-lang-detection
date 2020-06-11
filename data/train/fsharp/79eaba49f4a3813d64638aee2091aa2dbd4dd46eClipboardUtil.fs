namespace CopyStacker

open System
open System.Runtime.InteropServices
open System.Threading
open System.Threading.Tasks
open System.Windows

open CopyStacker.CollectionUtil

module ClipboardUtil =

    [<DllImport("user32.dll")>]
    extern IntPtr GetFocus();

    [<DllImport("user32.dll")>]
    extern IntPtr GetForegroundWindow();

    [<DllImport("user32.dll")>]
    extern IntPtr GetWindowThreadProcessId(IntPtr hWnd, IntPtr processId);

    [<DllImport("user32.dll")>]
    extern IntPtr AttachThreadInput(IntPtr idAttach, IntPtr idAttachTo, bool fAttach);

    [<DllImport("user32.dll")>]
    extern int SendMessage(IntPtr hWnd, IntPtr msg, int wParam, int lParam);

    [<Literal>]
    let private WM_PASTE = 0x0302

    let SendPasteToKeyboardFocus(originHandle: IntPtr) =
        let getProcessId handle = GetWindowThreadProcessId(handle, IntPtr.Zero) 
        let foregroundProcessId = GetForegroundWindow() |> getProcessId
        let originProcessId = originHandle |> getProcessId
        do AttachThreadInput(foregroundProcessId, originProcessId, true) |> ignore
        
        do SendMessage(GetFocus(), nativeint WM_PASTE, 0, 0) |> ignore       
        
        do AttachThreadInput(foregroundProcessId, originProcessId, false) |> ignore

    let private DoClipboardOp(operation: unit -> unit) =
        let thread = new Thread(operation, ApartmentState = ApartmentState.STA)
        do thread.Start()
        
    let private CopyDataObject(dataObject: IDataObject): IDataObject =
        dataObject.GetFormats()
            |> Array.zipWith(dataObject.GetData)
            |> Array.fold(fun newDataObject (format, data) -> 
                do newDataObject.SetData(format, data)
                newDataObject)(new DataObject() :> IDataObject)

    let GetClipboardData() =
        let tcs = new TaskCompletionSource<IDataObject>()
        let operation() = 
            try Clipboard.GetDataObject() 
                |> fun clipboardData -> 
                    if clipboardData = null then new DataObject() :> IDataObject
                    else clipboardData
                |> CopyDataObject
                |> tcs.SetResult
            with 
                | e -> tcs.SetException(e)
        do DoClipboardOp(operation)
        tcs.Task.Result

    let SetClipboardData(dataObject: IDataObject) =
        let operation() = Clipboard.SetDataObject(dataObject, true)
        do DoClipboardOp(operation)