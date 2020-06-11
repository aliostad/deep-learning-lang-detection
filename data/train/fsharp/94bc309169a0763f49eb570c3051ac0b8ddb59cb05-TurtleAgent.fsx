#load "Common.fs"
#load "TurtleFP.fs"
#load "TurtleApiHelpers.fs"

open System
open CInfinity.Turtle.Common
open CInfinity.Turtle.TurtleFP
open CInfinity.Turtle.TurtleApiHelpers

// ======================================
// Agent
// ======================================

module AgentImplementation = 

    open Result

    type TurtleCommand = 
        | Move of Distance 
        | Turn of Angle
        | PenUp
        | PenDown
        | SetColor of PenColor

    // --------------------------------------
    // The Agent 
    // --------------------------------------

    type TurtleAgent() =

        // logged versions    
        let move = Turtle.move dummyLog
        let turn = Turtle.turn dummyLog
        let penDown = Turtle.penDown dummyLog
        let penUp = Turtle.penUp dummyLog
        let setColor = Turtle.setColor dummyLog

        let mailboxProc = MailboxProcessor.Start(fun inbox ->
            let rec loop turtleState = async { 
                // read a command message from teh queue
                let! command = inbox.Receive()

                // create a new state from handling the message
                let newState = 
                    match command with
                    | Move distance ->
                        move distance turtleState
                    | Turn angle ->
                        turn angle turtleState
                    | PenUp ->
                        penUp turtleState
                    | PenDown ->
                        penDown turtleState
                    | SetColor color ->
                        setColor color turtleState

                return! loop newState  
                }

            loop Turtle.initialTurtleState )

        // expose the queue externally
        member this.Post(command) = 
            mailboxProc.Post command

// ======================================
// Turtle Api Layer
// ======================================

module TurtleApiLayer = 
    open Result
    open AgentImplementation

    type TurtleApi() =

        let turtleAgent = TurtleAgent()

        /// Execute the command string, and return a Result
        /// Exec : commandStr:string -> Result<unit,ErrorMessage>
        member this.Exec (commandStr:string) = 
            let tokens = commandStr.Split(' ') |> List.ofArray |> List.map trimString

            // calculate the new state
            let result = 
                match tokens with
                | [ "Move"; distanceStr ] -> result {
                    let! distance = validateDistance distanceStr 
                    let command = Move distance 
                    turtleAgent.Post command
                    } 

                | [ "Turn"; angleStr ] -> result {
                    let! angle = validateAngle angleStr 
                    let command = Turn angle
                    turtleAgent.Post command
                    }

                | [ "Pen"; "Up" ] -> result {
                    let command = PenUp
                    turtleAgent.Post command
                    }

                | [ "Pen"; "Down" ] -> result { 
                    let command = PenDown
                    turtleAgent.Post command
                    }

                | [ "SetColor"; colorStr ] -> result { 
                    let! color = validateColor colorStr
                    let command = SetColor color
                    turtleAgent.Post command
                    }

                | _ -> 
                    Failure (InvalidCommand commandStr)
        
            // return any errors
            result

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
        for i in [1..n] do
            drawOneSide() |> ignore

    let triggerError() = 
        let api = TurtleApi()
        api.Exec "Move bad"

// ======================================
// Turtle Api Tests
// ======================================


TurtleApiClient.drawTriangle() 
TurtleApiClient.drawThreeLines() // Doesn't go back home
TurtleApiClient.drawPolygon 4 

// test errors
TurtleApiClient.triggerError()  
// Failure (InvalidDistance "bad")



