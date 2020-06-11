namespace CQRS.EventHandlers.FSharp

open System
open System.Collections.Concurrent
open System.Threading
open System.Threading.Tasks
open CQRS.EventHandlers
open CQRS.EventHandlers.FSharp.Helpers

module Concurrent = 

    type Decorator<'TEntity when 'TEntity : not struct and 'TEntity :> IEntity> (wrapped : IEventHandler<'TEntity>) = 

        let events = new BlockingCollection<IEvent> ()
        let cancel = new CancellationTokenSource ()
        let mutable disposed = false

        let run = 
            async { 
                while (not disposed) do
                    match (Collections.take events) with
                    | Some e -> wrapped.HandleEvent e
                    | _ -> ()
            }

        do 
            run
            |> Tasks.start cancel.Token
            |> ignore
            
        static member Decorate (wrapped) = 
            new Decorator<'TEntity> (wrapped) :> IEventHandler<'TEntity>
        
        interface IEventHandler<'TEntity> with

            member this.HandleEvent event = 
                events.Add event

            member this.Repository 
                with get () = wrapped.Repository

            member this.Dispose () = 
                if (not disposed) then

                    disposed <- true

                    cancel.Cancel ()
                    cancel.Dispose ()

                    events.Dispose ()

                    if (wrapped <> null) then
                        wrapped.Dispose ()