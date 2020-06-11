#load "TicTacToeCore.fs"
#load "CapabilityApi.fs"

open TicTacToeCore
open CapabilityApi

// ================================
// helper functions
// ================================

/// call a unit function in the None case
let ifNone f o =
    match o with None -> f() | Some _ -> ()
    o

/// try to find a particular capability in a MoveResult and play it if found.
let playMove (row,col) moveResult =
    let matchMove availableMove =
        availableMove.posToPlay = (col,row)
    
    let playIfFound availableMoves =
        availableMoves 
        |> List.tryFind matchMove 
        |> Option.map (fun moveinfo -> moveinfo.capability())
        |> ifNone (fun () -> printfn "No available moves match %A" (row,col))

    match moveResult with
    | KeepPlaying (_,availableMoves) ->
        playIfFound availableMoves 
    | _ -> 
        printfn "Game is over!"
        None

// ================================
// Playing the capability-based API
// ================================

let api = CapabilityApi.API()

let newGame = api.NewGame()
let result1 = newGame |> playMove (Top,Left)
let result2 = result1.Value |> playMove (Bottom,Left)
let result3 = result2.Value |> playMove (Top,Right)
let result4 = result3.Value |> playMove (Middle,Center)
let result5 = result4.Value |> playMove (Top,Center)

// try to keep playing
let result6 = result5.Value |> playMove (Bottom,Center)

// try to play the same move twice
let newGameB = api.NewGame()
let resultB1 = newGameB |> playMove (Top,Left)
let resultB2 = resultB1.Value |> playMove (Top,Left)
