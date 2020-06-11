module HanabiGuru.Client.Console.Tests.CommandProcessingTestFramework

open Swensen.Unquote
open HanabiGuru.Client.Console
open HanabiGuru.Engine

let processInput input =
    let mutable inputQueue = input

    let getInput () =
        match inputQueue with
        | input :: remainingInput ->
            inputQueue <- remainingInput
            Some input
        | [] -> None

    let mutable gameState = EventHistory.empty
    let commandExecuted newGameState = gameState <- newGameState
    let fail failure = new AssertionFailedException(sprintf "%A" failure) |> raise

    CommandInterface.processInput getInput (CommandInterface.pipeline commandExecuted fail fail)

    gameState

let startGame names =
    let addPlayers = names |> Set.toList |> List.map (sprintf "add player %s")
    "start" :: addPlayers |> List.rev |> processInput
