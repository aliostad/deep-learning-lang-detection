namespace CardboardTaskForceReactive

open ReactiveGameEngine.Reactive
open CardboardTaskForceReactive.CameraModule

module DyingEntityModule =
    open CardboardTaskForceReactive.Model
    open EntityModule

    let private message_handler (state, context) message =
        match message with
        | AddDyingEntity(pos,path) -> { state with Entities = Map.add pos path state.Entities }
        | TrimDeadEntity(pos) -> { state with Entities = Map.remove pos state.Entities }

    let private default_state () =
        { Entities = Map.empty }

    let spawn_dying_entities () =
        reactor {
            path "dying"
            defaultState (default_state ())
            messageHandler message_handler
        }