//
// All source code herein is Copyright (C) 2014, Philip Davis
//
// Robot Turtles is among the trademarks of Robot Turtles LLC, used here by permission
// Thanks to Dan Shapiro and all the Kickstarter backers for a great game.
//

namespace RobotTurtles

open RobotTurtles.Game

//
// Helper class to construct a Board from a human-friendly format
// rather than a machine-friendly format.
//
// Example usage:
//
//     let board =
//        GameMaker.Make [|
//            "Bv            P<";
//            "                ";
//            "    ##ii####    ";
//            "    ##Rg  ##    ";
//            "    ##    ii    ";
//            "    ##[][]##    ";
//            "                ";
//            "R>            G^"
//        |]
//
// Where ## is Stone Wall
//       ii is Ice Wall
//       [] is Box
//       Rg is a Red Gem (also Bg, Pg, Gg)
//       R> is a Red Turtle facing East (also {R, B, P ,G} x {^, >, v, <})
//
type GameMaker =
    static member public Make (rows: string[]) =
        let getColor colorChar what =
            match colorChar with
            | 'R' -> Color.Red
            | 'B' -> Color.Blue
            | 'P' -> Color.Purple
            | 'G' -> Color.Green
            | _ -> invalidArg "color" (sprintf "Unrecognized color %A for %A" colorChar what)

        let getDirection dirChar =
            match dirChar with
            | '^' -> North
            | '>' -> East
            | 'v' -> South
            | '<' -> West
            | _ -> invalidArg "direction" (sprintf "Unrecognized direction %A for turtle" dirChar)

        let rec processRow cellUpdates y remainingRows =
            let rec processColumns cellUpdates x remainingColumns =
                match remainingColumns with
                | [] ->
                    cellUpdates
            
                | onlyOne :: [] ->
                    invalidArg "rows" "Found invalid number of columns... Each row should be 16 chars"            
            
                // Empty cell
                | ' ' :: ' ' :: tail ->
                    processColumns cellUpdates (x + 1) tail
            
                // Ice Wall
                | 'i' :: 'i' :: tail ->
                    processColumns ({ X = x; Y = y; Piece = Some(IceWall)} :: cellUpdates) (x + 1) tail
            
                // Stone Wall
                | '#' :: '#' :: tail ->
                    processColumns ({ X = x; Y = y; Piece = Some(StoneWall)} :: cellUpdates) (x + 1) tail
            
                // Box
                | '[' :: ']' :: tail ->
                    processColumns ({ X = x; Y = y; Piece = Some(Box)} :: cellUpdates) (x + 1) tail

                // Gem
                | color :: 'g' :: tail ->
                    processColumns ({ X = x; Y = y; Piece = Some(Gem (getColor color "gem"))} :: cellUpdates) (x + 1) tail
            
                // Turtle
                | color :: direction :: tail ->
                    processColumns ({ X = x; Y = y; Piece = Some(Turtle((getColor color "turtle"), (getDirection direction)))} :: cellUpdates) (x + 1) tail
        
            match remainingRows with
            | [] -> cellUpdates
            | headRow :: tailRows ->
                processRow (cellUpdates @ (processColumns [] 0 headRow)) (y + 1) tailRows

        let cellUpdates =
            processRow [] 0 (rows |> List.ofSeq |> List.map (fun row -> row |> List.ofSeq))

        Board.Initialize cellUpdates
