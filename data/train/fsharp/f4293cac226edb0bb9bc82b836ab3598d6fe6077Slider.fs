namespace Hink.Widgets

open Hink.Gui
open Fable.Core
open Fable.Core.JsInterop
open Hink.Inputs
open Hink.Helpers
open System

[<AutoOpen>]
module Slider =

    type Hink with
        member this.Slider (handler : SliderHandler, ?min, ?max, ?step) =
            if not (this.IsVisibile(this.Theme.Element.Height)) then
                this.EndElement()
                false
            else
                let slider = this.Theme.Slider
                let min = defaultArg min 0.
                let max = defaultArg max 100.
                let step = defaultArg step 10.

                let hover = this.IsHover()
                let pressed = this.IsPressed()

                let x = this.Cursor.X + slider.Padding.Horizontal
                let y = this.Cursor.Y + this.Theme.Element.Height / 2.
                let w = this.Cursor.Width - 2. * slider.Padding.Horizontal
                let pos = float (w * handler.Value / max)

                if hover then
                    this.SetCursor Mouse.Cursor.Pointer

                if pressed then
                    this.SetActiveWidget handler.Guid

                this.CurrentContext.fillStyle <- !^(Color.rgb 235 237 239)
                this.CurrentContext.RoundedRect(
                    x,
                    y,
                    w,
                    slider.Height,
                    slider.HalfHeight
                )

                this.CurrentContext.beginPath()
                this.CurrentContext.fillStyle <-
                    if this.IsActive handler.Guid then
                        !^(Color.rgb 22 160 133)
                    elif hover then
                        !^(Color.rgb 72 201 176)
                    else
                        !^(Color.rgb 26 188 156)

                this.CurrentContext.arc(
                    x + pos,
                    y + slider.HalfHeight,
                    slider.Radius,
                    0.,
                    2. * Math.PI,
                    false
                )
                this.CurrentContext.fill()
                this.CurrentContext.closePath()

                let mutable res = false

                let x = this.CursorPosX + slider.Padding.Horizontal

                if hover && pressed && this.IsActive handler.Guid then
                    let v =
                        let mousePos = Math.Clamp((this.Mouse.X - x), 0., w)
                        Math.Ceiling(
                          ((mousePos * max) / w) / step
                        ) * step
                    handler.Value <- v
                    res <- true

                if this.IsActive handler.Guid then
                    match this.Keyboard.LastKey with
                    | Keyboard.Keys.Tab ->
                        this.ActiveWidget <- None
                    | Keyboard.Keys.ArrowLeft ->
                        handler.Value <- Math.Max(handler.Value - step, min)
                        res <- true
                    | Keyboard.Keys.ArrowRight ->
                        handler.Value <- Math.Min(handler.Value + step, max)
                        res <- true
                    | _ -> ()

                this.EndElement()
                res
