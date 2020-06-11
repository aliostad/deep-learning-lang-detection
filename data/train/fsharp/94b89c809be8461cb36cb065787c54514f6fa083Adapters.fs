module ServiceFabricDemo.Adapters

open Microsoft.ServiceFabric.Actors
open System.Threading.Tasks

/// Represents an action which updates state.
type UpdatingAction<'TState> = 'TState -> 'TState
/// Represents an action that readonl some state to return some data.
type ReadOnlyAction<'TState, 'TOutput> = 'TState -> 'TOutput

/// Safely performs an updating action on an actor.
let doUpdate (handler:UpdatingAction<_>) (actor:StatefulActor<_>) =
    actor.State <- handler actor.State
    Task.FromResult() :> Task
/// Safely performs a read-only action on an actor.
let doReadOnly (handler:ReadOnlyAction<_,_>) (actor:StatefulActor<_>) =
    handler actor.State |> Task.FromResult

let (|+>) (actor:StatefulActor<_>)  (handler:UpdatingAction<_>) = doUpdate handler actor
let (|->) (actor:StatefulActor<_>) (handler:ReadOnlyAction<_,_>) = doReadOnly handler actor
