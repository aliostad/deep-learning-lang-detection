#load "TicTacToeCore.fs"
#load "CapabilityApi.fs"

open TicTacToeCore
open CapabilityApi

// ================================
// Playing the HATEAOS API
// ================================

let webapi = CapabilityApi.WebAPI()
webapi.NewGame()

// Top,Left
webapi.Play("8077c6e2-e051-4256-9c6a-664466db693d")  // replace with a real GUID from the result

// (Bottom,Left)
webapi.Play("9aa8684c-f08a-4f05-be6d-b2c08e774c35")

// (Top,Right)
webapi.Play("")

// (Middle,Center)
webapi.Play("")

// (Top,Center)
webapi.Play("")
