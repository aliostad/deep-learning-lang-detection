namespace SubDyn.Presentation.Controls

open System
open System.Windows
open System.Windows.Media
open SubDyn
open SubDyn.Math
open SubDyn.Presentation

type public TopView () =
    inherit ScaleCanvas ()

    let mutable (provider : IModelDataProvider Option) = None

    member this.DataProvider
        with set value =
            let handler = Handler<unit> this.updated
            match provider with
                | None   -> ()
                | Some p -> p.Updated.RemoveHandler handler
            match box value with
                | null -> provider <- None
                | _    ->
                    provider <- Some value
                    value.Updated.AddHandler handler
            this.Redraw ()

    override this.InternalRedraw () =
        match provider with
            | Some p ->
                this.DrawGrid ()
                this.DrawTrack (p)
            | None   -> ()

    member private this.DrawTrack provider =
        let brush = SolidColorBrush (Color.FromArgb(0xFFuy, 0x00uy, 0x00uy, 0xFFuy))
        let path = Seq.map (fun (t : HistoryTrackElement) -> t.Position.XY) provider.Track
        this.DrawChain (path, brush, 1.0)
        this.DrawContour (provider.Contour, provider.Position, provider.Orientation, SolidColorBrush (Color.FromArgb (0xFFuy, 0x00uy, 0x00uy, 0xFFuy)), 2.0)

    member private this.DrawContour (contour, position, orientation, brush, lineWidth) =
        let path = Seq.map (fun (p : Vector2) -> position.XY + p.Rotate orientation.Yaw) contour
        this.DrawChain (path, brush, lineWidth)

    member private this.updated (sender : obj) () =
        if this.Dispatcher.CheckAccess ()
            then this.Redraw ()
            else Action (fun () -> this.Redraw ()) |> this.Dispatcher.BeginInvoke |> ignore
