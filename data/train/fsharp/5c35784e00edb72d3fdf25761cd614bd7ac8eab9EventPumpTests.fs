[<System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverageAttribute>]
module EventPumpTests

open Xunit
open EventPump
open SDL.Event

[<Fact>]
let ``eventPump poll event, handle to None`` () =

    let eventsPolled = ref 0
    let eventPoller (counter:Ref<int>) () =
        counter := !counter + 1
        0u |> Other |> Some

    let idles = ref 0
    let idleHandler (counter:Ref<int>) state = 
        counter := !counter + 1
        ()

    let eventsHandled = ref 0
    let eventHandler (counter:Ref<int>) event state = 
        counter := !counter + 1
        None

    let state = 0

    eventPump (eventPoller eventsPolled) (idleHandler idles) (eventHandler eventsHandled) state

    Assert.Equal(1, !eventsPolled)
    Assert.Equal(0, !idles)
    Assert.Equal(1, !eventsHandled)

[<Fact>]
let ``eventPump no event, idle, poll event, handle to None`` () =

    let eventsPolled = ref 0
    let eventPoller (counter:Ref<int>) () =
        counter := !counter + 1
        if !counter = 1 then
            None
        else
            0u |> Other |> Some

    let idles = ref 0
    let idleHandler (counter:Ref<int>) state = 
        counter := !counter + 1
        ()

    let eventsHandled = ref 0
    let eventHandler (counter:Ref<int>) event state = 
        counter := !counter + 1
        None

    let state = 0

    eventPump (eventPoller eventsPolled) (idleHandler idles) (eventHandler eventsHandled) state

    Assert.Equal(2, !eventsPolled)
    Assert.Equal(1, !idles)
    Assert.Equal(1, !eventsHandled)


[<Fact>]
let ``eventPump poll event, handle to Some, poll event, handle to None`` () =

    let eventsPolled = ref 0
    let eventPoller (counter:Ref<int>) () =
        counter := !counter + 1
        0u |> Other |> Some

    let idles = ref 0
    let idleHandler (counter:Ref<int>) state = 
        counter := !counter + 1
        ()

    let eventsHandled = ref 0
    let eventHandler (counter:Ref<int>) event state = 
        counter := !counter + 1
        if !counter = 1 then
            state |> Some
        else
            None

    let state = 0

    eventPump (eventPoller eventsPolled) (idleHandler idles) (eventHandler eventsHandled) state

    Assert.Equal(2, !eventsPolled)
    Assert.Equal(0, !idles)
    Assert.Equal(2, !eventsHandled)
