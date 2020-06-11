module EventPumpTests

open Xunit
open GameState

let private emptyPlayState = 
    {RenderGrid = Map.empty;
     Encounters = None;
     Actors = Map.empty;
     MapGrid = Map.empty}

[<Fact>]
let ``EventPump - poll event, then eventHandler processes it to a None GameState`` () =
    let eventsPolled = ref 0
    let eventPoller () = 
        eventsPolled := !eventsPolled + 1
        0u |> SDLEvent.Other |> Some

    let idles = ref 0
    let idleHandler state = 
        idles := !idles + 1
        ()

    let eventsHandled = ref 0
    let eventHandler event state =
        eventsHandled := !eventsHandled + 1
        None

    let state = 
        emptyPlayState 
        |> PlayState

    EventPump.eventPump eventPoller idleHandler eventHandler state

    Assert.Equal(1,!eventsPolled)
    Assert.Equal(0,!idles)
    Assert.Equal(1,!eventsHandled)

[<Fact>]
let ``EventPump - poll event, idle once, then poll event, then eventHandler processes it to a None GameState`` () =
    let eventsPolled = ref 0
    let eventPoller () = 
        eventsPolled := !eventsPolled + 1
        if !eventsPolled = 1 then
            None
        else 
            0u |> SDLEvent.Other |> Some

    let idles = ref 0
    let idleHandler state = 
        idles := !idles + 1
        ()

    let eventsHandled = ref 0
    let eventHandler event state =
        eventsHandled := !eventsHandled + 1
        None

    let state = 
        emptyPlayState 
        |> PlayState

    EventPump.eventPump eventPoller idleHandler eventHandler state

    Assert.Equal(2,!eventsPolled)
    Assert.Equal(1,!idles)
    Assert.Equal(1,!eventsHandled)

[<Fact>]
let ``EventPump - poll event, handle event with Some, then poll event, then eventHandler processes it to a None GameState`` () =
    let eventsPolled = ref 0
    let eventPoller () = 
        eventsPolled := !eventsPolled + 1
        0u |> SDLEvent.Other |> Some

    let idles = ref 0
    let idleHandler state = 
        idles := !idles + 1
        ()

    let eventsHandled = ref 0
    let eventHandler event state =
        eventsHandled := !eventsHandled + 1
        if !eventsHandled = 1 then
            state |> Some
        else
            None

    let state = 
        emptyPlayState 
        |> PlayState

    EventPump.eventPump eventPoller idleHandler eventHandler state

    Assert.Equal(2,!eventsPolled)
    Assert.Equal(0,!idles)
    Assert.Equal(2,!eventsHandled)
