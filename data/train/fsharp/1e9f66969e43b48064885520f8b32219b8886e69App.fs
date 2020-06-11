namespace Hink.Showcase

open Fable.Core
open Fable.Core.JsInterop
open Fable.Import
open Hink.Gui
open Hink.Inputs
open Hink.Widgets

module Main =
    // Application code
    let canvas = Browser.document.getElementById "application" :?> Browser.HTMLCanvasElement

    let mutable buttonCounter = 0
    let isChecked = ref false
    let switchValue = ref false

    #if DEBUG
    let stats = Stats()
    stats.showPanel(0.)

    Browser.document.body.appendChild stats.dom |> ignore
    #endif

    let window1 = { WindowHandler.Default with X = 10.
                                               Y = 10.
                                               Width = 400.
                                               Height = 400. }

    let window2 = { WindowHandler.Default with X = 100.
                                               Y = 50.
                                               Width = 400.
                                               Height = 285.
                                               Closable = true
                                               Closed = true
                                               Draggable = true
                                               Title = Some "You can close me" }

    let Emerald = "#2ecc71"
    let Nephritis = "#27ae60"
    let Carrot = "#e67e22"
    let Pumpkin = "#d35400"
    let Amethyst = "#9b59b6"
    let Wisteria = "#8e44ad"

    let combo1 = ComboInfo.Default

    let checkbox1 = CheckboxInfo.Default
    let input1 = { InputHandler.Default with Value = "Some text here" }
    let input2 = InputHandler.Default

    let slider1 = SliderHandler.Default

    let keyboardPreventHandler (e: Browser.KeyboardEvent) =
        let shouldPreventFromCtrl =
            if e.ctrlKey then
                match Keyboard.resolveKeyFromKey e.key with
                | Keyboard.Keys.D -> true
                | Keyboard.Keys.O -> true
                | _ -> false
            else false

        shouldPreventFromCtrl

    let keyboardCaptureHandler (keyboard: Keyboard.Record) =
        match keyboard.Modifiers with
        | { Control = true } ->
            match keyboard.LastKey with
            | Keyboard.Keys.O ->
                window2.Closed <- false
                true // Key has been captured
            | _ -> false
        | _ ->
            match keyboard.LastKey with
            | Keyboard.Keys.Escape ->
                if not window2.Closed then
                    window2.Closed <- true
                true // Key has been captured
            | _ -> false

    let ui = Hink.Create(canvas, keyboardCaptureHandler = keyboardCaptureHandler, keyboardPreventHandler = keyboardPreventHandler)

    let mutable window2BackgroundColor = ui.Theme.Window.Header.Color

    let rec render (_: float) =
        ui.ApplicationContext.clearRect(0., 0., ui.Canvas.width, ui.Canvas.height)
        ui.ApplicationContext.fillStyle <- !^"#fff"

        #if DEBUG
        stats.``begin``()
        #endif

        ui.Prepare()

        if ui.Window(window1) then
            ui.Label(sprintf "Clicked: %i times" buttonCounter, Center)
            if ui.Button("Click me") then
                buttonCounter <- buttonCounter + 1

            ui.Label("Row layout demo", Center, backgroundColor = "#34495e")

            ui.Row([|1./2.; 1./4.; 1./4.|])
            ui.Label("1/2", Center, "#f39c12")
            ui.Label("1/4", Center, "#27ae60")
            ui.Label("1/4", Center, "#8e44ad")

            ui.Label("We filled all the row, so new line here", Center, backgroundColor = "#34495e" )

            ui.Label("Text truncated because it's too long from here")

            ui.Row([|1./4.; 1./2.; 1./4.|])

            ui.Empty()
            if ui.Button("Open second Window") then
                window2.Closed <- false
            ui.Empty()

            ui.Label(sprintf "Slider: %.0f" slider1.Value)
            ui.Slider(slider1) |> ignore

            ui.Label("Use Ctrl+O to open the second Window", Center)

        if ui.Window(window2, headerColor = window2BackgroundColor) then
            ui.Label("Click to change window header", Center)
            ui.Row([|1./3.; 1./3.; 1./3.|])

            if ui.Button("Emerald", defaultColor = Emerald) then
                window2BackgroundColor <- Emerald

            if ui.Button("Amethyst", defaultColor = Amethyst) then
                window2BackgroundColor <- Amethyst

            if ui.Button("Carrot", defaultColor = Carrot) then
                window2BackgroundColor <- Carrot

            ui.Combo(combo1, ["Fable"; "Elm"; "Haxe"], Some "Default", labelAlign = Center) |> ignore

            ui.Checkbox(checkbox1, "Remember me") |> ignore

            ui.Input(input1) |> ignore

            ui.Input(input2) |> ignore

            ui.Empty()

            ui.Label("Close me by pressing Espace", Center)

        ui.Finish()

        #if DEBUG
        stats.``end``() |> ignore
        #endif

        Browser.window.requestAnimationFrame(Browser.FrameRequestCallback(render))
        |> ignore

    render 0.
