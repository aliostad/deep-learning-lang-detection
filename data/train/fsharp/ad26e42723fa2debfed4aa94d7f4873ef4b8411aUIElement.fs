namespace rookboom.WPFSharp

open System.Windows.Controls
open System.Windows.Input
open System.Windows

type EmptyUIElement() =
    inherit UIElement()
    member m.Dummmy() = ()

[<AutoOpen>]
module UIElement =
    let withVisibility v (e:#UIElement) = e.Visibility <- v;e
    let including (prop:DependencyProperty) value (e:#UIElement)=
        e.SetValue(prop, value)
        e
    let withRenderTransform rt (e:#UIElement)  = e.RenderTransform <- rt;e
    let withRenderTransformOrigin(x,y) (e:#UIElement)  = e.RenderTransformOrigin <- Point(x,y);e
    let withLeft v ui = Canvas.SetLeft(ui, v);ui
    let withTop v ui = Canvas.SetTop(ui, v);ui
    let withRight v ui = Canvas.SetRight(ui, v);ui
    let withBottom v ui = Canvas.SetBottom(ui, v);ui
    let dockTop ui = DockPanel.SetDock(ui, Dock.Top);ui
    let dockLeft ui = DockPanel.SetDock(ui, Dock.Left);ui
    let dockRight ui = DockPanel.SetDock(ui, Dock.Right);ui
    let dockBottom ui = DockPanel.SetDock(ui, Dock.Bottom); ui
    let collapse (e:UIElement) = e.Visibility <- Visibility.Collapsed
    let onMouseEnter f (e:UIElement) =
        e.MouseEnter.Add(f)
        e
    let onMouseLeave f (e:UIElement) =
        e.MouseLeave.Add(f)
        e
    let onMouseUp f (e:UIElement) =
        e.MouseUp.Add(f)
        e
    let onMouseDown f (e:UIElement) =
        e.MouseDown.Add(f)
        e
    let onDragEnter f (e:UIElement) =
        e.DragEnter.Add(f)
        e 
    let onDragLeave f (e:UIElement) =
        e.DragLeave.Add(f)
        e
    let onKeyDown f (e:UIElement) =
        e.KeyDown.Add(f)
        e
    let onKeyUp f (e:UIElement) =
        e.KeyUp.Add(f)
        e
    let empty = EmptyUIElement()
    let handle ((re:RoutedEvent), handler) (e:#UIElement) =
        e.AddHandler(re, handler)
        e
    let onMouseRightButtonDown d (e:#UIElement) = 
        handle(Window.MouseRightButtonDownEvent, (MouseButtonEventHandler(d))) e
    let on (re:RoutedEvent) handler (e:#UIElement) =
        handle(re, (RoutedEventHandler(handler))) e
    let withInputBinding b (e:#UIElement) =
        e.InputBindings.Add(b) |> ignore
        e
    let withCommand command can executed (e:#UIElement) =
        let canExecute obj (args:CanExecuteRoutedEventArgs) = 
            args.CanExecute <- can obj args

        e.CommandBindings.Add(
            CommandBinding(
                command, 
                ExecutedRoutedEventHandler(executed), 
                CanExecuteRoutedEventHandler(canExecute))) |> ignore
        e
