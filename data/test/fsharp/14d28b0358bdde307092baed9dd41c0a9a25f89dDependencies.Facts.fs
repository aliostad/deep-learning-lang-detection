namespace CQRS.EventHandlers.FSharp.Tests

open System
open Xunit
open CQRS.EventHandlers.FSharp
open CQRS.EventHandlers.Tests

module ``Dependencies facts`` = 

    [<Trait (Constants.Category, Constants.FSharp)>]
    type ``Dependencies Decorator HandleEvent facts`` () = 
        inherit Dependencies_Decorator_HandleEvent_Facts ()

        override this.Decorate (handler, versions, check) = 

            let dependencies = 
                Dependencies.Dependency.On<FakeEvent> (versions, check)
                |> Seq.singleton

            Dependencies.Decorator.Decorate (handler, dependencies)