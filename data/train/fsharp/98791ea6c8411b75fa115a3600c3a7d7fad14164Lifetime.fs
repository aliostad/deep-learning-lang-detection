/// A module to manage object lifetimes.
///
/// The basic assumption is that "inner" lifetime are docked to "outer" lifetime scopes and
/// so their lifetime is combined into one handle that refers to the "inner" instace. When
/// This handle is disposed, the "inner" lifetime is disposed before the "outer" instance. 
/// Construction is from "outside" to "inside". Destruction is always the other way around.
/// This can be used with `use` construct in the following way given Outer() and Inner() return
/// IDisposable instances:
///
/// use outer = Outer() |> Lifetime.liftDisposable
/// use inner = Inner() |> Lifetime.liftDisposable |> Lifetime.dock outer
/// [initialization code]
/// /*return*/ inner |> Lifetime.detach
///
/// Note that `outer` and `inner` are lifetime handles. 
/// To access the instances of outer or inner, ".instance" has to be used.
///
/// Also note that Lifetime methods must only be used in the construction phase of a Lifetime
/// container, because they use mutable variables.
[<RequireQualifiedAccess>]
module FunToolbox.Lifetime

open System

type 't instance = 't * (unit -> unit)

type 't handle = private {
    // this does not need to be thread-safe owner changes should happen while
    // instances are being constructed!
    mutable _Instance: 't instance
} with
    interface IDisposable with
        member this.Dispose() = 
            this.Dispose()
    member this.Dispose() =
        this.Destructor()

    member this.Instance = 
        this._Instance |> fst
    member this.Destructor = 
        this._Instance |> snd

/// Returns a clone of the given handle and removes the destructor from the original.
let detach (handle: 't handle) : 't handle = 
    let r = { _Instance = handle._Instance }
    // instance_ = handle.instance, handle.destructor }
    handle._Instance <- handle.Instance, id
    r

/// Embed the lifetime of an inner instance to that of an outer one.
/// The outer and inner handles are detached and the return value contains a
/// handle to the inner instance that destructs the inner instance before the outer.
let dock (outer: 'o handle) (inner: 'i handle) = 
    let outer = detach outer
    let inner = detach inner
    { _Instance = inner.Instance, fun() -> inner.Dispose(); outer.Dispose() }
        
/// Convert a instance and a destructor pair to a lifetime handle.
let lift (instance, destructor) =  { _Instance = instance, destructor }

/// Convert a IDisposable instance to a lifetime handle.
let liftDisposable (instance: 't when 't :> IDisposable) =
    { _Instance = instance, fun() -> instance.Dispose()}

/// Detaches the handle and returns a new handle with the changed instance and the of 
/// handle passed in.
let map (f: 't -> 'i) (handle: 't handle) : 'i handle =
    let handle = detach handle
    (f handle.Instance, handle.Destructor)
    |> lift

