namespace CardboardTaskForceReactive

module CameraModule =
    open CardboardTaskForceReactive.Model.Vector
    open ReactiveGameEngine.Reactive
    
    type CameraState =
        { TopLeftPosition : Vector<int>
          Size : Vector<float32> }

    type CameraMessage =
        | MoveTo of Vector<int>
        | MoveToAndCentre of Vector<int>
        | MoveBy of Vector<int>

    let MAP_TILE_SIZE = 64

    let private message_handler (state,_) message =
        match message with
        | MoveTo vec -> { state with TopLeftPosition = vec }
        | MoveToAndCentre vec -> { state with TopLeftPosition = vec } //TODO: Finish logic here to centre
        | MoveBy vec -> { state with TopLeftPosition = state.TopLeftPosition + vec }

    let spawn_camera position (x_res,y_res) =
        let size_x = (float32 x_res) / (float32 MAP_TILE_SIZE)
        let size_y = (float32 y_res) / (float32 MAP_TILE_SIZE)

        let state = { TopLeftPosition = position; Size = Vector(size_x, size_y) }
        reactor {
            path "camera"
            defaultState state
            messageHandler message_handler
        } |> spawn
