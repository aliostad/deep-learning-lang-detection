namespace CardboardTaskForceReactive

module UIService =
    open ReactiveGameEngine.Reactive
    open Microsoft.Xna.Framework
    open CardboardTaskForceReactive.Model

    type UIMessage =
        | ProcessScreenTap of Vector<int>

    let message_handler out_of_bounds_taps (state, context) message =
        match message with
        | ProcessScreenTap (position) -> ()
        state

    let _renderer sprite_retriever spriteBatch gameTime state =
        ()

    let spawn_ui_service out_of_bounds_taps content_retriever =
        reactor {
            path "ui"
            defaultState ()
            messageHandler (message_handler out_of_bounds_taps)
            renderer (_renderer content_retriever)
        } |> ignore
        //TODO: Don't ignore the result here and instead call spawn