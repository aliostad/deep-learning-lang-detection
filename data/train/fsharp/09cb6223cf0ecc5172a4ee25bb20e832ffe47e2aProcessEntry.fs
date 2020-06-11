﻿namespace MBrace.Thespian.Runtime

//
// This section defines a runtime entry for a running Cloud process
//

open System

open MBrace.FsPickler
open Nessos.Thespian
open MBrace.Vagabond

open MBrace.Core
open MBrace.Core.Internals
open MBrace.Library
open MBrace.Runtime
open MBrace.Runtime.Utils
open MBrace.Runtime.Utils.PrettyPrinters
open MBrace.Runtime.Store

type private ActorProcessEntryMsg =
    | GetState of IReplyChannel<CloudProcessState>
    | TrySetResult of ResultMessage<CloudProcessResult> * IWorkerId * IReplyChannel<bool>
    | TryGetResult of IReplyChannel<ResultMessage<CloudProcessResult> option>
    | DeclareStatus of status:CloudProcessStatus
    | IncrementWorkItemCount
    | IncrementCompletedWorkItemCount
    | IncrementFaultedWorkItemCount

/// Task completion source execution state
type private ActorProcessEntryState = 
    {
        /// Persisted result of actor, if available
        Result : ResultMessage<CloudProcessResult> option
        /// Cloud process metadata
        Info : CloudProcessInfo
        /// Cloud process execution status
        Status : CloudProcessStatus
        /// Number of currently executing MBrace work items for actor
        ActiveWorkItemCount : int
        /// Total number of MBrace work items for actor
        TotalWorkItemCount : int
        /// Total number of completed work items for actor
        CompletedWorkItemCount : int
        /// Total number of faulted work items for actor
        FaultedWorkItemCount : int
        /// Task execution time representation
        ExecutionTime: ExecutionTime
    }

    /// <summary>
    ///     Initializes actor state using provided actor metadata.
    /// </summary>
    /// <param name="info">Task metadata.</param>
    static member Init(info : CloudProcessInfo) = 
        { 
            Info = info ; Result = None
            TotalWorkItemCount = 0 ; ActiveWorkItemCount = 0 ;
            CompletedWorkItemCount = 0 ; FaultedWorkItemCount = 0
            ExecutionTime = NotStarted ; Status = CloudProcessStatus.Created 
        }

    /// <summary>
    ///     Converts the internal actor representation to one that can by used by
    ///     the MBrace actor manager.
    /// </summary>
    /// <param name="ts">Task state.</param>
    static member ExportState(ts : ActorProcessEntryState) : CloudProcessState =
        {
            Status = ts.Status
            Info = ts.Info
            ActiveWorkItemCount = ts.ActiveWorkItemCount
            TotalWorkItemCount = ts.TotalWorkItemCount
            CompletedWorkItemCount = ts.CompletedWorkItemCount
            FaultedWorkItemCount = ts.FaultedWorkItemCount

            ExecutionTime = 
                match ts.ExecutionTime with 
                | Started (t,_) -> Started (t, DateTimeOffset.Now - t)
                | et -> et
        }

