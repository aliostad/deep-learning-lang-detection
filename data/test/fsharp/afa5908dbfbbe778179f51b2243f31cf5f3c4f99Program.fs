open System
open System.Drawing
open System.Windows.Forms

open Drawer

let cartoon = FCartoon.SampleClips.test9

[<EntryPoint>]
[<STAThread>]
let main argv = 
    let c = cartoon

    let w = new Form()
    w.Text <- "Cartoon test"
    w.Width <- 640 + w.Width - w.ClientSize.Width
    w.Height <- 480 + w.Height - w.ClientSize.Height

    let canvas = new PictureBox()
    canvas.Top <- 0
    canvas.Left <- 0
    canvas.Size <- w.ClientSize

    let restartButton = new Button()
    restartButton.Top <- 0
    restartButton.Left <- 0
    restartButton.Text <- "Restart"

    w.Controls.Add(restartButton)
    w.Controls.Add(canvas)

    let graphics = canvas.CreateGraphics()

    let startPlaying () =
        FCartoon.Player.play (Drawer.draw graphics) c |> Async.StartImmediate

    let onRestartClick (o:Object) (e:EventArgs) =
        Async.CancelDefaultToken()
        startPlaying()

    restartButton.Click.AddHandler(new EventHandler(onRestartClick))

    let onClosingWindow (o:Object) (e:EventArgs) =
        Async.CancelDefaultToken()

    w.Closing.AddHandler(new ComponentModel.CancelEventHandler(onClosingWindow))

    startPlaying()
    Application.Run(w)

    0 // return an integer exit code
