namespace Pit.Dom

open System
open System.Windows.Browser
open Pit
open Utils

type HtmlEventArgs = System.Windows.Browser.HtmlEventArgs

[<AbstractClass>]
[<AllowNullLiteral>]
type DomObject(scriptObject : ScriptObject) =

    /// To be used only for browser invocations by libraries, this will not compile to JS.
    member x.InternalScriptObject
        with get() = scriptObject

    member x.AttachEvent(evtName : string, handler : EventHandler) =
        match scriptObject with
        | :? HtmlObject ->
            let htmlObj = scriptObject :?> HtmlObject
            htmlObj.AttachEvent(evtName, handler) |> ignore
        | _ -> ()

    member x.DetachEvent(evtName : string, handler : EventHandler) =
        match scriptObject with
        | :? HtmlObject ->
            let htmlObj = scriptObject :?> HtmlObject
            htmlObj.DetachEvent(evtName, handler) |> ignore
        | _ -> ()
