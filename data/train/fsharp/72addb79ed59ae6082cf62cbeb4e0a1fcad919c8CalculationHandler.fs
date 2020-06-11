namespace Arcadia

open System
open System.Collections.Generic
open System.Threading

[<Sealed>]
/// handles calculation state for a CalculationEngine
type CalculationHandler() as this = 
    let changed = new Event<EventHandler, EventArgs>()
    let automatic = ref false

    let mutable cts = new CancellationTokenSource()

    member this.Reset() =
        cts <- new CancellationTokenSource()        
        
    member this.Automatic 
        with get () = !automatic
        and set v = 
            automatic := v
            this.Reset()
            changed.Trigger(this, EventArgs.Empty)
    
    member this.Cancel() = cts.Cancel()
    
    [<CLIEvent>]
    member this.Changed = changed.Publish
    
    interface ICalculationHandler with
        
        member I.Automatic 
            with get () = this.Automatic
            and set v = this.Automatic <- v
        
        [<CLIEvent>]
        member I.Changed = this.Changed
        
        member I.Cancel() = this.Cancel()
        
        member I.CancellationToken with get() = cts.Token

        member I.Reset() = this.Reset()