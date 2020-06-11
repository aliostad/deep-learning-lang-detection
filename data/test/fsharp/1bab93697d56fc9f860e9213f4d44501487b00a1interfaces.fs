namespace Pit
    // type alias for major interfaces from the .NET library
    // easy to get all this under the "Pit" namespace itself
    type IDisposable     = System.IDisposable
    type IObservable<'T> = System.IObservable<'T>
    type IObserver<'T>   = System.IObserver<'T>
    type IEnumerable<'T> = System.Collections.Generic.IEnumerable<'T>
    type IEnumerable     = System.Collections.IEnumerable
    type IEnumerator<'T> = System.Collections.Generic.IEnumerator<'T>
    type IEnumerator     = System.Collections.IEnumerator
    type IComparer<'T>   = System.Collections.Generic.IComparer<'T>
    type ICollection<'T> = System.Collections.Generic.ICollection<'T>

(*namespace Pit.FSharp.Control
open Pit
    // These interfaces are only required in Pit JavaScript generation
    type IDelegateEvent<'Delegate when 'Delegate :> System.Delegate> =
        abstract AddHandler: handler:'Delegate -> unit
        abstract RemoveHandler: handler:'Delegate -> unit

    type IEvent<'Delegate,'Args when 'Delegate : delegate<'Args,unit> and 'Delegate :> System.Delegate > =
        inherit IDelegateEvent<'Delegate>
        inherit IObservable<'Args>

    type Handler<'T> =  delegate of sender:obj * args:'T -> unit

    type IEvent<'T> = IEvent<Handler<'T>, 'T>*)