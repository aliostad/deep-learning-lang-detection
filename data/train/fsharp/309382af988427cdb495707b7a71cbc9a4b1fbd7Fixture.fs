namespace Strat.StateMachine.Test

open System
open System.Threading;
open Strat.StateMachine
open Strat.StateMachine.State
open Strat.StateMachine.Definition


// State tree for unit testing.
module TransitionsSm = 

   type Message = | M1 | M2 | SetContext of Data | Throw of Exception | Stop of Reason:string * Code:  int | Unknown

   and Data = {
      Tick: int
      Entered: List<StateId*int*TransitionContext<Data,Message>>
      Exited: List<StateId*int*TransitionContext<Data,Message>>
      B1ToB2TransitionTick: option<int>
   }

   // Shortcut aliases
   and TransitionContext = TransitionContext<Data, Message>
   type StateHandler = StateHandler<Data, Message>
   type State = State<Data, Message>
   type MessageContext = MessageContext<Data, Message>    

   // Names of the states in the state tree
   let stateRoot = StateId "root"
   let stateA = StateId "A"
   let stateA1 = StateId "A1"
   let stateA2 = StateId "A2"
   let stateA2A = StateId "A2A"
   let stateB = StateId "B"
   let stateB1 = StateId "B1"
   let stateB2 = StateId "B2"
   let stateC = StateId "C"
   let stateC1 = StateId "C1"
   let stateC2 = StateId "C2"
   let stateErrorOnEnter = StateId "ErrorOnEnter"
   let stateSleepOnEnter = StateId "SleepOnEnter"
   let stateSleepOnExit = StateId "SleepOnExit"

   let stateErrorOnEnterMessage = "Thrown when entering B3"
   let stateSleepOnEnterExitSleepInSeconds = 0.1
   
   // Handler functions
   let onEnter (transCtx: TransitionContext) =
      // Deliberate conditions for testing purposes      
      if transCtx.HandlingState.Id = stateErrorOnEnter then
         raise <| Exception(stateErrorOnEnterMessage)
      elif transCtx.HandlingState.Id = stateSleepOnEnter then
         Thread.Sleep(TimeSpan.FromSeconds stateSleepOnEnterExitSleepInSeconds)

      let ctx = transCtx.TargetData
      { ctx with Entered = (transCtx.HandlingState.Id, ctx.Tick, transCtx)::ctx.Entered; Tick = ctx.Tick + 1;} 
  
   let onExit (transCtx: TransitionContext) = 
      // Deliberate conditions for testing purposes      
      if transCtx.HandlingState.Id = stateSleepOnExit then
         Thread.Sleep(TimeSpan.FromSeconds stateSleepOnEnterExitSleepInSeconds)

      let ctx = transCtx.TargetData
      { ctx with Exited = (transCtx.HandlingState.Id, ctx.Tick, transCtx)::ctx.Exited; Tick = ctx.Tick + 1} 
   

   let rootHandler (msgCtx:MessageContext) = 
      match msgCtx.Message with
      | Throw(ex) -> raise ex
      | SetContext(ctx) -> msgCtx.Stay(ctx)
      | Stop(reason,code) -> msgCtx.Stop(reason, code)
      | _ -> MessageResult.Unhandled

   let a2aHandler (msgCtx:MessageContext) = 
      match msgCtx.Message with
      | M1 -> msgCtx.GoTo(stateA1)
      | _ -> MessageResult.Unhandled

   let b1Handler (msgCtx:MessageContext) = 
      let b1Tob2TransitionAction (transCtx:TransitionContext) = 
         let ctx = transCtx.TargetData
         { ctx with B1ToB2TransitionTick = Some(ctx.Tick); Tick = ctx.Tick + 1 }
      match msgCtx.Message with
      | M1 -> msgCtx.GoTo(stateB2, action = TransitionHandler.Sync b1Tob2TransitionAction)
      | _ -> MessageResult.Unhandled

   let sleepOnExitHandler  (msgCtx:MessageContext) = 
      match msgCtx.Message with
      | M1 -> msgCtx.GoToSelf()  // This will exit/reenter
      | _ -> MessageResult.Unhandled

   let cHandler (msgCtx:MessageContext) = 
      match msgCtx.Message with
      | M1 -> msgCtx.GoToSelf() 
      | _ -> MessageResult.Unhandled

   let c2Handler (msgCtx:MessageContext) = 
      match msgCtx.Message with
      | M1 -> msgCtx.GoToSelf()
      | _ -> MessageResult.Unhandled

   // Helper module for wiring in common OnEnter/OnExit handlers
   module Handle  = 
      let withDefaults msgHandler : StateHandler<_,_> = 
         { OnMessage = MessageHandler.Sync msgHandler; OnEnter = TransitionHandler.Sync onEnter; OnExit = TransitionHandler.Sync onExit }

      let emptyHandler = 
         (withDefaults (fun _ -> MessageResult.Unhandled))

   // Definition of the state tree.
   open StateTree
   let stateTree = 
      StateTree.fromRoot stateRoot (Start.With stateA) (Handle.withDefaults rootHandler)
         [ interior stateA (Start.With stateA1) Handle.emptyHandler 
            [ leaf stateA1 Handle.emptyHandler
              interior stateA2 (Start.With stateA2A) Handle.emptyHandler
               [ leaf stateA2A (Handle.withDefaults a2aHandler)] ] 
           interior stateB (Start.With stateB1) Handle.emptyHandler
            [ leaf stateB1 (Handle.withDefaults b1Handler)
              leaf stateB2 emptyHandler
              leaf stateErrorOnEnter Handle.emptyHandler
              leaf stateSleepOnEnter Handle.emptyHandler
              leaf stateSleepOnExit (Handle.withDefaults sleepOnExitHandler) ]
           interior stateC (Start.With stateC2) (Handle.withDefaults cHandler) 
            [ leaf stateC1 State.emptyHandler
              leaf stateC2 (Handle.withDefaults c2Handler) ] ]

   let initData : Data = {
      Tick = 1
      Entered = List.empty
      Exited = List.empty
      B1ToB2TransitionTick = None
   }

   // Helper method to initialize state machine context
   let initializeContext initState initData =
      let smContext = StateMachine.initializeContext (stateTree) initData (Some(initState)) |> Async.RunSynchronously 
      // Reset data to make unit testing easier.
      { smContext with Data = initData }

   let newStateMachine initData initState = 
      new StateMachineAgent<Data,Message>(stateTree, initData, initState)

   let private start resetData initData initState = 
      let sm  = newStateMachine initData initState
      sm.Start()
      if resetData then sm.SendMessage(SetContext(initData)) |> ignore
      sm

   // Helper method to create and start a new state machine agent
   let startStateMachine = start false



   
