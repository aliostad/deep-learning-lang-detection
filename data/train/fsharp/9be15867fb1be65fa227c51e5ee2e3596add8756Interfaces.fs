namespace Arcadia

open System
open System.Collections.Generic
open System.Collections.ObjectModel
open System.ComponentModel
open System.Threading

/// the status of InputNodes and OutputNodes
type NodeStatus =
    | Uninitialized = 0
    | Dirty = 1
    | Processing = 2
    | Cancelled = 3
    | Error = 4
    | Valid = 5

/// event arguments for an objects Changed event
type ChangedEventArgs(status:NodeStatus) =
    inherit EventArgs()
    member this.Status = status

/// event handler for an objects Changed event
type ChangedEventHandler = delegate of sender:obj * e:ChangedEventArgs -> unit

type ListEventArgs(value : int) = 
    inherit EventArgs()
    member this.Value = value

type ListEventHandler = delegate of sender:obj * e:ListEventArgs -> unit


/// node messages used in internal MailboxProcessor
type internal Message = 
    | Cancelled
    | Changed
    | Error
    | Eval of AsyncReplyChannel<NodeStatus * obj>
    | Processed
    | AutoCalculation of bool

/// interface of CalculationHandler
type ICalculationHandler = 
    abstract CancellationToken : CancellationToken with get
    abstract Automatic : bool with get, set
    [<CLIEvent>] 
    abstract Changed : IEvent<EventHandler, EventArgs> with get
    abstract Cancel : unit -> unit
    abstract Reset : unit -> unit

type IEquate<'T> = 
    abstract EqualityComparer : ('T -> 'T -> bool) with get, set
    
type IGetable = 
    [<CLIEvent>] abstract Changed : IEvent<ChangedEventHandler, ChangedEventArgs>
    abstract OnChanged : NodeStatus -> unit
    abstract Evaluate : unit -> Async<NodeStatus * obj>
    abstract Id : string

type IGetable<'T> = 
    inherit IGetable
    abstract Value : 'T with get

type IComputed<'T> = 
    abstract Dispose : unit -> unit
    abstract Value : 'T with get

type ISetable<'T> = 
    inherit IGetable<'T>
    abstract Value : 'T with set


type ISetableList<'T> = 
    inherit IGetable<IList<'T>>
    inherit IList<'T>   
    [<CLIEvent>] abstract Added : IEvent<ListEventHandler, ListEventArgs> with get
    [<CLIEvent>] abstract Updated : IEvent<ListEventHandler, ListEventArgs> with get
    [<CLIEvent>] abstract Removed : IEvent<ListEventHandler, ListEventArgs> with get   
    [<CLIEvent>] abstract Cleared : IEvent<EventHandler, EventArgs> with get


type ICanThrottle<'T> =
    abstract SetThrottler : Func<Action,Action> ->  'T

/// Intended for use as a singleton, to allow broadcasting events to the
/// listeners at the top of the stack, per-thread
type ListenerStack<'T>() = 
    let Stack = new ThreadLocal<_>(fun () -> new Stack<Action<'T>>())
    member this.Push(listener : Action<'T>) = Stack.Value.Push(listener)
    member this.Pop() = Stack.Value.Pop()
    member this.Notify(obs : 'T) = if Stack.Value.Count <> 0 then (Stack.Value.Peek()).Invoke(obs)

module ComputedStack = 
    let EmptySubscriptions = new HashSet<IGetable>()
    let Listeners = new ListenerStack<IGetable>()

/// untyped interface of InputNode and OutputNode
type INode = 
    abstract Calculation : ICalculationHandler with get
    abstract Evaluate : unit -> Async<NodeStatus * obj>
    abstract UntypedValue : obj with get, set
    abstract Id : string with get
    abstract Status : NodeStatus with get
    abstract AsyncCalculate : unit -> unit
    abstract IsDirty : bool with get
    abstract GetDependentNodes : unit -> INode []
    abstract IsInput : bool with get
    abstract IsProcessing : bool with get
    [<CLIEvent>]
    abstract Changed : IEvent<ChangedEventHandler, ChangedEventArgs> with get

/// typed interface for InputNode and OutputNode
type INode<'U> =
    inherit INode
    abstract Value : 'U with get,set

/// interface for CalculationEngine
type ICalculationEngine = 
    inherit INotifyPropertyChanged
    abstract Calculation : ICalculationHandler with get
    abstract Nodes : Collection<INode> with get