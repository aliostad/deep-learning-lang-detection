namespace EventSourcing

module CQRS =

    open System
    open System.Collections.Generic

    type T<'id,'event,'cmd when 'id : comparison> = 
        internal {
            store           : IEventStore<'id,'event>
            commandHandler  : 'cmd -> Computation.T<'id,'event, unit>
            registeredSinks : List<IDisposable>
        } 
        interface IDisposable with
            member this.Dispose() =
                this.registeredSinks |> Seq.iter (fun d -> d.Dispose())
                this.registeredSinks.Clear()
                

    let create (rep : IEventRepository<'id,'event>) (cmdHandler : 'cmd -> Computation.T<'id,'event, unit>) =
        let store = EventStore.fromRepository rep
        { store           = store
          commandHandler  = cmdHandler
          registeredSinks = List<IDisposable>()
        }

    let subscribe (handler : EventObservable.EventHandler<'id,'event>) (model : T<'id,'event,'cmd>) : IDisposable = 
        model.store.subscribe handler

    let execute (cmd : 'cmd) (model : T<'id,'event,'cmd>) =
        let comp = model.commandHandler cmd
        model.store.run comp

    let restore (pr : Projection.T<'event,_,'a>) (eId : 'id) (model : T<'id,'event,_>) : 'a =
        model.store |> EventStore.restore pr eId
    
    let registerReadmodel
        (rm : ReadModel.T<'key,'id,'event,'state,'result>)
        (model : T<'id,'event,_>) 
        : IDisposable = 
        model |> subscribe (ReadModel.eventHandler rm)

    let registerReadModelSink 
        (update : IEventStore<'id,'event> -> ('id * 'event) -> unit) 
        (model : T<'id,'event,_>) 
        : IDisposable =
        let unsubscribe =
            model
            |> subscribe (fun (entityId, event) ->
                update model.store (entityId, event))
        model.registeredSinks.Add unsubscribe
        { new IDisposable with 
            member __.Dispose() = 
                model.registeredSinks.Remove(unsubscribe) |> ignore
                unsubscribe.Dispose()
        }


