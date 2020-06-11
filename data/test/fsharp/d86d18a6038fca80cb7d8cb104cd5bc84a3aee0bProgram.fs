//namespace KeyInputViewr
//F# の詳細 (http://fsharp.net)

open KeyInputViewr
open KeyInputViewr.Core
open System
open System.Windows
open System.Windows.Controls

let app = new Application()
let wpf = new KeyboardMouseViewrWPF()

printfn "キーフックスタート"
// フィルターの追加
GlobalHook.Filter <-
    Some
        <| new HookFilterEvent(fun () ->
            [
                HookFilter.ProcessName "devenv"
                HookFilter.ProcessName "NiconamaCommentViewer"
                HookFilter.ProcessName "KeyInputViewr"
            ])

// イベントの追加
GlobalHook.KeyMouseEvent.Add(fun x ->
    // すべてのキーマップと押されたキーのマップをチェックして、
    // 表示 / 非表示を切り替える。
    wpf.Keys
    |> Seq.iter(fun (n,c) ->
        c.Style <- wpf.GetButtonStyle x.KeyBit.[n])
    wpf.MouseButtons
    |> Seq.iter(fun (n,c) ->
        let b = x.Mouse &&& enum<MouseButtons> n <> MouseButtons.None
        c.Visibility <- wpf.GetImageVisible b)
    if x.Wheel <> MouseWheel.None then
        wpf.MouseWhellButton.Visibility <- wpf.GetImageVisible true
    wpf.MouseWheel
    |> Seq.iter(fun (n,c) ->
        let b = x.Wheel &&& enum<MouseWheel> n <> MouseWheel.None
        c.Visibility <- wpf.GetImageVisible b)

)

#if COMPILED
[<STAThread>]
do
    app.Run(wpf.Base) |> ignore
#endif
