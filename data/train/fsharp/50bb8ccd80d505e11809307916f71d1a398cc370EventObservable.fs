namespace EventSourcing

exception HandlerException of exn

/// internal support module to wrap observable capabilities
/// around a repository - used to create EventStores from repositories
module internal EventObservable =

    open System
    open System.Collections.Generic

    type EventHandler<'id, 'event> = ('id * 'event) -> unit

    type IEventObservable<'id, 'event> =
        inherit IDisposable
        abstract addHandler : EventHandler<'id, 'event> -> IDisposable
        abstract publish    : 'id * 'event -> unit

    type private ObservableTransactionScope<'id,'event> (rep : IEventRepository<'id,'event>, obs : IEventObservable<'id,'event>) =
        let newEvents = List<_>()
        let invoke f = try f () with _ as ex -> raise (HandlerException ex)
        let transScope = rep.beginTransaction ()

        member __.addEvent (id : 'id, event : 'event) (v : EventSourcing.Version option) =
            let ver = rep.add (transScope, id, v, event)
            newEvents.Add (fun () -> obs.publish (id, event))
            ver

        member __.restore (p : Projection.T<'event,_,_>) (id : 'id) =
            rep.restore (transScope,id,p)

        member __.exists (id : 'id) =
            rep.exists (transScope, id)

        member __.allIds () =
            rep.allIds transScope

        member __.commit () =
            rep.commit transScope
            // publish new Events
            newEvents |> Seq.iter invoke
            newEvents.Clear()

        member __.rollback() =
            rep.rollback transScope
            newEvents.Clear()

        interface ITransactionScope with
            member __.Dispose() = 
                newEvents.Clear ()
                transScope.Dispose()

    let wrap (rep : IEventRepository<'id,'event>) (src : IEventObservable<'id,'event>) : IEventRepository<'id,'event> =
        let beginTrans () = new ObservableTransactionScope<'id,'event> (rep, src) :> ITransactionScope
        let call f (t : ITransactionScope) = f (t :?> ObservableTransactionScope<'id,'event>)

        { new IEventRepository<'id,'event> with 
            member __.Dispose()           = src.Dispose(); rep.Dispose()
            member __.beginTransaction () = beginTrans ()
            member __.commit t            = t |> call (fun t -> t.commit ())
            member __.rollback t          = t |> call (fun t -> t.rollback ())
            member __.exists (t,id)       = t |> call (fun t -> t.exists id)
            member __.restore (t,id,p)    = t |> call (fun t -> t.restore p id)
            member __.add (t,i,v,e)       = t |> call (fun t -> t.addEvent (i,e) v)
            member __.allIds t            = t |> call (fun t -> t.allIds ())
        }

    let create () : IEventObservable<'id,'event> =
        let handlers = List<EventHandler<'id,'event>>()
        let add (h : EventHandler<'id,'event>) : IDisposable =
            lock handlers (fun () ->
                handlers.Add h
                { new IDisposable with
                    member __.Dispose() = lock handlers (fun () -> handlers.Remove h |> ignore) 
                })
        let notify (id : 'id, event : 'event) = 
            lock handlers (fun () ->
                handlers
                |> Seq.iter (fun h -> h (id, event))
            )

        { new IEventObservable<'id, 'event> with
            member __.Dispose()      = handlers.Clear()
            member __.addHandler h   = add h
            member __.publish (id,e) = notify (id,e) }
