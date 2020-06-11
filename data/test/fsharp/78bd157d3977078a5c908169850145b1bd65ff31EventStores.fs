
namespace EventSourcing

open EventObservable

/// a eventstore should provide
/// methods to run computations
/// and check if a entity exists
type IEventStore<'id, 'event when 'id : comparison> =
    inherit System.IDisposable
    abstract run       : Computation.T<'id,'event,'a> -> 'a
    abstract subscribe : EventHandler<'id,'event> -> System.IDisposable

module EventStore =

    /// subscribes an event-handler (for a certain event-type) to the event-store
    let subscribe (h : EventHandler<'id,'event>) (es : IEventStore<'id,'event>) : System.IDisposable =
        es.subscribe h

    /// adds an event for a entity into the store
    let add (id : 'id) (e : 'event) (es : IEventStore<'id,'event>) =
        Computation.add id e
        |> es.run

    /// restores data from a eventstore for a given entity-id using a projection
    let restore (p : Projection.T<'event,_,'a>) (id : 'id) (es : IEventStore<'id,'event>) : 'a =
        Computation.restore p id
        |> es.run

    /// reads from a read-model
    let allIds (es : IEventStore<'id,_>) : 'id seq =
        Computation.allIds() |> es.run

    /// executes a store-computation using the given repository
    /// and it's transaction support
    /// Note: it will reraise any internal error but will not rollback
    /// if the errors where caused by EventHandlers (so the events will
    /// still be saved if there where errors in any EventHandler)
    let private executeComp (rep : IEventRepository<'id,'event>) (comp : Computation.T<'id,'event,'a>) : 'a =
        use trans = rep.beginTransaction ()
        try
            let res = comp |> Computation.run rep trans
            rep.commit trans
            res
        with
        | :? HandlerException ->
            // don't rollback on Handler-Exceptions
            reraise()
        | _ as ex ->
            System.Diagnostics.Debug.WriteLine(ex.Message)
            rep.rollback trans
            reraise()

    /// creates an event-store from a repository
    let fromRepository (rep : IEventRepository<'id,'event>) : IEventStore<'id,'event> =
        let eventObs = EventObservable.create ()
        let rep' = EventObservable.wrap rep eventObs
        { new IEventStore<'id,'event> with
            member __.Dispose()   = rep.Dispose()
            member __.run p       = executeComp rep' p
            member __.subscribe h = eventObs.addHandler h
        }

    /// executes an store-computation using an event-store
    let execute (es : IEventStore<'id,'event>) (comp : Computation.T<'id,'event,'a>) =
        es.run comp

    /// registers a readmodel
    let registerReadmodel 
        (es : IEventStore<'id,'event>) 
        (rm : ReadModel.T<'key,'id,'event,'state,_>) =
        es.subscribe (ReadModel.eventHandler rm)