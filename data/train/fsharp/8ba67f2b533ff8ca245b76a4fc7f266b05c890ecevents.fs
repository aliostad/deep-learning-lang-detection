namespace Pit.FSharp.Control
open System
open Pit
open System.Windows.Browser

    type UIEvent(evtName:string, htmlObj:HtmlObject) as this =
        let mutable multicast : Handler<HtmlEventArgs> option = None
        let eH = new EventHandler<HtmlEventArgs>(fun s e -> this.Trigger(e) )

        member x.Delegate
                 with get () =  match multicast with None -> null | Some(d) -> (d :> System.Delegate)
                 and  set v =  multicast <- (match v with null -> None | d -> Some d)
        member internal x.Trigger(arg:HtmlEventArgs) =
            match multicast with
            | None -> ()
            | Some d -> d.Invoke(null, arg) |> ignore
        member x.Publish =
            // Note, we implement each interface explicitly to workaround a WP7 bug
            { new obj() with
                  member x.ToString() = evtName
              interface IEvent<HtmlEventArgs>
              interface IDelegateEvent<Handler<HtmlEventArgs>> with
                member e.AddHandler(d) =
                    x.Delegate <- (System.Delegate.Combine(x.Delegate, d) :?> Handler<HtmlEventArgs>)
                    htmlObj.AttachEvent(evtName, eH) |> ignore

                member e.RemoveHandler(d) =
                    x.Delegate <- (System.Delegate.Remove(x.Delegate, d) :?> Handler<HtmlEventArgs>)
                    htmlObj.DetachEvent(evtName, eH) |> ignore

              interface System.IObservable<HtmlEventArgs> with
                member e.Subscribe(observer) =
                   let h = new Handler<_>(fun sender args -> observer.OnNext(args))
                   (e :?> IEvent<_,_>).AddHandler(h)
                   { new System.IDisposable with
                        member x.Dispose() = (e :?> IEvent<_,_>).RemoveHandler(h) } }
