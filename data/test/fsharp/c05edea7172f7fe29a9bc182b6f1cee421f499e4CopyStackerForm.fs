namespace CopyStacker

open System
open System.Windows.Forms
open System.Runtime.InteropServices
open System.Security.Permissions

open Clipboard
open ClipboardUtil
 
module Windows =
    [<DllImport("User32.dll")>]
    extern IntPtr SetClipboardViewer(IntPtr hWndNewViewer)

    [<DllImport("User32.dll")>]
    extern bool ChangeClipboardChain(IntPtr hWndRemove, IntPtr hWndNewNext)

    [<DllImport("user32.dll")>]
    extern [<return: MarshalAs(UnmanagedType.Bool)>] bool RegisterHotKey(IntPtr hWnd, int id, int fsModifiers, int vk);
 
    [<DllImport("user32.dll")>]
    extern bool UnregisterHotKey(IntPtr hWnd, int id);

    [<Literal>]
    let private WM_DRAWCLIPBOARD = 0x308

    [<Literal>]
    let private WM_DESTROY = 0x002

    [<Literal>]
    let private WM_HOTKEY = 0x0312;

    [<Literal>]
    let private ALT = 0x0001;
    
    [<Literal>]
    let private WIN = 0x0008;

    [<Literal>]
    let private PASTE_POP_ID = 234323
    
    [<Literal>]
    let private SENSITIVE_COPY_ID = 112123

    type CopyStackerForm() =
        inherit Form(Visible = false, Text = "")
        do RegisterHotKey(base.Handle, PASTE_POP_ID, WIN ||| ALT, (int) Keys.V) |> ignore
        do RegisterHotKey(base.Handle, SENSITIVE_COPY_ID, WIN ||| ALT, (int) Keys.C) |> ignore
        let nextClipboardViewer = SetClipboardViewer(base.Handle)
        
        let mutable ignoreCopy = false;
        let mutable clipboardState: CopyStackerState<Windows.IDataObject> = { Stack = [] }

        member private this.sendPaste() = do ClipboardUtil.SendPasteToKeyboardFocus(base.Handle)
        member private this.processClipboardEvent(state, event) = 
            let result = Clipboard.ProcessClipboardEvent(ClipboardUtil.GetClipboardData)(state, event)
            do clipboardState <- result.State
            do result.Actions |> List.iter(fun action -> 
                match action with
                    | SendPaste -> this.sendPaste()
                    | SetClipboardData(data) -> ClipboardUtil.SetClipboardData(data))

        override this.WndProc(m) = 
            do match m.Msg with
                | WM_HOTKEY -> 
                    match m.WParam with
                        | hotkeyId when hotkeyId = nativeint PASTE_POP_ID -> 
                            ignoreCopy <- true
                            do this.processClipboardEvent(clipboardState, ClipboardEvent.PastePopEvent)
                        | hotkeyId when hotkeyId = nativeint SENSITIVE_COPY_ID ->
                            do this.processClipboardEvent(clipboardState, ClipboardEvent.SensitiveCopyEvent)
                        | _ -> () 
                | WM_DRAWCLIPBOARD -> 
                    // For some reason we get this message twice when we call Clipboard.SetDataObject, so ignore the first one
                    if ignoreCopy then do ignoreCopy <- false 
                    else do this.processClipboardEvent(clipboardState, ClipboardEvent.CopyEvent)
                | WM_DESTROY -> ChangeClipboardChain(base.Handle, nextClipboardViewer) |> ignore
                | _ -> ()
            base.WndProc(&m)