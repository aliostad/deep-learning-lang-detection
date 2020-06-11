namespace KeyInputViewr.Core

(*
.NET向けのキーフックモジュール

■参考サイト
http://azumaya.s101.xrea.com/wiki/index.php?%B3%D0%BD%F1%2FC%A2%F4%2F%A5%B0%A5%ED%A1%BC%A5%D0%A5%EB%A5%D5%A5%C3%A5%AF
http://www.tech-archive.net/Archive/InetSDK/microsoft.public.inetsdk.programming.webbrowser_ctl/2006-04/msg00043.html
http://hiroakishibuki.wordpress.com/2007/11/16/lowlevelmousehook-%E3%82%B3%E3%83%B3%E3%83%9D%E3%83%BC%E3%83%8D%E3%83%B3%E3%83%88/
*)

open System
open System.Diagnostics
open System.Text

/// キーとマウスのフック
module GlobalHook =
    /// Keyboardフックポインタ
    let mutable private k_hook = IntPtr.Zero
    /// Mouseフックポインタ
    let mutable private m_hook = IntPtr.Zero
    /// キーマウス情報
    let private _args = new KeyMouseEventArgs()
    /// キーマウスイベント
    let private _keymouseEvent = new Event<KeyMouseEventArgs>()
    /// キーマウスイベント
    let KeyMouseEvent = _keymouseEvent.Publish

//#region キーボード＆マウスのグローバルフックのイベント前処理
    /// フックフィルターを取得または設定する。
    let mutable Filter : HookFilterEvent option = None
    /// フィルターからフックイベントを発行するかを判断する。（無駄が多いかも？）
    let private checkFilter() =
        let _wintext = WindowsAPI.GetForegroundWindowText()
        let _process = WindowsAPI.GetForegroundProcess()
        let _rocessname = _process.ProcessName
        Debug.WriteLine <| sprintf "WindowText: %s" _wintext
        Debug.WriteLine <| sprintf "ProcessName: %s" _rocessname
        Debug.WriteLine <| sprintf "Process: %A" _process
        if Filter.IsSome then
            let list = Filter.Value.Invoke()
            list |> List.exists(fun x ->
                match x with
                | HookFilter.ProcessName x -> _rocessname = x
                | HookFilter.WindowTitle x -> _wintext = x
            )
        else
            true
    /// フックイベントを発行する。
    let private onKeyboardMouseHookEvent (kmt:KeyMouseType) =
        _args.Wheel <- MouseWheel.None
        match kmt with
        | AddKey (v,s) ->
            _args.AddKey v
            _args.ScanCode <- s
        | DelKey (v,s) ->
            _args.DelKey v
            _args.ScanCode <- s
        | AddMouse v -> _args.AddMouse v
        | DelMouse v -> _args.DelMouse v
        | Wheel v -> _args.Wheel <- v
        if checkFilter() then
            _keymouseEvent.Trigger _args
//#endregion

///#region キーボードフック関連
    ///キーボードフックのコールバック関数
    let private KeyboardHookProc nCode (wParam:nativeint) lParam =
        if nCode = 0 then
            let key = WindowsAPI.toKBDLLHOOKSTRUCT lParam
            let msg = wParam.ToInt32()
            Debug.WriteLine <| sprintf "msg: %d" msg
            Debug.WriteLine <| sprintf "vkCode: %d" key.vkCode
            Debug.WriteLine <| sprintf "scanCode: %d" key.scanCode
            Debug.WriteLine <| sprintf "flags: %d" key.flags
            Debug.WriteLine <| new String('-', 50)
            Debug.WriteLine ""
            
            let keycode = enum<Keys> <| int key.vkCode

            // KeyDownイベントを発行
            if msg = WindowsAPI.WM_KEYDOWN || msg = WindowsAPI.WM_SYSKEYDOWN then
                onKeyboardMouseHookEvent <| KeyMouseType.AddKey (keycode, key.scanCode)
            // KeyUpイベントを発行
            if msg = WindowsAPI.WM_KEYUP || msg = WindowsAPI.WM_SYSKEYUP then
                onKeyboardMouseHookEvent <| KeyMouseType.DelKey (keycode, key.scanCode)
        WindowsAPI.CallNextHookEx(k_hook, nCode, wParam, lParam)
    let private keyboardHook = WindowsAPI.LowLevelProc(KeyboardHookProc)
