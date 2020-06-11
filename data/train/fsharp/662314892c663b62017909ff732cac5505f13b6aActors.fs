namespace EvilCorp.Common

open System.Threading.Tasks
open Microsoft.ServiceFabric.Actors

module Actors = 

    let update (actor : StatefulActor<_>) (handler : 'TState -> 'TState) =
        actor.State <- (handler actor.State)
        Task.FromResult() :> Task

    let query (actor : StatefulActor<_>) (handler : 'TState -> 'TOutput) =
        handler actor.State |> Task.FromResult

    let act (actor : StatefulActor<_>) (handler : 'TState -> unit) =
        handler actor.State |> ignore
        Task.FromResult() :> Task

    let (-!>) actor handler = update actor handler
    let (-?>) actor handler = query actor handler
    let (->>) actor handler = act actor handler
