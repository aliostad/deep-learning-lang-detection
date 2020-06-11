module GameHandlers

open System
open System.Windows.Forms
open GameControl
open PhysicalObjects

type GameHandlers(f:Form) =

    member t.RestartRequired = 
        new Handler<unit>(
            fun sender eventargs ->
                f.Controls.Clear()
                let g = new GameControl(10., new ResizeArray<IGameLand>(), [| |], [| |], new ResizeArray<Bullet>())
                g.GameEnded.AddHandler(t.GameEnded)
                f.Controls.Add(g)
                g.Dock <- DockStyle.Fill
            ) 

    member t.GameEnded =
        new Handler<int*int>(
            fun sender eventargs ->
                f.Text <- "cacca."
        )
