module BricksUIRuntime

open Bricks
open BricksHost
open BricksUI
open BricksUIOpenTK
open System.Windows
open System.Linq
open OpenTK

let run (application:Application brick) = 

    let windows = application |> Value.map (fun app -> app.windows)

    let host = ProgramHost<_>()

    let createWindow w = new _Window(w, host)
    let updateWindow (_w:_Window) w = _w.update w
    let destroyWindow (_w:_Window) = _w.Dispose()

    let systemWindows = 
        windows
        |> BSet.track
        |> BSet.map (Value.manage createWindow updateWindow destroyWindow)
        |> BSet.materialize

    let rootBrick = brick {
        let! windows = systemWindows
        let! realized = windows
        return realized |> Seq.toList
    }

    let program = rootBrick |> toProgram

    let windows = host.run program
    if windows.Count() = 0 then () else
    let mainWindow = windows.First()
    mainWindow.Run(30.0, 0.0)

