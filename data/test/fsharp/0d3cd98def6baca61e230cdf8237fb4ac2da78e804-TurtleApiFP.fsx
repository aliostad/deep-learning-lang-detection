#load "Common.fs"
#load "TurtleFP.fs"
#load "TurtleApiHelpers.fs"

open System
open CInfinity.Turtle.Common
open CInfinity.Turtle.TurtleFP
open CInfinity.Turtle.TurtleApiHelpers
open Result

module TurtleApiLayer =

    // logged versions    
    let move = Turtle.move dummyLog
    let turn = Turtle.turn dummyLog
    let penDown = Turtle.penDown dummyLog
    let penUp = Turtle.penUp dummyLog
    let setColor = Turtle.setColor dummyLog

    type TurtleApi() =
        let mutable state = Turtle.initialTurtleState

        let updateState newState =
            state <- newState

        member this.Exec (commandStr:string) = 
            let tokens = commandStr.Split(' ') |> List.ofArray |> List.map trimString

            // lift current state to Result
            let stateR = returnR state

            // calculate the new state
            let newStateR = 
                match tokens with
                | [ "Move"; distanceStr ] -> 
                    // get the distance as a Result
                    let distanceR = validateDistance distanceStr 

                    // call "move" lifted to the world of Results
                    lift2R move distanceR stateR

                | [ "Turn"; angleStr ] -> 
                    let angleR = validateAngle angleStr 
                    lift2R turn angleR stateR

                | [ "Pen"; "Up" ] -> 
                    returnR (penUp state)

                | [ "Pen"; "Down" ] -> 
                    returnR (penDown state)

                | [ "SetColor"; colorStr ] -> 
                    let colorR = validateColor colorStr
                    lift2R setColor colorR stateR

                | _ -> 
                    Failure (InvalidCommand commandStr)
        
            // Lift `updateState` into the world of Results and 
            // call it with the new state.
            mapR updateState newStateR

            // Return the final result (output of updateState)

// ======================================
// Turtle Api Client
// ======================================

module TurtleApiClient = 

    open TurtleApiLayer 
    open Result

    let drawTriangle() = 
        let api = TurtleApi()
        result {
            do! api.Exec "Move 100"
            do! api.Exec "Turn 120"
            do! api.Exec "Move 100"
            do! api.Exec "Turn 120"
            do! api.Exec "Move 100"
            do! api.Exec "Turn 120"
            }
        // back home at (0,0) with angle 0
            
    let drawThreeLines() = 
        let api = TurtleApi()
        result {

        // draw black line 
        do! api.Exec "Pen Down"
        do! api.Exec "SetColor Black"
        do! api.Exec "Move 100"
        // move without drawing
        do! api.Exec "Pen Up"
        do! api.Exec "Turn 90"
        do! api.Exec "Move 100"
        do! api.Exec "Turn 90"
        // draw red line 
        do! api.Exec "Pen Down"
        do! api.Exec "SetColor Red"
        do! api.Exec "Move 100"
        // move without drawing
        do! api.Exec "Pen Up"
        do! api.Exec "Turn 90"
        do! api.Exec "Move 100"
        do! api.Exec "Turn 90"
        // back home at (0,0) with angle 0
        // draw diagonal blue line 
        do! api.Exec "Pen Down"
        do! api.Exec "SetColor Blue"
        do! api.Exec "Turn 45"
        do! api.Exec "Move 100"
        }

    let drawPolygon n = 
        let angle = 180.0 - (360.0/float n) 
        let api = TurtleApi()

        // define a function that draws one side
        let drawOneSide() = result {
            do! api.Exec "Move 100.0"
            do! api.Exec (sprintf "Turn %f" angle)
            }

        // repeat for all sides
        result {
            for i in [1..n] do
                do! drawOneSide() 
        }

    let triggerError() = 
        let api = TurtleApi()
        api.Exec "Move bad"

// ======================================
// Turtle Api Tests
// ======================================

TurtleApiClient.drawTriangle() 
TurtleApiClient.drawThreeLines() 
TurtleApiClient.drawPolygon 4 

// test errors
TurtleApiClient.triggerError()  
// Failure (InvalidDistance "bad")

