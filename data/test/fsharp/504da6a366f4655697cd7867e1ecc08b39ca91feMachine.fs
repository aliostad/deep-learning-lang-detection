namespace Strat.StateMachine

open System
open Strat.StateMachine.State

[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module StateMachine = 

   /// Describes the target state of a transition
   type private TransitionTarget<'D,'M> = 
      /// Transition is an internal.  The current state will not change, and no entry or exit handlers will be called.
      | Internal
      /// Transition is to a different state, or a self transition (i.e the current state is exited and re-entered).
      | State of State<'D,'M>


   // Helper function to construct TransitionContext record
   let private mkTransitionContext sourceData sourceState targetData transTarget handlingState: TransitionContext<_,_> = 
      let targetState = match transTarget with | Internal -> sourceState | State(targetState) -> targetState
      { SourceData = sourceData; 
        SourceState = sourceState;
        TargetData = targetData; 
        TargetState = targetState;
        HandlingState = handlingState }


   // Helper function to construct MessageProcessed record
   let private mkMessageProcessed msgResult message prevMachineContext nextMachineContext exitingStates enteringStates = 
      match msgResult with
      | MessageResult.Unhandled -> 
         MessageProcessed.UnhandledMessage message
      | MessageResult.InvalidMessage (reason, code) -> 
         MessageProcessed.InvalidMessage (reason, code, message)
      | _ ->
         MessageProcessed.HandledMessage 
            { Message = message;
              PrevContext = prevMachineContext
              NextContext = nextMachineContext
              ExitedStates = List.ofSeq exitingStates 
              EnteredStates = List.ofSeq enteringStates }


   /// Throws an exception of the root ancestor of the state is not the specified root state.
   let private ensureRoot state (stateTree: StateTree<'D,'M>) = 
      let stateRoot = state |> State.root
      if stateRoot <> stateTree.Root then 
         let msg = 
            sprintf 
               "State %s has a different root state (%s) than the expected root (%s)" 
               (state.Name)
               (stateRoot.Name)
               (stateTree.Root.Name)
         invalidOp <| msg


   // Invokes the transition handler, and returns an async of the result.
   let inline private runTransitionHandler handler transCtx = 
      match handler with 
      | TransitionHandler.Sync handler -> async.Return (handler transCtx) 
      | TransitionHandler.Async handler -> handler transCtx 


   // Invokes the message handler, and returns an async of the result.
   let inline private runMessageHandler handler msgCtx = 
      match handler with 
      | MessageHandler.Sync handler -> async.Return (handler msgCtx) 
      | MessageHandler.Async handler -> handler msgCtx 


   // Invokes the initial transition function, and returns an async of the result.
   let inline private runInitialTransition initTransition data = 
      match initTransition with 
      | InitialTransition.Sync handler -> async.Return (handler data) 
      | InitialTransition.Async handler -> handler data 


   let inline private withTransContextTransform transform transHandler = 
      match transHandler with
      | TransitionHandler.Sync handle -> TransitionHandler.Sync (transform >> handle)
      | TransitionHandler.Async handle -> TransitionHandler.Async (transform >> handle)


   let inline private withHandlingState state  = 
      fun transCtx -> { transCtx with HandlingState = state }
 
     
   let private onEnterWithHandlingState state : TransitionHandler<_,_> =
      let onEnter = (handlers state).OnEnter
      onEnter |> withTransContextTransform (withHandlingState state)


   let private onExitWithHandlingState state : TransitionHandler<_,_> =
      let onExit = (handlers state).OnExit
      onExit |> withTransContextTransform (withHandlingState state)


   // Determines the path between the two states, and returns the list of states exited, the least common ancestor
   // state, and the list of states entered 
   let private statePath (state1: State<'D,'M>) (state2: State<'D,'M>) = 
      let ancestors1 = ancestors state1 
      let ancestors2 = ancestors state2
      let lca = 
         Seq.zip (ancestors1 |> List.rev) (ancestors2 |> List.rev)
         |> Seq.takeWhile (Object.Equals)
         |> Seq.last
         |> fst
      let notLca s = not (Object.Equals (s,lca))
      let exitingStates = (state1::ancestors1) |> List.takeWhile notLca
      let enteringStates = (state2::ancestors2) |> List.takeWhile notLca |> List.rev
      struct (exitingStates, lca, enteringStates)


   // Compose the list of transition handlers into a single handler that will invoke each in turn.
   let private composeHandlers (actions: List<TransitionHandler<'D,'M>>) : TransitionHandler<'D,'M> = 
      actions 
      |> List.fold (fun prevResult action ->       
         match prevResult, action with
         | TransitionHandler.Sync prevHandler, TransitionHandler.Sync handler ->
            TransitionHandler.Sync (fun transCtx -> 
               let nextData = prevHandler transCtx
               handler { transCtx with TargetData = nextData })
         | TransitionHandler.Sync prevHandler, TransitionHandler.Async handler ->
            TransitionHandler.Async (fun transCtx -> 
               let nextData = prevHandler transCtx
               handler { transCtx with TargetData = nextData })
         | TransitionHandler.Async prevHandler, TransitionHandler.Sync handler ->
            TransitionHandler.Async (fun transCtx ->
               async { 
                  let! nextData = prevHandler transCtx
                  return handler { transCtx with TargetData = nextData }
               })
         | TransitionHandler.Async prevHandler, TransitionHandler.Async handler ->
            TransitionHandler.Async (fun transCtx -> 
               async {
                  let! nextData = prevHandler transCtx
                  return! handler { transCtx with TargetData = nextData } 
               })
      ) State.emptyTransitionHandler

   
   // Returns an async yielding the result of entering the initial state (recursively descending the state tree)
   // of the state in the specified context.
   let rec private enterInitialState 
      (fromRoot: bool) 
      (stateTree: StateTree<'D,'M>)
      (transCtx:TransitionContext<'D,'M>) = 

      // Recursively enters each state indicated by running the initialTransition function.
      let rec enterInitialStateAcc stateTree transCtx = 
         async {
            match initialTransition transCtx.TargetState with 
            | Some handler ->
               let! struct (nextData, nextStateRef) = runInitialTransition handler transCtx.TargetData
               let nextState = stateTree |> StateTree.findState nextStateRef
               let handlers = handlers nextState
               ensureChild transCtx.TargetState nextState
               let transCtx = {transCtx with TargetData = nextData; TargetState = nextState; HandlingState = nextState }
               let! nextData = runTransitionHandler handlers.OnEnter transCtx
               return! enterInitialStateAcc stateTree { transCtx with TargetData = nextData }
            | None -> 
               return transCtx
         }

      async {
         // States from root to the next state specified in the context (inclusive)
         let enteringStates = 
            if fromRoot then transCtx.TargetState |> selfAndAncestors |> List.rev 
            else List.empty
         
         // Enter ancestor states
         let onEnterHandler = enteringStates |> List.map onEnterWithHandlingState |> composeHandlers
         let! nextData = transCtx |> runTransitionHandler onEnterHandler
         let transCtx = { transCtx with TargetData = nextData } 

         // Descend into initial states, entering each one
         return! enterInitialStateAcc stateTree transCtx 
      }


   // Handles a message by invoking OnMessage on the state and each of its ancestors, until the message has been
   // handled. Returns an async yielding the message result, next state machine state, the next data, and a 
   // transition action that should be invoked during the transition to the next state.
   let private handleMessage 
      (message: 'M)
      (machineCtx:StateMachineContext<'D,'M>) : Async<struct (MessageResult<'D,'M> * TransitionTarget<'D,'M> * 'D * TransitionHandler<'D,'M>)> =
      
      let originalState = machineCtx.State
      let rec handleMessageAcc msgCtx state = 
         async {
            let handlers = handlers state
            let! msgResult = runMessageHandler handlers.OnMessage msgCtx
            match msgResult with 
            | Transition (stateName, nextData, optAction) -> 
               let action = defaultArg optAction State.emptyTransitionHandler
               return struct (msgResult, State (machineCtx.StateTree |> StateTree.findState stateName), nextData, action)
            | SelfTransition (nextData, optAction) -> 
               let action = defaultArg optAction State.emptyTransitionHandler
               // Note that for a self-transition, we transition to the current state for the state machine, not the 
               // handling state. Perhaps that is slightly arbitrary, but I believe that is the most semantically 
               // consistent behavior.
               return struct (msgResult, State(originalState), nextData, action)
            | InternalTransition nextData -> 
               return struct (msgResult, Internal, nextData, State.emptyTransitionHandler)
            | MessageResult.Stop optReason ->
               let terminalState = Terminal(machineCtx.StateTree.Root, (StateId state.Name), optReason)
               return struct (msgResult, State(terminalState), msgCtx.Data, emptyTransitionHandler)
            | Unhandled ->
               match State.parent state with
               | Some(parent) -> 
                  // Let parent state try and handle the message
                  return! handleMessageAcc msgCtx parent
               | None -> 
                  // No more parents available, so just stay in current state
                  return struct (msgResult, Internal, msgCtx.Data, State.emptyTransitionHandler)
            | MessageResult.InvalidMessage(_) ->
               // A state has indicated the message was not appropriate, so just stay in current state.
               return struct (msgResult, Internal, msgCtx.Data, State.emptyTransitionHandler)
         }
      handleMessageAcc { Message=message; Data=machineCtx.Data} machineCtx.State


   // Creates an action that is the composition of the various actions (exiting, transition, entering, etc.) that must
   // be invoked when transitioning between the specified states. Returns the states to be exited, the states to be
   // entered, and the composite action.
   let private buildTransition 
      (machineCtx:StateMachineContext<'D,'M>) 
      (targetState:TransitionTarget<'D,'M>) 
      (transitionAction: TransitionHandler<'D,'M>) =

      match targetState with
      | Internal ->
         // Internal transition, but we still need to invoke the provided transitionAction.
         let compositeAction transCtx = async {
            let! nextData = runTransitionHandler transitionAction transCtx
            let nextTransCtx  = { transCtx with TargetData = nextData } 
            return nextTransCtx 
         }
         List.empty, List.empty, compositeAction
      | State(nextState) ->
         let state = machineCtx.State
         let struct (exitingStates, lca, enteringStates) = statePath state nextState
         let exitingHandler = exitingStates |> List.map onExitWithHandlingState |> composeHandlers
         let enteringHandler = enteringStates |> List.map onEnterWithHandlingState |> composeHandlers
         let transitionAtLcaHandler = transitionAction |> withTransContextTransform (withHandlingState lca)
         let transitionHandler = composeHandlers [exitingHandler; transitionAtLcaHandler; enteringHandler]
         let compositeAction transCtx = async {
            let! nextData = runTransitionHandler transitionHandler transCtx
            let nextTransCtx  = { transCtx with TargetData = nextData } 
            return! enterInitialState false machineCtx.StateTree nextTransCtx 
         } 
         exitingStates, enteringStates, compositeAction



   // Returns an async that transitions between the previous and next states, performing all relevant actions (exit, 
   // transition, and enter actions). Yields the states that were exited, the states that were entered, and the final 
   // transition context.
   let private doTransition 
      (machineCtx:StateMachineContext<'D,'M>) 
      (nextData: 'D)
      (nextState: TransitionTarget<'D,'M>)
      (transitionAction: TransitionHandler<'D,'M>) = 
      async {
         // Build a function that encapsulates the chain of functions that need to be called during the 
         // transition to the new state
         let exiting, entering, transition = buildTransition machineCtx nextState transitionAction

         // Invoke the transition function, which yields the final context and state
         let! transCtx = transition (mkTransitionContext machineCtx.Data machineCtx.State nextData nextState machineCtx.State)
         // TODO: is this overkill?
         ensureRoot transCtx.TargetState machineCtx.StateTree
         return struct (exiting, entering, transCtx)
      }


   /// Yields a new state machine context resulting from entering the specified initial state (or root state if not 
   /// provided) with the specified initial data.
   let initializeContext 
      (stateTree: StateTree<'D,'M>) 
      (initialData:'D) 
      (initialStateRef: option<StateId>) : Async<StateMachineContext<'D,'M>> = 
      async { 
         let _initialStateRef = defaultArg initialStateRef (StateId stateTree.Root.Name) 
         let initialState = stateTree |> StateTree.findState _initialStateRef 

         // Descend into the initial state, if the state machine was initialized with a composite state.  We're 
         // starting from scratch, so descend from the root state.
         let transCtx = mkTransitionContext initialData stateTree.Root initialData (TransitionTarget.State(initialState)) initialState 
         let! transCtx = enterInitialState true stateTree transCtx 
         // TODO: is this overkill?
         ensureRoot transCtx.TargetState stateTree
         
         return { State = transCtx.TargetState; Data = transCtx.TargetData; StateTree = stateTree }   
      }


   /// <summary> 
   /// Yields the result of transitionining the specified state machine context to a stopped (terminal) state, 
   /// optionally providing a reason the machine is being stopped.
   /// </summary> 
   /// <exception cref="System.ArgumentException">If the context is already in a terminal state.</exception> 
   let stop 
      (smContext: StateMachineContext<'D,'M>) 
      (reason: option<StopReason>) : Async<StateMachineContext<'D,'M>> = 
      async {
         match smContext.State with
         | Terminal(_) ->
            raise <| invalidArg "smContext" "smContext is already in a terminal state."
            return smContext
         | _ ->
            // Transition to terminal state, so that current state is exited before state machine is stopped. 
            let terminalState = Terminal(smContext.StateTree.Root, StateId (smContext.State.Name), reason) 
            let! struct (_, _, transCtx) = doTransition smContext smContext.Data (State(terminalState)) State.emptyTransitionHandler
            return { smContext with State = transCtx.TargetState; Data = transCtx.TargetData }
      }


   /// Yields the result of processing the message within the specified machine context.
   let processMessage (message: 'M) (smContext:StateMachineContext<'D,'M>) : Async<MessageProcessed<'D,'M>> = 
      async {
         // Let the current state handle the message
         let! struct (msgResult, nextState, nextData, transitionAction) = handleMessage message smContext
                    
         // Perform the transition to the new state
         let! struct (exited, entered, transCtx) = doTransition smContext nextData nextState transitionAction

         // Return record describing how the message was handled
         let nextSmCtx = { smContext with State = transCtx.TargetState; Data = transCtx.TargetData }
         return mkMessageProcessed msgResult message smContext nextSmCtx exited entered
      }