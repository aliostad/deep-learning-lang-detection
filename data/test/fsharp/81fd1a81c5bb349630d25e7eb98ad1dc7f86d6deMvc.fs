namespace Tamarin

open System
open System.ComponentModel
open System.Runtime.ExceptionServices
open System.Reactive.Linq
open System.Reactive.Concurrency
open System.Threading
open Xamarin.Forms

type IView<'Event, 'Model> = 
    abstract Events : IObservable<'Event> with get
    abstract SetBindings : 'Model -> unit
    abstract Navigation : INavigation

type EventHandler<'Model> = 
    | Sync of ('Model -> unit)
    | Async of ('Model -> Async<unit>)

type IController<'Event, 'Model> =
    abstract InitModel : 'Model -> unit
    abstract Dispatcher : ('Event -> EventHandler<'Model>)
    abstract Navigation : INavigation with set

[<Sealed>]
type Mvc<'Event, 'Model>(model : 'Model, view : IView<'Event, 'Model>, controller : IController<'Event, 'Model>) =

    let mutable error = fun(exn, _) -> ExceptionDispatchInfo.Capture(exn).Throw()
    
    member this.Start() =

        controller.InitModel model
        view.SetBindings model
        controller.Navigation <- view.Navigation
        
        let scheduler = SynchronizationContextScheduler(SynchronizationContext.Current, alwaysPost = false)

        view
            .Events
            .ObserveOn( scheduler)
            .Subscribe( fun event -> 
                match controller.Dispatcher event with
                | Sync eventHandler ->
                    try eventHandler model 
                    with why -> error(why, event)
                | Async eventHandler -> 
                    Async.StartWithContinuations(
                        computation = eventHandler model, 
                        continuation = ignore, 
                        exceptionContinuation = (fun why -> error(why, event)),
                        cancellationContinuation = ignore))        

    member this.Error with get() = error and set value = error <- value

    member this.Compose(childController : IController<'EX, 'MX>, childView : IView<'EX, 'MX>, childModelSelector : _ -> 'MX) = 
        let compositeView = {
            new IView<_, _> with
                member __.Events = 
                    Observable.merge (Observable.map Choice1Of2  view.Events) (Observable.map Choice2Of2 childView.Events)
                member __.SetBindings model =
                    view.SetBindings model  
                    model |> childModelSelector |> childView.SetBindings
                member __.Navigation = 
                    view.Navigation
        }

        let compositeController = { 
            new IController<_, _> with
                member __.InitModel model = 
                    controller.InitModel model
                    model |> childModelSelector |> childController.InitModel
                member __.Dispatcher = function 
                    | Choice1Of2 e -> controller.Dispatcher e
                    | Choice2Of2 e -> 
                        match childController.Dispatcher e with
                        | Sync handler -> Sync(childModelSelector >> handler)  
                        | Async handler -> Async(childModelSelector >> handler)
                member __.Navigation 
                    with set value = controller.Navigation <- value
        }

        Mvc(model, compositeView, compositeController)

    static member (<+>) (mvc : Mvc<_, _>,  (childController, childView, childModelSelector)) = 
        mvc.Compose(childController, childView, childModelSelector)

    member this.Compose(childController : IController<_, _>, events : IObservable<_>) = 
        let childView = {
            new IView<_, _> with
                member __.Events = events
                member __.SetBindings _ = () 
                member __.Navigation = raise <| NotImplementedException() 
        }
        this.Compose(childController, childView, id)

