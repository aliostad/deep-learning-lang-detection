namespace Wj.Async

open System

module Supervisor =
  // ISupervisor functions
  val inline dispatcher : ISupervisor -> IDispatcher
  val inline parent : ISupervisor -> ISupervisor option
  val inline name : ISupervisor -> string
  val inline detach : ISupervisor -> unit
  val inline sendException : ISupervisor -> ex : exn -> unit
  val inline uponException : ISupervisor -> handler : (exn -> unit) -> unit
  val inline uponException' : ISupervisor -> supervisedHandler : exn SupervisedCallback -> unit
  val inline run : ISupervisor -> f : (unit -> 'a) -> 'a

  val current : unit -> ISupervisor
  val create : unit -> ISupervisor
  val createNamed : name : string -> ISupervisor

  val getExceptionDSeq : ISupervisor -> exn DeferredSeq.T

  val supervise
    : f : (unit -> 'a IDeferred)
    -> observer : (exn -> unit)
    -> 'a IDeferred

  module AfterDetermined =
    type T = Raise | Log | Ignore

  val tryWith
    : f : (unit -> 'a IDeferred)
    -> handler : (exn -> 'a IDeferred)
    -> afterDetermined : AfterDetermined.T
    -> 'a IDeferred

  val tryFinally
    : f : (unit -> 'a IDeferred)
    -> finalizer : (unit -> unit IDeferred)
    -> 'a IDeferred
