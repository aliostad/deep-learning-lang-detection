#load "Common.fs"
#load "TurtleOO.fs"

open System
open CInfinity.Turtle.Common
open CInfinity.Turtle.TurtleOO

module TurtleApiLayer =

    exception TurtleApiException of string

    type TurtleApi () =
        let turtle = Turtle(dummyLog)

        // convert the distance parameter to a float, or throw an exception
        let validateDistance distanceStr =
            try
                float distanceStr 
            with
            | ex -> 
                let msg = sprintf "Invalid distance '%s' [%s]" distanceStr  ex.Message
                raise (TurtleApiException msg)

        // convert the angle parameter to a float, or throw an exception
        let validateAngle angleStr =
            try
                (float angleStr) * 1.0 
            with
            | ex -> 
                let msg = sprintf "Invalid angle '%s' [%s]" angleStr ex.Message
                raise (TurtleApiException msg)

        // convert the color parameter to a PenColor, or throw an exception
        let validateColor colorStr =
            match colorStr with
            | "Black" -> Black
            | "Blue" -> Blue
            | "Red" -> Red
            | _ -> 
                let msg = sprintf "Color '%s' is not recognized" colorStr
                raise (TurtleApiException msg)
                
        /// Execute the command string, or throw an exception
        /// (Exec : commandStr:string -> unit)
        member this.Exec (commandStr:string) = 
            let tokens = commandStr.Split(' ') |> List.ofArray |> List.map trimString
            match tokens with
            | [ "Move"; distanceStr ] -> 
                let distance = validateDistance distanceStr 
                turtle.Move distance 
            | [ "Turn"; angleStr ] -> 
                let angle = validateAngle angleStr
                turtle.Turn angle  
            | [ "Pen"; "Up" ] -> 
                turtle.PenUp()
            | [ "Pen"; "Down" ] -> 
                turtle.PenDown()
            | [ "SetColor"; colorStr ] -> 
                let color = validateColor colorStr 
                turtle.SetColor color
            | _ -> 
                let msg = sprintf "Instruction '%s' is not recognized" commandStr
                raise (TurtleApiException msg)

// ======================================
// Turtle Api Client
// ======================================

module TurtleApiClient = 
    open TurtleApiLayer

    let drawTriangle() = 
        let api = TurtleApi()
        api.Exec "Move 100"
        api.Exec "Turn 120"
        api.Exec "Move 100"
        api.Exec "Turn 120"
        api.Exec "Move 100"
        api.Exec "Turn 120"
        // back home at (0,0) with angle 0
            
    let drawThreeLines() = 
        let api = TurtleApi()
        // draw black line 
        api.Exec "Pen Down"
        api.Exec "SetColor Black"
        api.Exec "Move 100"
        // move without drawing
        api.Exec "Pen Up"
        api.Exec "Turn 90"
        api.Exec "Move 100"
        api.Exec "Turn 90"
        // draw red line 
        api.Exec "Pen Down"
        api.Exec "SetColor Red"
        api.Exec "Move 100"
        // move without drawing
        api.Exec "Pen Up"
        api.Exec "Turn 90"
        api.Exec "Move 100"
        api.Exec "Turn 90"
        // back home at (0,0) with angle 0
        // draw diagonal blue line 
        api.Exec "Pen Down"
        api.Exec "SetColor Blue"
        api.Exec "Turn 45"
        api.Exec "Move 100"

    let drawPolygon n = 
        let angle = 180.0 - (360.0/float n) 
        let api = TurtleApi()

        // define a function that draws one side
        let drawOneSide() = 
            api.Exec "Move 100.0"
            api.Exec (sprintf "Turn %f" angle)

        // repeat for all sides
        for i in [1..n] do
            drawOneSide()

    let triggerError() = 
        let api = TurtleApi()
        api.Exec "Move bad"

// ======================================
// Turtle API tests
// ======================================

TurtleApiClient.drawTriangle() 
TurtleApiClient.drawThreeLines() 
TurtleApiClient.drawPolygon 4 

// test errors
TurtleApiClient.triggerError()
// Exception of type 'TurtleApiException' was thrown.

