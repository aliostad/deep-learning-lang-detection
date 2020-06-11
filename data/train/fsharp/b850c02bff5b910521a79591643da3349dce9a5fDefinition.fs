namespace Strat.StateMachine.Definition

open System
open System.Collections.Generic
open Strat.StateMachine


/// Defines functions for defining states and state trees in a functional expression-based style.
[<CompilationRepresentation(CompilationRepresentationFlags.ModuleSuffix)>]
module StateTree =

   /// Describes the type of a child state
   type ChildStateType = InteriorChild = 1 | LeafChild = 2


   /// Describes a function that, given a parent state and state tree, will create a new child state, and an updated 
   /// state tree.
   type CreateChildState<'D,'M> = 
      | CreateChild of 
         ChildType:ChildStateType * 
         Creator: (Lazy<State<'D,'M>> * StateTree<'D,'M> -> Lazy<State<'D,'M>> * StateTree<'D,'M>)


   /// Throws if the specified name is already in the map.
   let private ensureUniqueName name map = 
      if map |> Map.containsKey name then 
         invalidArg "name" (sprintf "A state with name %A has already been defined" name)


   /// Defines functions for defining the initial transition funcion for a state.
   type Start private () = 
      /// Returns an InitialTransition that enters the specified child state when an intermediate state is entered.
      static member With( stateName: StateId ) : InitialTransition<'D> = 
         InitialTransition.Sync(fun ctx -> struct (ctx, stateName))


   /// Defines functions for defining the handler functions for a state.
   type Handle private() = 
      /// Returns an StateHandler with the specified handler functions. An empty no-op version of a handler will be 
      /// included if any handlers are not provided.
      static member With
         ( ?onMessage: MessageHandler<'D,'M>,
           ?onEnter: TransitionHandler<'D,'M>,
           ?onExit: TransitionHandler<'D,'M> ) : StateHandler<'D,'M> =
         { OnEnter = defaultArg onEnter State.emptyTransitionHandler
           OnMessage = defaultArg onMessage State.emptyMessageHandler
           OnExit = defaultArg onExit State.emptyTransitionHandler }


   /// Defines a leaf state in a state tree that processes messages using the specified handler functions. 
   let leaf (name: StateId) (handler:StateHandler<'D,'M>) : CreateChildState<'D,'M> = 
      if isNull (name :> obj) then nullArg "name"
      CreateChild (ChildStateType.LeafChild, fun (parent,tree) -> 
         let lazyState = lazy (Leaf(name, parent.Value, handler))
         ensureUniqueName name tree.States
         lazyState, { tree with States = tree.States |> Map.add name lazyState })

 
   /// Defines an interior state in a state tree that processes messages using the specified handler handler functions.
   let interior  
      (name: StateId) 
      (initialTransition: InitialTransition<'D>) 
      (handler: StateHandler<'D,'M>)
      (childStates: seq<CreateChildState<'D,'M>>) : CreateChildState<'D,'M> = 

      if isNull (name :> obj) then nullArg "name"
      CreateChild (ChildStateType.InteriorChild, fun (parent,tree) -> 
         let lazyState = lazy (State.Interior (name, parent.Value, handler, initialTransition))
         let _, tree = 
            childStates 
            |> Seq.fold (fun (children,tree) (CreateChild(_, createChild)) -> 
               let lazyChild, tree = createChild (lazyState, tree)
               lazyChild::children, tree) (List.empty, tree)
         ensureUniqueName name tree.States
         lazyState, { tree with States = tree.States |> Map.add name lazyState })


   /// Constructs a new state tree with rooted at a state with the specified name, initial transition, state handler 
   /// handlers, and child states. 
   let fromRoot 
      (rootStateName: StateId) 
      (initialTransition: InitialTransition<'D>) 
      (handler: StateHandler<'D,'M>)
      (childStates: seq<CreateChildState<'D,'M>>) : StateTree<'D,'M> =

      if isNull (rootStateName :> obj) then nullArg "rootStateName"
      let root = Root (rootStateName, handler, initialTransition)
      let lazyRoot = lazy root
      let _, tree = 
         childStates 
         |> Seq.fold (fun (children,map) (CreateChild(_, createChild)) -> 
            let lazyChild, tree = createChild (lazyRoot, map)
            lazyChild::children, tree
          ) (List.empty, { Root = root; States = Map.empty })
      ensureUniqueName rootStateName tree.States
      { tree with States = tree.States |> Map.add rootStateName lazyRoot }


   /// Constructs a new 'flat' state tree with a default 'no-op' root state, serving as a parent for the specified set
   /// of leaf states. The resulting tree effectively will behave as a 'traditional' state machine (that is, 
   /// non-hierarchical) 
   let fromLeaves (initialStateName: StateId) (states: seq<CreateChildState<'D,'M>>) : StateTree<'D,'M> =
      let allLeaves = states |> Seq.forall (fun (CreateChild(t, _)) -> t = ChildStateType.LeafChild)
      if not allLeaves then
         raise <| new ArgumentException("Only Leaf child states may be included", "states")
      let rootName = StateId "StateList-RootState"
      fromRoot rootName (Start.With initialStateName) State.emptyHandler states


   /// Updates the state handler of the specified state by applying the specfified function, and returns an updated
   /// state tree. The new handler should invoke the original handler as part of its execution.
   let wrapHandler stateRef (wrap: StateHandler<_,_> -> StateHandler<_,_>) stateTree : StateTree<_,_> = 
      let lazyState = stateTree |> StateTree.findLazyState stateRef
      let newLazyState = lazy (lazyState.Value |> State.mapHandlers wrap)
      { stateTree with States = stateTree.States |> Map.add stateRef newLazyState } 


   /// Updates the OnEnter handler of the specified state by applying the specfified function, and returns an updated
   /// state tree. The new handler should invoke the original handler as part of its execution.
   let wrapOnEnter stateRef (wrap: TransitionHandler<'D,'M> -> TransitionHandler<'D,'M>) stateTree : StateTree<'D,'M> =
      stateTree |> wrapHandler stateRef (fun h -> { h with OnEnter = wrap h.OnEnter })


   /// Updates the OnExit handler of the specified state by applying the specfified function, and returns an updated
   /// state tree. The new handler should invoke the original handler as part of its execution.
   let wrapOnExit stateRef stateTree (wrap: TransitionHandler<'D,'M> -> TransitionHandler<'D,'M>) : StateTree<'D,'M> =
      stateTree |> wrapHandler stateRef (fun h -> { h with OnExit = wrap h.OnExit })
