namespace BucklingSprings.Aware.Windows

open System
open System.Windows
open System.Windows.Controls
open System.ComponentModel

open BucklingSprings.Aware.Input

type FlashMessageViewModel(message : string) as vm =
    let propertyChanged = Event<PropertyChangedEventHandler, PropertyChangedEventArgs>()
    let mutable dismissed = String.IsNullOrWhiteSpace(message)
    let dismiss () = 
        dismissed <- true
        propertyChanged.Trigger(vm, PropertyChangedEventArgs("Visibility"))
        ()
    member x.Dismiss = AlwaysExecutableCommand(dismiss)
    member x.Message = message
    member x.Visibility = if dismissed then Visibility.Collapsed else Visibility.Visible
    interface INotifyPropertyChanged with
        member this.add_PropertyChanged(handler) = propertyChanged.Publish.AddHandler(handler)
        member this.remove_PropertyChanged(handler) = propertyChanged.Publish.RemoveHandler(handler)

type FlashMessageControl() as uc =
    inherit UserControl()

    let content = Application.LoadComponent(Uri("/BucklingSprings.Aware;component/FlashMessageControl.xaml", UriKind.Relative)) :?> UserControl
    let mutable currentMessage = String.Empty
    let redraw (s : string) =
        content.DataContext <- FlashMessageViewModel(s)
    do
        uc.Content <- content
        redraw System.String.Empty

    static let FlashMessageProperty =
        DependencyProperty.Register(
                                     "FlashMessage",
                                     typeof<System.String>,
                                     typeof<FlashMessageControl>,
                                     new PropertyMetadata(
                                        System.String.Empty, new PropertyChangedCallback(FlashMessageControl.DisplayMessage)))
    static member DisplayMessage (d : DependencyObject) (e : DependencyPropertyChangedEventArgs) = 
        match d with
        | :? FlashMessageControl as fmc -> fmc.ReDraw()
        | _ -> ()
    member x.ReDraw () = 
        redraw(x.FlashMessage)
    member x.FlashMessage
        with get() = x.GetValue(FlashMessageProperty) :?> System.String
        and  set(v : System.String) = x.SetValue(FlashMessageProperty, v)
    