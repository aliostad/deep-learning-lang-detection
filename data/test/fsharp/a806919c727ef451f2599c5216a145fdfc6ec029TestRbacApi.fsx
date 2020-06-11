#load "TicTacToeCore.fs"
#load "RbacApi.fs"

open TicTacToeCore
open RbacApi

// ================================
// Playing the obvious API
// ================================

let api = RbacApi.API()

api.Move({player=PlayerX; row=Top; col=Left})
api.Move({player=PlayerO; row=Bottom; col=Left})
api.Move({player=PlayerX; row=Top; col=Right})
api.Move({player=PlayerO; row=Middle; col=Center})
api.Move({player=PlayerX; row=Top; col=Center})



// ================================
// Problems with the API
// ================================


// A player can keep playing when the game is over
api.Move({player=PlayerO; row=Bottom; col=Right})
api.Move({player=PlayerO; row=Bottom; col=Center})

// A player can play twice in a row

// A player can request an already played move
