module Gui
    open System.Windows
    open System.Windows.Controls
    open System.Windows.Media

    let LIGHT_GREY = new SolidColorBrush( Color.FromRgb (192uy, 192uy,192uy) )
    let RED = new SolidColorBrush( Color.FromRgb (255uy, 0uy, 0uy) )
    let LIME = new SolidColorBrush( Color.FromRgb (0uy, 255uy, 0uy) )

    let fillRectWith (rect: obj) color =
        try
            let r = rect :?> System.Windows.Shapes.Rectangle
            r.Fill <- color
        with 
        | ex -> ex.ToString() |> System.Windows.MessageBox.Show |> ignore

    let addButtonHandler (button: Button) (f: obj -> RoutedEventArgs -> unit) =
        try
            button.Click.AddHandler(new RoutedEventHandler( f ) )
        with
        | ex -> ex.ToString() |> System.Windows.MessageBox.Show |> ignore
