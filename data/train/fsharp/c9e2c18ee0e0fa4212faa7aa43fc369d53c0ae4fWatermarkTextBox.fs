namespace DI.FM.WPF

open System.Windows
open System.Windows.Controls
open System.Diagnostics.CodeAnalysis

// Translated from C# http://prabu-guru.blogspot.in/2010/06/how-to-add-watermark-text-to-textbox.html
type WaterMarkTextHelper() =
    inherit DependencyObject()

    static let monitoringChanged (o: DependencyObject) (a: DependencyPropertyChangedEventArgs) =
        let shouldSubscribe = a.NewValue :?> bool
        let textChangedHandler (sender: obj) args =
            match sender with
            | null -> ()
            | :? TextBox as tb -> WaterMarkTextHelper.SetTextLength(tb, tb.Text.Length)
            | _ -> ()
        let passChangedHandler (sender: obj) args =
            match sender with
            | null -> ()
            | :? PasswordBox as pb -> WaterMarkTextHelper.SetTextLength(pb, pb.Password.Length)
            | _ -> ()
        match o with
        | :? TextBox as tb -> 
            textChangedHandler |> if shouldSubscribe 
                                    then tb.TextChanged.AddHandler
                                    else tb.TextChanged.RemoveHandler
        | :? PasswordBox as pb -> 
            passChangedHandler |> if shouldSubscribe 
                                    then pb.PasswordChanged.AddHandler
                                    else pb.PasswordChanged.RemoveHandler
        | _ -> ()

    [<SuppressMessage("NameConventions", "NonPublicValuesCamelCase")>]
    static let IsMonitoringProperty: DependencyProperty =
        DependencyProperty.RegisterAttached(
            "IsMonitoring",
             typeof<bool>,
             typeof<WaterMarkTextHelper>,
             new UIPropertyMetadata(false, new PropertyChangedCallback(monitoringChanged)))
    [<SuppressMessage("NameConventions", "NonPublicValuesCamelCase")>]
    static let WatermarkTextProperty: DependencyProperty =
        DependencyProperty.RegisterAttached(
            "WatermarkText",
            typeof<string>,
            typeof<WaterMarkTextHelper>,
            new UIPropertyMetadata(""))
    [<SuppressMessage("NameConventions", "NonPublicValuesCamelCase")>]
    static let TextLengthProperty: DependencyProperty =
        DependencyProperty.RegisterAttached(
            "TextLength",
            typeof<int>,
            typeof<WaterMarkTextHelper>,
            new UIPropertyMetadata(0))
    [<SuppressMessage("NameConventions", "NonPublicValuesCamelCase")>]
    static let HasTextProperty: DependencyProperty =
        DependencyProperty.RegisterAttached(
            "HasText",
            typeof<bool>,
            typeof<WaterMarkTextHelper>,
            new FrameworkPropertyMetadata(false))

    static member GetIsMonitoring (obj: DependencyObject) =
        obj.GetValue(IsMonitoringProperty) :?> bool
    static member SetIsMonitoring (obj: DependencyObject, value: bool) =
        obj.SetValue(IsMonitoringProperty, value)

    static member GetWatermarkText (obj: DependencyObject) =
        obj.GetValue(WatermarkTextProperty) :?> string
    static member SetWatermarkText (obj: DependencyObject, value: string) =
        obj.SetValue(WatermarkTextProperty, value)

    static member GetTextLength (obj: DependencyObject) =
        obj.GetValue(TextLengthProperty) :?> int
    static member SetTextLength (obj: DependencyObject, value: int) =
        obj.SetValue(TextLengthProperty, value)
        obj.SetValue(HasTextProperty, value >= 1);

    member x.HasText
        with get() = x.GetValue(HasTextProperty) :?> bool
        and set(value: bool) = x.SetValue(HasTextProperty, value)