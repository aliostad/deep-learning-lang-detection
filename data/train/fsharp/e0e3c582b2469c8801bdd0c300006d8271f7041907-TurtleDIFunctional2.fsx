#load "Common.fs"
#load "TurtleFP.fs"
#load "TurtleApiHelpers.fs"

open System
open CInfinity.Turtle.Common
open CInfinity.Turtle.TurtleFP
open CInfinity.Turtle.TurtleApiHelpers // helpers for API validation, etc

// ======================================
// Turtle Api -- Pass in a single function
// ======================================

module TurtleApi_PassInSingleFunction = 
    
    open Result

    type TurtleCommand = 
        | Move of Distance 
        | Turn of Angle
        | PenUp
        | PenDown
        | SetColor of PenColor

    // No functions in constructor
    type TurtleApi() =  

        let mutable state = Turtle.initialTurtleState

        /// Update the mutable state value
        let updateState newState =
            state <- newState

        /// Execute the command string, and return a Result
        /// Exec : commandStr:string -> Result<unit,ErrorMessage>
        member this.Exec turtleFn (commandStr:string) = 
            let tokens = commandStr.Split(' ') |> List.ofArray |> List.map trimString

            // return Success of unit, or Failure
            match tokens with
            | [ "Move"; distanceStr ] -> result {
                let! distance = validateDistance distanceStr 
                let command =  Move distance      // create a Command object
                let newState = turtleFn command state
                updateState newState
                }
            | [ "Turn"; angleStr ] -> result {
                let! angle = validateAngle angleStr 
                let command =  Turn angle      // create a Command object
                let newState = turtleFn command state
                updateState newState
                }
            | [ "Pen"; "Up" ] -> result {
                let command =  PenUp
                let newState = turtleFn command state
                updateState newState
                }
            | [ "Pen"; "Down" ] -> result {
                let command =  PenDown
                let newState = turtleFn command state
                updateState newState
                }
            | [ "SetColor"; colorStr ] -> result {
                let! color = validateColor colorStr
                let command =  SetColor color 
                let newState = turtleFn command state
                updateState newState
                }
            | _ -> 
                Failure (InvalidCommand commandStr)

      

// -----------------------------
// Turtle Implementations for "Pass in a single function" design
// -----------------------------

module TurtleImplementation_PassInSingleFunction = 
    
    open TurtleApi_PassInSingleFunction

    let move = Turtle.move dummyLog 
    let turn = Turtle.turn dummyLog 
    let penUp = Turtle.penUp dummyLog
    let penDown = Turtle.penDown dummyLog
    let setColor = Turtle.setColor dummyLog 

    let normalSize() = 
        let turtleFn = function
            | Move dist -> move dist 
            | Turn angle -> turn angle
            | PenUp -> penUp 
            | PenDown -> penDown 
            | SetColor color -> setColor color

        // partially apply the function to the API
        let api = TurtleApi() 
        api.Exec turtleFn 
        // the return value is a function: 
        //     string -> Result<unit,ErrorMessage> 
        

    let halfSize() = 
        let turtleFn = function
            | Move dist -> move (dist/2.0)  
            | Turn angle -> turn angle
            | PenUp -> penUp 
            | PenDown -> penDown 
            | SetColor color -> setColor color

        // partially apply the function to the API
        let api = TurtleApi() 
        api.Exec turtleFn 
        // the return value is a function: 
        //     string -> Result<unit,ErrorMessage> 
        
// -----------------------------
// Turtle API Client for "Pass in a single function" design
// -----------------------------

module TurtleApiClient_PassInSingleFunction = 

    open Result

    // the API type is just a function
    type ApiFunction = string -> Result<unit,ErrorMessage>

    let drawTriangle(api:ApiFunction) = 
        result {
            do! api "Move 100"
            do! api "Turn 120"
            do! api "Move 100"
            do! api "Turn 120"
            do! api "Move 100"
            do! api "Turn 120"
            } |> ignore

// -----------------------------
// Turtle Api Tests for "Pass in a single function" design
// -----------------------------

do
    let api = TurtleImplementation_PassInSingleFunction.normalSize()
    TurtleApiClient_PassInSingleFunction.drawTriangle(api) 

do
    let api = TurtleImplementation_PassInSingleFunction.halfSize()
    TurtleApiClient_PassInSingleFunction.drawTriangle(api) 
