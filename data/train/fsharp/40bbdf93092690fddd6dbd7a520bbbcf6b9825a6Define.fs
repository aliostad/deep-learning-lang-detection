namespace FSharp.Control.StateMachine


/// Defines functions for defining states and state trees. 
[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module Define =

   /// Describes a function that, given a parent state and state tree, will create a new child state, and an updated 
   /// state tree.
   type StateDef<'D,'M> = 
      State<'D,'M> * StateTree<'D,'M> -> State<'D,'M> * StateTree<'D,'M>


   // Describes the function that is called when a state handles a message.
   type SyncMessageHandler<'D,'M> = 
      MessageContext<'D,'M> -> MessageResult<'D,'M>


   /// Describes functions that are called when a transition occures between two states. 
   type SyncTransitionHandler<'D,'M> = 
      TransitionContext<'D,'M> -> 'D 


   /// Describes a set of synchronous functions that define the behavior of a state.
   type SyncStateHandler<'D,'M> = {
      OnMessage: SyncMessageHandler<'D,'M>
      OnEnter: SyncTransitionHandler<'D,'M>
      OnExit: SyncTransitionHandler<'D,'M>
   }


   // No-op handler functions
   let unhandledMessage : SyncMessageHandler<'D,'M> = fun _ -> MessageResult.Unhandled
   let unhandledMessageAsync : MessageHandler<'D,'M> = fun _ -> async.Return MessageResult.Unhandled
   let internal emptyTransHandlerAsync : TransitionHandler<'D,'M> = fun transCtx -> async.Return transCtx.TargetData
   let internal emptyTransHandler : SyncTransitionHandler<'D,'M> = fun transCtx -> transCtx.TargetData
   let internal emptyTransAction : TransitionHandler<'D,'M> = fun transCtx -> async.Return transCtx.TargetData
   let internal emptyTransActionAsync : TransitionHandler<'D,'M> = fun transCtx -> async.Return transCtx.TargetData


   /// Converts a synchronous handler function to a MessageHandler<_,_>
   let toMessageHandler (syncHandler: MessageContext<'D,'M> -> MessageResult<'D,'M>) : MessageHandler<'D,'M> =    
      fun msgCtx -> async {
         return syncHandler msgCtx
      }


   /// Converts a synchronous handler function to a TransitionHandler<_,_>
   let toTransitionHandler (syncHandler: SyncTransitionHandler<'D,'M>) : TransitionHandler<'D,'M> =    
      fun transCtx -> async {
         return syncHandler transCtx
      }

      
   /// A StateHandler with no-op handler functions
   let emptyHandlerAsync : StateHandler<_,_> = 
      { OnMessage = unhandledMessageAsync; OnEnter = emptyTransHandlerAsync; OnExit = emptyTransHandlerAsync }


   /// A SyncStateHandler with no-op handler functions
   let emptyHandler : SyncStateHandler<_,_> = 
      { OnMessage = unhandledMessage; OnEnter = emptyTransHandler; OnExit = emptyTransHandler }


   /// Throws if the specified name is already in the map.
   let private ensureUniqueName name map = 
      if map |> Map.containsKey name then 
         invalidArg "name" (sprintf "A state with name %A has already been defined" name)


   /// Adapts a sync state handler to an async one.
   let private toAsyncHandler (handler:SyncStateHandler<'D,'M>) : StateHandler<'D,'M> = 
      { OnMessage = toMessageHandler handler.OnMessage
        OnEnter = toTransitionHandler handler.OnEnter
        OnExit = toTransitionHandler handler.OnExit } 


   /// Defines functions for defining the initial transition funcion for a state.
   type Start private () = 
         
      /// Returns an InitialTransition that enters the specified child state when an intermediate state is entered.
      static member With( stateName: StateName ) : InitialTransition<'D> = 
         fun ctx -> async.Return (ctx, stateName)


   /// Defines functions for creating state handlers.
   type Handle private () = 
         
      /// <summary>
      /// Creates a synchronous state handler that uses the specified functions to define the behavior of the state.
      /// </summary>
      /// <param name="onMessage">Message handling function for the state.</param>
      /// <param name="onEnter">Optional entry function for the state.</param>
      /// <param name="onExit">Optional exit function for the state.</param>
      static member With
         ( onMessage: SyncMessageHandler<'D,'M>, 
           ?onEnter: SyncTransitionHandler<'D,'M>, 
           ?onExit: SyncTransitionHandler<'D,'M> ) : SyncStateHandler<'D,'M> =

         let _onEnter = defaultArg onEnter emptyTransHandler
         let _onExit = defaultArg onExit emptyTransHandler
         { OnMessage = onMessage; OnEnter = _onEnter; OnExit = _onExit}

   
      /// <summary>
      /// Creates a synchronous state handler that delegates message handling to its parent state.
      /// </summary>
      /// <param name="onEnter">Optional entry function for the state.</param>
      /// <param name="onExit">Optional exit function for the state.</param>
      static member With(?onEnter: SyncTransitionHandler<'D,'M>, ?onExit: SyncTransitionHandler<'D,'M> ) =
         Handle.With (unhandledMessage, ?onEnter = onEnter, ?onExit = onExit )


      /// <summary>
      /// Creates an asynchronous state handler that uses the specified functions to define the behavior of the
      /// state.
      /// </summary>
      /// <param name="onMessage">Message handling function for the state.</param>
      /// <param name="onEnter">Optional entry function for the state.</param>
      /// <param name="onExit">Optional exit function for the state.</param>
      static member WithAsync
         ( onMessage: MessageHandler<'D,'M>, 
           ?onEnter: TransitionHandler<'D,'M>, 
           ?onExit: TransitionHandler<'D,'M> ) : StateHandler<'D,'M> =
            
         let _onEnter = defaultArg onEnter emptyTransHandlerAsync
         let _onExit = defaultArg onExit emptyTransHandlerAsync
         { StateHandler.OnMessage = onMessage; OnEnter = _onEnter; OnExit = _onExit}


      /// <summary>
      /// Creates an asynchronous state handler that delegates message handling to its parent state.
      /// </summary>
      /// <param name="onEnter">Optional entry function for the state.</param>
      /// <param name="onExit">Optional exit function for the state.</param>
      static member WithAsync( ?onEnter: TransitionHandler<'D,'M>, ?onExit: TransitionHandler<'D,'M> ) =
         Handle.WithAsync (unhandledMessageAsync, ?onEnter = onEnter, ?onExit = onExit )


   /// Defines a leaf state in a state tree that processes messages using the specified asynchronous handler 
   /// functions. 
   let leafAsync (name: StateName) (handler:StateHandler<'D,'M>) : StateDef<'D,'M> = 
      fun (parent,tree) -> 
         let state = Leaf(name, parent, handler)
         ensureUniqueName name tree.States
         state, { tree with States = tree.States |> Map.add name state }


   /// Defines a leaf state in a state tree that processes messages using the specified synchronous handler 
   /// functions. 
   let leaf (name: StateName) (handler:SyncStateHandler<'D,'M>) : StateDef<'D,'M> = 
      leafAsync name (toAsyncHandler handler)


   /// Defines an intermediate state in a state tree that processes messages using the specified asynchronous handler 
   /// handler functions. 
   let intermediateAsync  
      (name: StateName) 
      (initialTransition: InitialTransition<'D>) 
      (handler: StateHandler<'D,'M>)
      (childStates: seq<StateDef<'D,'M>>) : StateDef<'D,'M> = 

      fun (parent,tree) -> 
         let state = State.Intermediate (name, parent, handler, initialTransition)
         let _, tree = 
            childStates 
            |> Seq.fold (fun (children,tree) stateDef -> 
               let state, tree = stateDef (state,tree)
               state::children, tree) (List.empty, tree)
         ensureUniqueName name tree.States
         state, { tree with States = tree.States |> Map.add name state }


   /// Defines an intermediate state in a state tree that processes messages using the specified synchronous handler 
   /// handler functions. 
   let intermediate 
      (name: StateName) 
      (initialTransition: InitialTransition<'D>) 
      (handler: SyncStateHandler<'D,'M>) 
      (childStates: seq<StateDef<'D,'M>>) : StateDef<'D,'M> =

      intermediateAsync name initialTransition (toAsyncHandler handler) childStates


   /// Constructs a new state tree with rooted at a state with the specified name, initial transition, asynchronous 
   /// handlers, and child states. 
   let rootAsync 
      (rootStateName: StateName) 
      (initialTransition: InitialTransition<'D>) 
      (handler: StateHandler<'D,'M>)
      (childStates: seq<StateDef<'D,'M>>) : StateTree<'D,'M> =

      let rootState = State.Root (rootStateName, handler, initialTransition)
      let _, tree = 
         childStates 
         |> Seq.fold (fun (children,map) stateDef -> 
            let state, tree = stateDef (rootState,map)
            state::children, tree) (List.empty, { Root = rootState; States = Map.empty })
      ensureUniqueName rootStateName tree.States
      { tree with States = tree.States |> Map.add rootStateName rootState }


   /// Constructs a new state tree with rooted at a state with the specified name, initial transition, handlers, and
   /// child states.
   let root 
      (rootStateName: StateName) 
      (initialTransition: InitialTransition<'D>) 
      (handler: SyncStateHandler<'D,'M>) 
      (childStates: seq<StateDef<'D,'M>>) : StateTree<'D,'M> = 
      
      rootAsync rootStateName initialTransition (toAsyncHandler handler) childStates 


   /// Constructs a new state tree with a default 'no-op' root state, serving as a parent for the specified set of
   /// child states.
   let rootWithDefaults (initialStateName: StateName) (childStates: seq<StateDef<'D,'M>>) : StateTree<'D,'M> =
      let rootName = StateName "flatRoot"
      root rootName (Start.With initialStateName) emptyHandler childStates