///#endregion

///#region マウスフック関連
    ///マウスのコールバック関数
    let private MouseHookProc nCode (wParam:nativeint) lParam =
        if nCode = 0 then
            let mouse = WindowsAPI.toMSLLHOOKSTRUCT lParam
            let wheel = int mouse.mouseData >>> 16
            let wp = wParam.ToInt32()
            let button =
                    match wp with
                    | WindowsAPI.WM_LBUTTONDOWN
                    | WindowsAPI.WM_LBUTTONUP
                    | WindowsAPI.WM_LBUTTONDBLCLK -> MouseButtons.Left
                    | WindowsAPI.WM_RBUTTONDOWN
                    | WindowsAPI.WM_RBUTTONUP
                    | WindowsAPI.WM_RBUTTONDBLCLK -> MouseButtons.Right
                    | WindowsAPI.WM_MBUTTONDOWN
                    | WindowsAPI.WM_MBUTTONUP
                    | WindowsAPI.WM_MBUTTONDBLCLK -> MouseButtons.Middle
                    | WindowsAPI.WM_XBUTTONDOWN
                    | WindowsAPI.WM_XBUTTONUP
                    | WindowsAPI.WM_XBUTTONDBLCLK ->
                        match mouse.mouseData with
                        | 131072u -> MouseButtons.XButton1
                        | 65536u -> MouseButtons.XButton2
                        | _ -> MouseButtons.None
                    | _ -> MouseButtons.None
            match wp with
            | WindowsAPI.WM_LBUTTONDOWN
            | WindowsAPI.WM_RBUTTONDOWN
            | WindowsAPI.WM_MBUTTONDOWN
            | WindowsAPI.WM_XBUTTONDOWN ->
                Debug.WriteLine "MouseDown"
                button
                |> KeyMouseType.AddMouse
                |> onKeyboardMouseHookEvent
            | WindowsAPI.WM_LBUTTONUP
            | WindowsAPI.WM_RBUTTONUP
            | WindowsAPI.WM_MBUTTONUP
            | WindowsAPI.WM_XBUTTONUP ->
                Debug.WriteLine "MouseDown"
                button
                |> KeyMouseType.DelMouse
                |> onKeyboardMouseHookEvent
            | WindowsAPI.WM_MOUSEHWHEEL ->
                Debug.WriteLine "HWheel"
                if 0 <= wheel then MouseWheel.Rigth
                else MouseWheel.Left
                |> KeyMouseType.Wheel
                |> onKeyboardMouseHookEvent
            | WindowsAPI.WM_MOUSEWHEEL ->
                Debug.WriteLine "Wheel"
                if 0 <= wheel then MouseWheel.Top
                else MouseWheel.Bottom
                |> KeyMouseType.Wheel
                |> onKeyboardMouseHookEvent
//            | WindowsAPI.WM_LBUTTONDBLCLK
//            | WindowsAPI.WM_RBUTTONDBLCLK
//            | WindowsAPI.WM_MBUTTONDBLCLK
//            | WindowsAPI.WM_XBUTTONDBLCLK ->
            | _ -> ()
            Debug.WriteLine <| sprintf "button: %A" button
            Debug.WriteLine <| sprintf "wheel: %A" wheel
        WindowsAPI.CallNextHookEx(m_hook, nCode, wParam, lParam)
    let private mouseHook = WindowsAPI.LowLevelProc(MouseHookProc)
///#endregion

//#region キーフックを実行
    do
        let hmod = WindowsAPI.GetModule()
        k_hook <- WindowsAPI.SetWindowsHookEx(
            WindowsAPI.WH_KEYBOARD_LL,
            keyboardHook,
            hmod,
            0u)
        WindowsAPI.failwithWin32 k_hook
        m_hook <- WindowsAPI.SetWindowsHookEx(
            WindowsAPI.WH_MOUSE_LL,
            mouseHook,
            hmod,
            0u)
        WindowsAPI.failwithWin32 m_hook
        AppDomain.CurrentDomain.DomainUnload.Add(fun _ ->
            let unhook instance =
                if instance <> IntPtr.Zero then
                    WindowsAPI.UnhookWindowsHookEx instance |> ignore
            [k_hook;m_hook] |> List.iter unhook
            GC.Collect()
        )
//#endregion
