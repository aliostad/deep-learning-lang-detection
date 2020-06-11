namespace FSharp.Qualia.WPF

/// Interop module with GongSolutions.Wpf.DragDrop
module DragDrop =

    open GongSolutions.Wpf.DragDrop
    open System
    open System.Reactive.Subjects
    open System.Windows

    type DragEvent = 
        | StartDrag of IDragInfo
        | Dropped of IDropInfo
        | DragCancelled
    type DropEvent =
        | DragOver of IDropInfo
        | Drop of IDropInfo

    type DragSourceHandler() = 
        inherit DefaultDragHandler()

        let sub = new Subject<DragEvent>()
    
        override x.StartDrag(info : IDragInfo) = base.StartDrag(info); sub.OnNext(StartDrag info)
        override x.Dropped(info : IDropInfo) = base.Dropped(info); sub.OnNext(Dropped info)
        override x.DragCancelled() = base.DragCancelled(); sub.OnNext(DragCancelled)
    
        member x.Events : IObservable<DragEvent> = sub :> IObservable<DragEvent>

    type DropTargetHandler() = 
        inherit DefaultDropHandler()

        let sub = new Subject<DropEvent>()

        override x.DragOver (dropInfo:IDropInfo) =
            dropInfo.Effects <- DragDropEffects.Move
            base.DragOver dropInfo; sub.OnNext(DragOver dropInfo)
        override x.Drop (dropInfo:IDropInfo) = (*base.Drop dropInfo;*) sub.OnNext(Drop dropInfo)

        member x.Events : IObservable<DropEvent> = sub :> IObservable<DropEvent>

    let setDefaultDragHandler (o : DependencyObject) = 
        o.SetValue(DragDrop.IsDragSourceProperty, true)
        o

    let setDragHandler (handler : IDragSource) (o : DependencyObject) = 
        o.SetValue(DragDrop.IsDragSourceProperty, true)
        o.SetValue(DragDrop.DragHandlerProperty, handler)
        o

    let setDefaultDropHandler (o : DependencyObject) = 
        o.SetValue(DragDrop.IsDropTargetProperty, true)
        o

    let setDropHandler (handler : IDropTarget) (o : DependencyObject) = 
        o.SetValue(DragDrop.IsDropTargetProperty, true)
        o.SetValue(DragDrop.DropHandlerProperty, handler)
        o
