module Test.GameLoop

open Fable.Core.Testing
open Engine

[<TestFixture>]
module GameLoop =

    let mutable gameAsListOfEvents = []
    let mutable callbacks = []

    let updateFunc game event =
        gameAsListOfEvents <- event :: game
        gameAsListOfEvents

    let requestFrame cb =
        callbacks <- cb :: callbacks
        ()

    [<SetUp>]
    let setUp () =
        callbacks <- []
        gameAsListOfEvents <- []

    [<Test>]
    let ``creates an updater that encapsulates updating the game state`` () =
        let event = 10. |> GameLoop.Tick
        let eventHandler = GameLoop.createGameEventHandler updateFunc gameAsListOfEvents
        let currentState = eventHandler event

        equal true ([event] = currentState)

    [<Test>]
    let ``updater uses the initial game`` () =
        let event = 10. |> GameLoop.Tick
        let updatedState = event :: gameAsListOfEvents
        let eventHandler = GameLoop.createGameEventHandler updateFunc updatedState
        let currentState = eventHandler event

        equal true ([event; event] = currentState)

    [<Test>]
    let ``updater keeps track of all the events`` () =
        let eventOne = 10. |> GameLoop.Tick
        let eventTwo = 20. |> GameLoop.Tick
        let eventHandler = GameLoop.createGameEventHandler updateFunc gameAsListOfEvents

        eventHandler eventOne |> ignore
        let finalState = eventHandler eventTwo

        equal true ([eventTwo; eventOne;] = finalState)

    [<Test>]
    let ``requests a frame immediately on being called`` () =
        GameLoop.start requestFrame ignore ignore

        List.length callbacks |> equal 1

    [<Test>]
    let ``request frame will (eventually) request another frame`` () =
        GameLoop.start requestFrame ignore ignore
        List.head callbacks <| 1.

        List.length callbacks |> equal 2

    [<Test>]
    let ``when the loop is started the update is called with 0`` () =
        let eventHandler = GameLoop.createGameEventHandler updateFunc gameAsListOfEvents

        GameLoop.start requestFrame eventHandler ignore

        let expectedEvent = 0. |> GameLoop.Tick
        equal true ([expectedEvent] = gameAsListOfEvents)

    [<Test>]
    let ``the result of the event handler is rendered`` () =
        let mutable renderedGame = []
        let renderer game =
            renderedGame <- game
        let eventHandler = GameLoop.createGameEventHandler updateFunc gameAsListOfEvents

        GameLoop.start requestFrame eventHandler renderer

        let expectedGame = GameLoop.Tick 0.
        equal true ([expectedGame] = renderedGame)
