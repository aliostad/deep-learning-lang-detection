
#r "System.Windows.dll"
#r "PresentationFramework.dll"
#r "PresentationCore.dll"
#r "WindowsBase.dll"
#r "System.Xaml.dll"


open System.Windows
open System.Windows.Controls
open System.Windows.Media
open System.Windows.Input


let createEnvironment() =
    let window = Window(Width = 1000., Height = 800.)
    let canvas = Canvas()
    canvas.Background <- Brushes.Black
    window.Content <- canvas
    window.Show()

    window, canvas

let window, canvas = createEnvironment()
window.SizeChanged.AddHandler <| SizeChangedEventHandler (fun sender e ->
                                    let window = sender :?> Window
                                    let panel = window.Content :?> Panel
                                    panel.Height <- window.Height
                                    panel.Width <- window.Width)

type DragDrop =
    {
        mutable MouseCaptured : bool
        mutable CanvasPosition : float * float
        mutable ControlPosition : float * float    
        mutable Source : UIElement
    }

let dragDrop = { MouseCaptured = false; CanvasPosition = 0., 0.; ControlPosition = 0., 0.; Source = null }


let mouseDown (sender : obj) (e : MouseButtonEventArgs) =
    dragDrop.Source <- sender :?> UIElement
    dragDrop.Source |> Mouse.Capture |> ignore
    dragDrop.MouseCaptured <- true
    dragDrop.ControlPosition <- Canvas.GetLeft dragDrop.Source, Canvas.GetTop dragDrop.Source
    dragDrop.CanvasPosition <- e.GetPosition(canvas).X, e.GetPosition(canvas).Y

let mouseMove (sender : obj) (e: MouseEventArgs) =
    if dragDrop.MouseCaptured then
        let x, y = e.GetPosition(canvas).X, e.GetPosition(canvas).Y
        
        let controlX, controlY = dragDrop.ControlPosition
        let canvasX, canvasY = dragDrop.CanvasPosition
        let newControlX, newControlY = controlX + x - canvasX, controlY + y - canvasY

        Canvas.SetLeft(dragDrop.Source, newControlX)
        Canvas.SetTop(dragDrop.Source, newControlY)
        
        dragDrop.ControlPosition <- newControlX, newControlY
        dragDrop.CanvasPosition <- x, y

let mouseUp (sender : obj) (e : MouseButtonEventArgs) =
    Mouse.Capture null |> ignore
    dragDrop.MouseCaptured <- false


let makeDraggable (control : UIElement) =
    control.MouseLeftButtonDown.AddHandler <| MouseButtonEventHandler mouseDown
    control.MouseMove.AddHandler <| MouseEventHandler mouseMove
    control.MouseLeftButtonUp.AddHandler <| MouseButtonEventHandler mouseUp
