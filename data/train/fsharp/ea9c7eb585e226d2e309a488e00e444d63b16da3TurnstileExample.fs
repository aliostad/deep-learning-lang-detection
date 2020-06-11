namespace FSharp.Control.StateMachine

open Xunit


module TurnstileExample =
   
   type Data = unit

   type Message = 
      | DepositCoin
      | Push
   
   // Shortcut alias
   type MessageContext = MessageContext<Data, Message>

   // Names of the states in the state tree
   let lockedState = StateName "locked"
   let unlockedState = StateName "unlocked"

   // Handler functions
   let lockedHandler (msgCtx:MessageContext) = 
      match msgCtx.Message with
      | DepositCoin -> msgCtx.GoTo unlockedState
      | _ -> Unhandled 

   let unlockedHandler (msgCtx:MessageContext) = 
      match msgCtx.Message with
      | Push -> msgCtx.GoTo lockedState
      | _ -> Unhandled 

   // Definition of the state tree.
   open Define
   let tree = 
      rootWithDefaults lockedState
         [ leaf lockedState (Handle.With lockedHandler)
           leaf unlockedState (Handle.With unlockedHandler) ]


   [<Fact>]
   let DepositCoin_When_Locked_Should_Transition_To_Unlocked()  = 
      use turnstile = StateMachineAgent.startNewAgentIn lockedState tree ()
      let ctx = turnstile.SendMessage DepositCoin
      Assert.Equal( unlockedState, ctx.State.Name)


   [<Fact>]
   let Push_When_Unlocked_Should_Transition_To_Locked()  = 
      use turnstile = StateMachineAgent.startNewAgentIn unlockedState tree ()
      let ctx = turnstile.SendMessage Push
      Assert.Equal( lockedState, ctx.State.Name)