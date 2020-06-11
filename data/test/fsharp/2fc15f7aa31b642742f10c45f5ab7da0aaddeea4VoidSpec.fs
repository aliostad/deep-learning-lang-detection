namespace Void.Spec

open Void
open Void.Core
open Void.ViewModel
open NUnit.Framework
open FsUnit

type InputModeChangerStub() =
    let mutable _inputHandler = InputMode<unit>.KeyPresses (fun _ -> ())
    member x.getInputHandler() =
        _inputHandler
    interface InputModeChanger with
        member x.SetInputHandler inputMode =
            _inputHandler <- inputMode

[<TestFixture>]
type ``Void``() = 
    [<Test>]
    member x.``When I have freshly opened Vim with one window, when I enter the quit command, then the editor exists``() =
        let inputModeChanger = InputModeChangerStub()
        let bus = Init.buildVoid inputModeChanger Options.defaults
        Init.launchVoid bus
        let closed = ref false
        let closeHandler event =
            match event with
            | CoreEvent.LastWindowClosed ->
                closed := true
            | _ -> ()
            noMessage
        bus.subscribe closeHandler

        match inputModeChanger.getInputHandler() with
        | InputMode.KeyPresses handler ->
            handler KeyPress.Semicolon
        | InputMode.TextAndHotKeys _ ->
            Assert.Fail "Right after startup did not have a key presses handler set"

        match inputModeChanger.getInputHandler() with
        | InputMode.KeyPresses _ ->
            Assert.Fail "After typing ; did not have text and hotkeys handler set"
        | InputMode.TextAndHotKeys handler ->
            TextOrHotKey.Text "q" |> handler
            TextOrHotKey.HotKey HotKey.Enter |> handler

        (* Remeber that ! is dereference, not negate, in F# *)
        !closed |> should be True
