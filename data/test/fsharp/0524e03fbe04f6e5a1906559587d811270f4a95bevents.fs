namespace Pit

    module JsCommon =
        open Pit.JavaScript

        //let CallLambda fs index arg1 arg2 = ()
        let invokeEvent (evts:JsArray<obj>) (index:int) arg1 arg2 = ()

        let attachHandler name el func = ()

        let detachHandler name el func = ()

namespace Pit.FSharp.Control
open System
open Pit
open Pit.JsCommon
open Pit.JavaScript

    [<AutoOpen>]
    module CommonExtensions =

        type BasicObserver<'T> [<Js>](f: 'T -> unit) =
            interface IObserver<'T> with
                [<Js>]
                member this.OnNext(args) = f args
                [<Js>]
                member this.OnError(e)   = ()
                [<Js>]
                member this.OnCompleted() = ()

        type IObservable<'Args> with

            [<CompiledName("AddToObservable")>]
            [<Js>]
            member x.Add(f: 'Args -> unit) = x.Subscribe f |> ignore

            [<CompiledName("SubscribeToObservable")>]
            [<Js>]
            member x.Subscribe(f) =
                x.Subscribe (new BasicObserver<_>(f))

    type BasicDisposable [<Js>](f: unit -> unit) =
        interface IDisposable with
            [<Js>]
            member this.Dispose() =
                f()

    type EventPublish2<'Delegate,'Args when 'Delegate : delegate<'Args,unit> and 'Delegate :> System.Delegate > [<Js>](eventFuncs: JsArray<obj>) =

        interface IEvent<'Delegate, 'Args>
        interface IDelegateEvent<'Delegate> with
            [<Js>]
            member this.AddHandler(d) =
                eventFuncs.Push(d)

            [<Js>]
            member this.RemoveHandler(d) =
                eventFuncs.Remove(d)

        interface IObservable<'Args> with
            [<Js>]
            member this.Subscribe(observer) =
                let h = new Handler<_>(fun sender args -> observer.OnNext(args))
                eventFuncs.Push(h)
                new BasicDisposable((fun _ -> eventFuncs.Remove(h))) :> IDisposable

    type EventPublish<'T> [<Js>](eventFuncs: JsArray<obj>) =

        interface IEvent<'T>
        interface IDelegateEvent<Handler<'T>> with
            [<Js>]
            member this.AddHandler(d) =
                eventFuncs.Push(d)

            [<Js>]
            member this.RemoveHandler(d) =
                eventFuncs.Remove(d)

        interface IObservable<'T> with
            [<Js>]
            member this.Subscribe(observer) =
                let h = new Handler<_>(fun sender args -> observer.OnNext(args))
                eventFuncs.Push(h)
                new BasicDisposable((fun _ -> eventFuncs.Remove(h))) :> IDisposable

    type UIHandler<'T> =  delegate of args:'T -> unit

    type UIEventPublish<'T> [<Js>](evtName: string, el) =

        interface IEvent<'T>
        interface IDelegateEvent<Handler<'T>> with
            [<Js>]
            [<JsIgnore(IgnoreTuple=true)>]
            member this.AddHandler(d) =
                attachHandler evtName el d

            [<Js>]
            [<JsIgnore(IgnoreTuple=true)>]
            member this.RemoveHandler(d) =
                detachHandler evtName el d

        interface IObservable<'T> with
            [<Js>]
            [<JsIgnore(IgnoreTuple=true)>]
            member this.Subscribe(observer) =
                let h = new UIHandler<_>(fun args -> observer.OnNext(args))
                attachHandler evtName el h
                new BasicDisposable(fun _ -> detachHandler evtName el h) :> IDisposable

    type UIEvent<'T> [<Js>](evtName:string, el) =

        [<Js>]
        member this.Publish =
            new UIEventPublish<'T>(evtName, el) :> IEvent<'T>

    [<CompiledName("FSharpEvent`2")>]
    type Event<'Delegate,'Args when 'Delegate : delegate<'Args,unit> and 'Delegate :> System.Delegate > [<Js>]() =
        let mutable eventFuncs = new JsArray<obj>([||])

        [<Js>]
        [<JsIgnore(IgnoreTuple=true)>]
        member this.Trigger(sender:obj, args:'T) =
            for i=0 to eventFuncs.Length-1 do
                invokeEvent eventFuncs i sender args

        [<Js>]
        member this.Publish =
            new EventPublish2<'Delegate, 'Args>(eventFuncs) :> IEvent<'Delegate, 'Args>

    [<CompiledName("FSharpEvent`1")>]
    type Event<'T> [<Js>]() =
        let mutable eventFuncs = new JsArray<obj>([||])

        [<Js>]
        [<JsIgnore(IgnoreTuple=true)>]
        member this.Trigger(args:'T) =
            for i=0 to eventFuncs.Length-1 do
                invokeEvent eventFuncs i null args

        [<Js>]
        member this.Publish =
            new EventPublish<'T>(eventFuncs) :> IEvent<'T>

    module EventModule =

        [<CompiledName("Create")>]
        [<Js>]
        let create<'T>() =
            let ev = new Event<'T>()
            ev.Trigger, ev.Publish

        [<CompiledName("Map")>]
        [<Js>]
        let map f (w: IEvent<'Delegate,'T>) =
            let ev = new Event<_>()
            w.Add(fun x -> ev.Trigger(f x));
            ev.Publish

        [<CompiledName("Filter")>]
        [<Js>]
        let filter f (w: IEvent<'Delegate,'T>) =
            let ev = new Event<_>()
            w.Add(fun x -> if f x then ev.Trigger x);
            ev.Publish

        [<CompiledName("Partition")>]
        [<Js>]
        let partition f (w: IEvent<'Delegate,'T>) =
            let ev1 = new Event<_>()
            let ev2 = new Event<_>()
            w.Add(fun x -> if f x then ev1.Trigger x else ev2.Trigger x);
            ev1.Publish,ev2.Publish

        [<CompiledName("Choose")>]
        [<Js>]
        let choose f (w: IEvent<'Delegate,'T>) =
            let ev = new Event<_>()
            w.Add(fun x -> match f x with None -> () | Some r -> ev.Trigger r);
            ev.Publish

        [<CompiledName("Scan")>]
        [<Js>]
        let scan f z (w: IEvent<'Delegate,'T>) =
            let state = ref z
            let ev = new Event<_>()
            w.Add(fun msg ->
                 let z = !state
                 let z = f z msg
                 state := z;
                 ev.Trigger(z));
            ev.Publish

        [<CompiledName("Add")>]
        [<Js>]
        let add f (w: IEvent<'Delegate,'T>) = w.Add(f)

        [<CompiledName("Pairwise")>]
        [<Js>]
        let pairwise (inp : IEvent<'Delegate,'T>) : IEvent<'T * 'T> =
            let ev = new Event<'T * 'T>()
            let lastArgs = ref None
            inp.Add(fun args2 ->
                (match !lastArgs with
                 | None -> ()
                 | Some args1 -> ev.Trigger(args1, args2));
                lastArgs := Some args2);

            ev.Publish

        [<CompiledName("Merge")>]
        [<Js>]
        let merge (w1: IEvent<'Del1,'T>) (w2: IEvent<'Del2,'T>) =
            let ev = new Event<_>()
            w1.Add(fun x -> ev.Trigger(x));
            w2.Add(fun x -> ev.Trigger(x));
            ev.Publish

        [<CompiledName("Split")>]
        [<Js>]
        let split (f : 'T -> Choice<'U1,'U2>) (w: IEvent<'Delegate,'T>) =
            let ev1 = new Event<_>()
            let ev2 = new Event<_>()
            w.Add(fun x -> match f x with Choice1Of2 y -> ev1.Trigger(y) | Choice2Of2 z -> ev2.Trigger(z));
            ev1.Publish,ev2.Publish