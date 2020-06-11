module XamlBuilders

open System
open System.Windows
open System.Windows.Input
open System.Windows.Controls
open System.Windows.Controls.Primitives

type FrameworkElement with
    member x.Yield (a: 'a) = x

    [<CustomOperation("onLoaded")>]
    member inline __.OnLoaded (fe: ^T :> FrameworkElement, handler: ^T -> RoutedEventArgs -> ^R) =
        fe.Loaded.Add(fun e -> handler fe e |> ignore)
        fe

type UIElement with
    member x.Yield (a: 'a) = x

    [<CustomOperation("onKeyDown")>]
    member inline __.OnKeyDown (uie: ^T :> UIElement, handler: ^T -> KeyEventArgs -> ^R) =
        uie.KeyDown.Add(fun e -> handler uie e |> ignore)
        uie

type DependencyObject with
    member x.Yield (item: 'a) = x

    [<CustomOperation("set")>]
    member __.SetDependentProperties (depObj: 'T :> DependencyObject, props: seq<DependencyProperty * #obj>) =
        for t in props do 
            match t with 
            | (prop, value) -> depObj.SetValue(prop, value)
        depObj

type Panel with
    member x.Yield (item: 'a) = x

    [<CustomOperation("children")>]
    member __.AddChildren (panel: 'T :> Panel, children: seq<UIElement>) =
        for child in children do panel.Children.Add(child) |> ignore
        panel

type Grid with
    member x.Yield (item: 'a) = x

    [<CustomOperation("rows")>]
    member __.AddRowDefinition (grid: Grid, rows: seq<RowDefinition>) = 
        for row in rows do grid.RowDefinitions.Add(row)
        grid

    [<CustomOperation("columns")>]
    member __.AddColumnDefinition (grid: Grid, cols: seq<ColumnDefinition>) = 
        for col in cols do grid.ColumnDefinitions.Add(col)
        grid

type TextBox with
    member x.Yield (item: 'a) = x

type CheckBox with
    member x.Yield (a: 'a) = x

type ButtonBase with
    member x.Yield (a: 'a) = x

    [<CustomOperation("onClick")>]
    member inline __.OnClick (c: ^T :> ButtonBase, handler: ^T -> RoutedEventArgs -> ^R) =
        c.Click.Add(fun e -> handler c e |> ignore)
        c

type ScrollViewer with
    member x.Yield (a: 'a) = x

    [<CustomOperation("onScrollChanged")>]
    member inline __.OnScrollChanged (c: ^T :> ScrollViewer, handler: ^T -> ScrollChangedEventArgs -> ^R) =
        c.ScrollChanged.Add(fun e -> handler c e |> ignore)
        c