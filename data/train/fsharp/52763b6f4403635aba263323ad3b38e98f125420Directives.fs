namespace WpfFs.Directives

open System
open System.Windows
open System.Diagnostics
open FSharp.Core.Printf
open RZ.Foundation

type Ng() =
    static let onMouseRightButtonDown _ (e: Input.MouseButtonEventArgs) =
        kprintf Debug.Print "Source = %A, OriginalSource = %A @ %A" (e.Source.GetType().Name) (e.OriginalSource.GetType().Name) (e.Timestamp)

        e.Source
          |> tryCast<Controls.Control>
          |> Option.do' (fun source ->
                if source.BorderThickness <> Thickness(5.0) then
                    source.BorderThickness <- Thickness(5.0)
                    source.BorderBrush <- Media.Brushes.Black
                else
                    source.BorderThickness <- Thickness(0.0)
             )

    static member SetBlockMark(el: DependencyObject, value: bool) =
        el
          |> tryCast<UIElement>
          |> Option.do' (fun ui ->
               if value then
                 ui.AddHandler(UIElement.MouseRightButtonDownEvent, Input.MouseButtonEventHandler(onMouseRightButtonDown), true)
               else
                 ui.RemoveHandler(UIElement.MouseRightButtonDownEvent, Input.MouseButtonEventHandler(onMouseRightButtonDown))
             )