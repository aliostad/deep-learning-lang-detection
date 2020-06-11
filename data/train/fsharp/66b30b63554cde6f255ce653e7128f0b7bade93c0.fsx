open System

// [snippet:Simple event for F# use]
/// Counter with F#-only event
type SimpleCounter() =
  let evt = new Event<int>()
  let mutable count = 0
 
  /// Increments the counter and triggers 
  /// event after every 10 increments
  member x.Increment() =
    count <- count + 1
    if count % 10 = 0 then 
      evt.Trigger(count)

  /// Event triggered after every 10 increments
  /// The value carried by the event is 'int'
  member x.IncrementedTenTimes = evt.Publish 
// [/snippet]

// [snippet:.NET event compatible with C#]
/// Derived EventArgs type that carries 'int' values
type IntEventArgs(count:int) = 
  inherit EventArgs()
  member this.Count = count

/// Standard EventHandler delegate for IntEventArgs
type IntEventHandler = delegate of obj * IntEventArgs -> unit

/// Counter with .NET compatible event
type DotNetCounter() =
  let evt = new Event<IntEventHandler, IntEventArgs>()
  let mutable count = 0
 
  /// Increments the counter and triggers 
  /// event after every 10 increments
  member x.Increment() =
    count <- count + 1
    if count % 10 = 0 then 
      evt.Trigger(x, IntEventArgs(count))

  /// Event triggered after every 10 increments
  /// (Creates standard .NET event using IntEventHandler delegate)
  [<CLIEvent>]
  member x.IncrementedTenTimes = evt.Publish 
// [/snippet]