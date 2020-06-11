open SDL
open Pixel
open Geometry

type EventSource<'TEvent> = unit -> 'TEvent option
type EventHandler<'TEvent,'TState> = 'TEvent -> 'TState -> 'TState option
type PresentationHandler<'TState> = 'TState -> unit

let rec eventOnlyEventPump 
        (eventSource: EventSource<'TEvent>) 
        (eventHandler: EventHandler<'TEvent,'TState>) 
        (presentationHandler: PresentationHandler<'TState>) 
        (state: 'TState) :unit =

    //present the state
    presentationHandler state

    //check for an event
    match eventSource() with

    //an event occurred
    | Some event ->

        //send event to event handler, and then pump again if a state is returned
        (event, state) 
        ||> eventHandler
        |> Option.iter (eventOnlyEventPump eventSource eventHandler presentationHandler)

    //no event occurred
    | None ->
        state
        |>eventOnlyEventPump eventSource eventHandler presentationHandler

let onEvent (event:Event.Event) (state) =
    if event.isQuitEvent then
        None
    else    
        Some state

let ScreenWidth = 640
let ScreenHeight = 480

let onDraw (renderer:Render.Renderer) (state:System.Random) : unit =
    let color = 
        {Red = state.Next(256) |> byte; Green = state.Next(256) |> byte; Blue=state.Next(256) |> byte; Alpha=255uy}

    renderer
    |> Render.setDrawColor color
    |> ignore

    renderer
    |> Render.drawLine {Geometry.Point.X = state.Next(ScreenWidth); Geometry.Point.Y = state.Next(ScreenHeight)}  {Geometry.Point.X = state.Next(ScreenWidth); Geometry.Point.Y = state.Next(ScreenHeight)}
    |> ignore

    let pts = 
        [0..(state.Next(256))]
        |> List.map (fun x -> {Geometry.Point.X = state.Next(ScreenWidth); Geometry.Point.Y = state.Next(ScreenHeight)})

    renderer
    |> Render.drawLines pts
    |> ignore
    
    renderer
    |> Render.present

let runGame () =
    use system = new Init.System(Init.Init.Video ||| Init.Init.Events)

    use window = Window.create ("Draw Line(s)", Window.Position.Centered, ScreenWidth,ScreenHeight, Window.Flags.None)

    use renderer = Render.create window None Render.Flags.Accelerated

    let state = new System.Random()

    eventOnlyEventPump Event.poll onEvent (onDraw renderer) state

[<EntryPoint>]
let main argv = 
    runGame()
    0
