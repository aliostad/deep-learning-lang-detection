#if INTERACTIVE
#r "PresentationCore.dll"
#r "PresentationFramework.dll"
#r "System.Xaml.dll"
#r "WindowsBase.dll"
#r "UIAutomationTypes.dll"
#endif

open Microsoft.Win32
open System
open System.IO
open System.Text
open System.Diagnostics
open System.ComponentModel
open System.Windows
open System.Windows.Input
open System.Windows.Controls
open System.Windows.Controls.Primitives
open System.Windows.Media
open System.Windows.Media.Imaging
open System.Windows.Shapes
open System.Windows.Documents
open System.Windows.Threading

[<STAThreadAttribute>]
try 
    let win = Window()
    win.Show()
    win.Title <- "Examine Routed Events"

    let fontFam = "Lucida Console" |> FontFamily
    let strFormat = "{0,-30} {1,-15} {2,-15} {3,-15}"

    let grid = Grid()
    win.Content <- grid

    [|GridLength.Auto;GridLength.Auto;GridLength(100.0,GridUnitType.Star)|]
    |> Array.iter(fun x ->
        let rowdef = RowDefinition()
        rowdef.Height <- x
        grid.RowDefinitions.Add rowdef
        )

    let btn = Button()
    btn.HorizontalAlignment <- HorizontalAlignment.Center
    btn.Margin <- Thickness 24.0
    btn.Padding <- Thickness 24.0
    grid.Children.Add btn |> ignore

    let text = TextBlock()
    text.FontSize <- 24.0
    text.Text <- win.Title
    btn.Content <- text

    let textHeadings = TextBlock()
    textHeadings.FontFamily <- fontFam
    textHeadings.Inlines.Add(
        String.Format(strFormat,
            "Routed Event", "sender", "Source", "OriginalSource")
            |> Run |> Underline)
    grid.Children.Add textHeadings |> ignore
    Grid.SetRow(textHeadings,1)

    let scroll = ScrollViewer()
    grid.Children.Add scroll |> ignore
    Grid.SetRow(scroll,2)

    let stackOutput = StackPanel()
    scroll.Content <- stackOutput

    let allPurposeEventHandler =
        let mutable dtLast = DateTime.Now
        fun (sender: obj) (args: RoutedEventArgs) ->
            let dtNow = DateTime.Now
            if dtNow - dtLast > TimeSpan.FromMilliseconds(100.0) then
                stackOutput.Children.Add (" " |> Run |> TextBlock) |> ignore
                dtLast <- dtNow

            let text = TextBlock()
            text.FontFamily = fontFam |> ignore
            text.Text <-
                let typeWithoutNamespace (x: obj) =
                    x.GetType().ToString().Split [|'.'|]
                    |> Array.last

                String.Format(strFormat,
                    args.RoutedEvent.Name, typeWithoutNamespace sender, 
                    typeWithoutNamespace args.Source, typeWithoutNamespace args.OriginalSource)

            stackOutput.Children.Add text |> ignore
            scroll.ScrollToBottom()
    

    ([|win;grid;btn;text|] : UIElement[])
    |> Array.iter(fun el ->
        let h = allPurposeEventHandler

        [|el.PreviewKeyUp;el.PreviewKeyDown;el.KeyDown;el.KeyUp|] |> Array.iter (fun event -> KeyEventHandler h |> event.AddHandler )
        [|el.PreviewTextInput;el.TextInput|] |> Array.iter (fun event -> TextCompositionEventHandler h |> event.AddHandler )
        [|el.MouseDown;el.MouseUp;el.PreviewMouseDown;el.PreviewMouseUp|] |> Array.iter (fun event -> MouseButtonEventHandler h |> event.AddHandler )
        [|el.StylusDown;el.PreviewStylusDown|] |> Array.iter (fun event -> StylusDownEventHandler h |> event.AddHandler )
        [|el.StylusUp;el.PreviewStylusUp|] |> Array.iter (fun event -> StylusEventHandler h |> event.AddHandler )
        el.AddHandler(Button.ClickEvent,RoutedEventHandler h)
        )


    win.Show()
    //Application().Run(win) |> ignore
with e -> MessageBox.Show(e.Message,"Exception Error") |> ignore
        

