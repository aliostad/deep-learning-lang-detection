module Registers.Repository

open Core
open State

type RegisterCommand =
| Get
| AddCandidate of CandidateId * string
| RemoveCandidate of CandidateId
| SetCandidateName of CandidateId * string

type RegisterAggregateRoot (commandHandler) =
    member me.State = Get |> commandHandler
    member me.AddCandidate candidateId name = AddCandidate(candidateId, name) |> commandHandler |> ignore
    member me.RemoveCandidate candidateId = RemoveCandidate(candidateId) |> commandHandler |> ignore
    member me.SetCandidateName candidateId name = SetCandidateName(candidateId, name) |> commandHandler |> ignore

exception RegisterAlreadyCreatedException of System.Guid * string
exception RegisterNotFoundException of System.Guid * string

let private failWithAlreadyCreated identity message =
    match identity with
    | RegisterId(guid) ->
        raise (RegisterAlreadyCreatedException (guid, message))

let private failWithNotFound identity message =
    match identity with
    | RegisterId(guid) ->
        raise (RegisterNotFoundException (guid, message))

type RegisterRepository (commandHandlerFactory) =
    let commandHandlers = new System.Collections.Concurrent.ConcurrentDictionary<RegisterId, RegisterCommand -> RegisterState>()
    member me.Create identity =
        let commandHandler = commandHandlerFactory identity
        let register = new RegisterAggregateRoot(commandHandler)
        if not(commandHandlers.TryAdd(identity, commandHandler)) then failWithAlreadyCreated identity "Assessment already created"
        register

    member me.Open identity =
        let found, commandHandler = commandHandlers.TryGetValue(identity)
        if not(found) then failWithNotFound identity "Assessment not found"
        new RegisterAggregateRoot(commandHandler)