// http://accu.org/index.php/journals/252
module ExampleHsm = 

   // State machine data type
   type Data = {
      Foo: bool
   }

   // State machine message type
   type Message = 
      | SetData of Data | A | B | C | D | E | F | G | H

   // Shortcut aliases
   type State = State<Data, Message>
   type TransitionContext = TransitionContext<Data, Message>
   type MessageContext = MessageContext<Data, Message>

   // Names of the states in the state tree
   let s0 = StateId "S0"
   let s1 = StateId "S1"
   let s11 = StateId "S11"
   let s2 = StateId "S2"
   let s21 = StateId "S21"
   let s211 = StateId "S211"

   // Handler functions
   let s0Handler = MessageHandler.Sync (fun msgCtx -> 
      match msgCtx.Message with
      | SetData(data) -> msgCtx.Stay(data)
      | E -> msgCtx.GoTo(s211)
      | _ -> MessageResult.Unhandled)

   let s1Handler = MessageHandler.Sync (fun msgCtx -> 
      match msgCtx.Message with
      | A -> msgCtx.Stay()
      | B -> msgCtx.GoTo(s11)
      | C -> msgCtx.GoTo(s2)
      | D -> msgCtx.GoTo(s1)
      | F -> msgCtx.GoTo(s211)
      | _ -> MessageResult.Unhandled)

   let s11Handler  = MessageHandler.Sync (fun msgCtx -> 
      match msgCtx.Message with
      | G -> msgCtx.GoTo(s211)
      | H when msgCtx.Data.Foo -> msgCtx.Stay( { msgCtx.Data with Foo = false } ) 
      | _ -> MessageResult.Unhandled)

   let s2Handler  = MessageHandler.Sync (fun msgCtx -> 
      match msgCtx.Message with
      | C -> msgCtx.GoTo(s1)
      | F -> msgCtx.GoTo(s11)
      | _ -> MessageResult.Unhandled)

   let s21Handler  = MessageHandler.Sync (fun msgCtx -> 
      match msgCtx.Message with
      | B -> msgCtx.GoTo(s211)
      | H when not msgCtx.Data.Foo -> msgCtx.GoToSelf( { msgCtx.Data with Foo = true } ) 
      | _ -> MessageResult.Unhandled)

   let s211Handler  = MessageHandler.Sync (fun msgCtx -> 
      match msgCtx.Message with
      | D -> msgCtx.GoTo(s21)
      | G -> msgCtx.GoTo(s0)
      | _ -> MessageResult.Unhandled)


   open StateTree
   // Definition of the state tree.
   let mkStateTree = 
      StateTree.fromRoot s0 (Start.With s1) (Handle.With s0Handler )
         [ interior s1 (Start.With s11) (Handle.With s1Handler)
            [ leaf s11 (Handle.With s11Handler) ]
           interior s2 (Start.With s21) (Handle.With s2Handler)
            [ interior s21 (Start.With s211) (Handle.With s21Handler)
               [ leaf s211 (Handle.With s211Handler) ] ] ]








