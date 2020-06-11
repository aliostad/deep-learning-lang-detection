module Assessments.Repository

open Core
open Registers.Core

type AssessmentCommand =
| Get
| SetRegisterSource of RegisterSource * List<CandidateId>
| SetName of string
| AddCandidate of CandidateId
| RemoveCandidate of CandidateId
| SetCandidateResult of CandidateId * Option<Result>

type AssessmentAggregateRoot (commandHandler) =
    member me.State = Get |> commandHandler
    member me.SetRegisterSource source candidates = SetRegisterSource(source, candidates) |> commandHandler |> ignore
    member me.SetName name = SetName(name) |> commandHandler |> ignore
    member me.AddCandidate candidateId = AddCandidate(candidateId) |> commandHandler |> ignore
    member me.RemoveCandidate candidateId = RemoveCandidate(candidateId) |> commandHandler |> ignore
    member me.SetCandidateResult candidateId result = SetCandidateResult(candidateId, result) |> commandHandler |> ignore

exception AssessmentAlreadyCreatedException of System.Guid * string
exception AssessmentNotFoundException of System.Guid * string

let private failWithAlreadyCreated identity message =
    match identity with
    | AssessmentId(guid) ->
        raise (AssessmentAlreadyCreatedException (guid, message))

let private failWithNotFound identity message =
    match identity with
    | AssessmentId(guid) ->
        raise (AssessmentNotFoundException (guid, message))

type AssessmentRepository (createAssessmentCommandHandler) =
    let commandHandlers = new System.Collections.Concurrent.ConcurrentDictionary<AssessmentId, AssessmentCommand -> State.AssessmentState>()
    member me.Create identity (registerId:RegisterId) =
        let commandHandler = createAssessmentCommandHandler identity registerId
        let assessment = new AssessmentAggregateRoot(commandHandler)
        if not(commandHandlers.TryAdd(identity, commandHandler)) then failWithAlreadyCreated identity "Assessment already created"
        assessment

    member me.Open identity =
        let found, commandHandler = commandHandlers.TryGetValue(identity)
        if not(found) then failWithNotFound identity "Assessment not found"
        new AssessmentAggregateRoot(commandHandler)
