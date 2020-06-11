namespace CQRS.EventHandlers.FSharp

open System
open System.Collections.Generic
open CQRS.EventHandlers

module Ordered = 

    let canApply (event : IEvent) (versions : IVersionProvider) = 
        versions.GetVersion (event.Revision.Id) = (event.Revision.Version - 1L)

    let handleUsing (handler : IEventHandler) (event : IEvent) = 
        handler.HandleEvent (event)
        event

    let getSuccessors (backlogs : IDictionary<Int64, IEvent list>) (event : IEvent) = 

        let rec partitionBacklog current contiguous (remaining : IEvent list) = 
            match remaining with 
            | [] -> (contiguous, remaining)
            | e::es ->
                let next = (current + 1L)
                in
                    if (e.Revision.Version <> next) then
                        (contiguous, remaining) //Break
                    else
                        partitionBacklog next (e :: contiguous) es //Continue
                
        let updateBacklog backlog =
            match backlog with
            | [] -> backlogs.Remove (event.Revision.Id) |> ignore
            | _ -> backlogs.[event.Revision.Id] <- backlog

        match (backlogs.TryGetValue event.Revision.Id) with
        | (false, _) -> []
        | (_, events) -> 

            let applicable, backlog = 
                events
                |> partitionBacklog event.Revision.Version []

            updateBacklog backlog

            applicable
            |> List.rev 

    let archive (backlogs : IDictionary<Int64, IEvent list>) (event : IEvent) = 
        
        let backlog = 
            match (backlogs.TryGetValue event.Revision.Id) with
            | (false, _) -> [ event ]                
            | (_, events) ->                
                event :: events
                |> List.sortBy (fun e -> e.Revision.Version)

        backlogs.[event.Revision.Id] <- backlog


    type Decorator<'TEntity when 'TEntity : not struct and 'TEntity :> IEntity> (wrapped : IEventHandler<'TEntity>) = 

        let backlogs = Dictionary<Int64, IEvent list> ()

        static member Decorate (wrapped) = 
            new Decorator<'TEntity> (wrapped) :> IEventHandler<'TEntity>
        
        interface IEventHandler<'TEntity> with

            member this.HandleEvent event = 
                match (canApply event wrapped.Repository) with
                | true -> 
                    let handle = (handleUsing wrapped)
                    in
                        event
                        |> handleUsing wrapped
                        |> getSuccessors backlogs
                        |> List.iter (handle >> ignore)

                | _ -> 
                    archive backlogs event

            member this.Repository 
                with get () = wrapped.Repository

            member this.Dispose () = 
                if wrapped <> null then
                    wrapped.Dispose ()

