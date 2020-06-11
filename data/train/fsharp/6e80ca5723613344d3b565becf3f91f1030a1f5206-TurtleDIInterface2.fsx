

#load "Common.fs"
#load "TurtleOO.fs"
#load "TurtleFP.fs"
#load "TurtleApiHelpers.fs"

open System
open CInfinity.Turtle.Common
open CInfinity.Turtle.TurtleApiHelpers


// ============================================================================
// Dependency Injection (records of functions)
// ============================================================================

// ----------------------------
// Turtle Interface 
// ----------------------------

// a quick alias for readability
type TurtleState = CInfinity.Turtle.TurtleFP.Turtle.TurtleState 

type TurtleFunctions = {
    move : Distance -> TurtleState -> TurtleState
    turn : Angle -> TurtleState -> TurtleState
    penUp : TurtleState -> TurtleState
    penDown : TurtleState -> TurtleState
    setColor : PenColor -> TurtleState -> TurtleState
    }
// Note that there are NO "units" in these functions, unlike the OO version.


// ----------------------------
// Turtle Api Layer 
// ----------------------------

module TurtleApiLayer_FP = 

    open Result
    open CInfinity.Turtle.TurtleFP
    
    let initialTurtleState = Turtle.initialTurtleState

    type ErrorMessage = 
        | InvalidDistance of string
        | InvalidAngle of string
        | InvalidColor of string
        | InvalidCommand of string

    // convert the distance parameter to a float, or throw an exception
    let validateDistance distanceStr =
        try
            Success (float distanceStr)
        with
        | ex -> 
            Failure (InvalidDistance distanceStr)

    // convert the angle parameter to a float, or throw an exception
    let validateAngle angleStr =
        try
            Success ((float angleStr) * 1.0)
        with
        | ex -> 
            Failure (InvalidAngle angleStr)

    // convert the color parameter to a PenColor, or throw an exception
    let validateColor colorStr =
        match colorStr with
        | "Black" -> Success Black
        | "Blue" -> Success Blue
        | "Red" -> Success Red
        | _ -> 
            Failure (InvalidColor colorStr)

    type TurtleApi(turtleFunctions: TurtleFunctions) =

        let mutable state = initialTurtleState

        /// Update the mutable state value
        let updateState newState =
            state <- newState

        /// Execute the command string, and return a Result
        /// Exec : commandStr:string -> Result<unit,ErrorMessage>
        member this.Exec (commandStr:string) = 
            let tokens = commandStr.Split(' ') |> List.ofArray |> List.map trimString

            // return Success of unit, or Failure
            match tokens with
            | [ "Move"; distanceStr ] -> result {
                let! distance = validateDistance distanceStr 
                let newState = turtleFunctions.move distance state
                updateState newState
                }
            | [ "Turn"; angleStr ] -> result {
                let! angle = validateAngle angleStr 
                let newState = turtleFunctions.turn angle state
                updateState newState
                }
            | [ "Pen"; "Up" ] -> result {
                let newState = turtleFunctions.penUp state
                updateState newState
                }
            | [ "Pen"; "Down" ] -> result {
                let newState = turtleFunctions.penDown state
                updateState newState
                }
            | [ "SetColor"; colorStr ] -> result {
                let! color = validateColor colorStr
                let newState = turtleFunctions.setColor color state
                updateState newState
                }
            | _ -> 
                Failure (InvalidCommand commandStr)
        

// ----------------------------
// Multiple Turtle Implementations 
// ----------------------------

module TurtleImplementation_FP = 
    open CInfinity.Turtle.TurtleFP

    let normalSize() = 
        // return a record of functions
        {
            move = Turtle.move dummyLog 
            turn = Turtle.turn dummyLog            
            penUp = Turtle.penUp dummyLog
            penDown = Turtle.penDown dummyLog
            setColor = Turtle.setColor dummyLog 
        }

    let halfSize() = 
        let normalSize = normalSize() 
        // return a reduced turtle
        { normalSize with
            move = fun dist -> normalSize.move (dist/2.0) 
        }

// ----------------------------
// Turtle Api Client  
// ----------------------------

module TurtleApiClient_FP = 

    open TurtleApiLayer_FP 
    open Result

    let drawTriangle(api:TurtleApi) = 
        result {
            do! api.Exec "Move 100"
            do! api.Exec "Turn 120"
            do! api.Exec "Move 100"
            do! api.Exec "Turn 120"
            do! api.Exec "Move 100"
            do! api.Exec "Turn 120"
            } |> ignore

// ----------------------------
// Turtle Api Tests  (FP style)
// ----------------------------

do
    let turtleFns = TurtleImplementation_FP.normalSize()   // a TurtleFunctions type
    let api = TurtleApiLayer_FP.TurtleApi(turtleFns)
    TurtleApiClient_FP.drawTriangle(api) 

do
    let turtleFns = TurtleImplementation_FP.halfSize()
    let api = TurtleApiLayer_FP.TurtleApi(turtleFns)
    TurtleApiClient_FP.drawTriangle(api) 