/// Actor ProcEntry implementation
[<Sealed; AutoSerializable(true)>]
type ActorProcessEntry private (localStateF : LocalStateFactory, source : ActorRef<ActorProcessEntryMsg>, id : string, info : CloudProcessInfo)  =
    member __.Id = id
    member __.Info = info

    interface ICloudProcessEntry with
        member x.Id = id
        member x.AwaitResult(): Async<CloudProcessResult> = async {
            let localState = localStateF.Value
            let rec awaiter () = async {
                let! result = source <!- TryGetResult
                match result with
                | Some rm -> return! localState.ReadResult rm
                | None ->
                    do! Async.Sleep 200
                    return! awaiter ()
            }

            return! awaiter()
        }

        member x.WaitAsync(): Async<unit> = async {
            let rec awaiter () = async {
                let! state = source <!- GetState
                match state.Status with
                | CloudProcessStatus.Completed 
                | CloudProcessStatus.UserException 
                | CloudProcessStatus.Faulted 
                | CloudProcessStatus.Canceled -> return ()
                | _ ->
                    do! Async.Sleep 200
                    return! awaiter ()
            }

            return! awaiter()
        }
        
        member x.IncrementCompletedWorkItemCount(): Async<unit> = async {
            return! source.AsyncPost IncrementCompletedWorkItemCount
        }
        
        member x.IncrementFaultedWorkItemCount(): Async<unit> = async {
            return! source.AsyncPost IncrementFaultedWorkItemCount
        }
        
        member x.DeclareStatus(status: CloudProcessStatus): Async<unit> = async {
            return! source.AsyncPost (DeclareStatus status)
        }
        
        member x.GetState(): Async<CloudProcessState> = async {
            return! source <!- GetState
        }
        
        member x.IncrementWorkItemCount(): Async<unit> =  async {
            return! source.AsyncPost IncrementWorkItemCount
        }
        
        member x.Info: CloudProcessInfo = info
        
        member x.TryGetResult(): Async<CloudProcessResult option> = async {
            let localState = localStateF.Value
            let! rp = source <!- TryGetResult
            match rp with
            | None -> return None
            | Some rm ->
                let! r = localState.ReadResult(rm)
                return Some r
        }
        
        member x.TrySetResult(result: CloudProcessResult, workerId : IWorkerId): Async<bool> = async {
            let localState = localStateF.Value
            let id = sprintf "taskResult-%s" <| mkUUID()
            let! rm = localState.CreateResult(result, allowNewSifts = false, fileName = id)
            return! source <!- fun ch -> TrySetResult(rm, workerId, ch)
        }

    /// <summary>
    ///     Creates a actor entry instance in local process.
    /// </summary>
    /// <param name="stateF">Local state factory.</param>
    /// <param name="id">Task unique identifier.</param>
    /// <param name="info">Task metadata.</param>
    static member Create(stateF : LocalStateFactory, id : string, info : CloudProcessInfo) =
        let logger = stateF.Value.Logger
        let behaviour (state : ActorProcessEntryState) (msg : ActorProcessEntryMsg) = async {
            match msg with
            | GetState rc ->
                do! rc.Reply (ActorProcessEntryState.ExportState state)
                return state

            | TrySetResult(_, workerId, rc) when Option.isSome state.Result ->
                do logger.Logf LogLevel.Warning "CloudProcess[%s] '%s' received duplicate result from worker '%s'." info.ReturnTypeName id workerId.Id
                do! rc.Reply false
                return state

            | TrySetResult(r, workerId, rc) ->
                do logger.Logf LogLevel.Debug "CloudProcess[%s] '%s' received result from worker '%s'." info.ReturnTypeName id workerId.Id
                do! rc.Reply true
                return { state with Result = Some r }

            | TryGetResult rc ->
                do! rc.Reply state.Result
                return state

            | DeclareStatus status ->
                let executionTime =
                    match state.ExecutionTime, status with
                    | NotStarted, CloudProcessStatus.Running -> Started (DateTimeOffset.Now, TimeSpan.Zero)
                    | Started (t,_), (CloudProcessStatus.Completed | CloudProcessStatus.UserException | CloudProcessStatus.Canceled) -> 
                        let now = DateTimeOffset.Now
                        Finished(t, now - t)
                    | et, _ -> et

                return { state with Status = status ; ExecutionTime = executionTime}

            | IncrementWorkItemCount ->
                return { state with 
                                TotalWorkItemCount = state.TotalWorkItemCount + 1 ; 
                                ActiveWorkItemCount = state.ActiveWorkItemCount + 1 }

            | IncrementCompletedWorkItemCount ->
                return { state with ActiveWorkItemCount = state.ActiveWorkItemCount - 1 ; CompletedWorkItemCount = state.CompletedWorkItemCount + 1 }

            | IncrementFaultedWorkItemCount ->
                return { state with ActiveWorkItemCount = state.ActiveWorkItemCount - 1 ; FaultedWorkItemCount = state.FaultedWorkItemCount + 1 }
        }

        let ref =
            Behavior.stateful (ActorProcessEntryState.Init info) behaviour
            |> Actor.bind
            |> Actor.Publish
            |> Actor.ref

        new ActorProcessEntry(stateF, ref, id, info)