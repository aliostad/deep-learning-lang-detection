namespace FSharpExampleLib

open System

// First lets cover the types

type public ExampleDomainRecord = {
    Field1: string
    Field2: int
    Field3: float
    }

[<CLIMutable>]
type public SerialisableRecord = {
    Field1: string
    Field2: int
    Field3: float
    }

type public ExampleUnion = 
    | One
    | Two of string
    | Three of int
    member x.Match(oneHandler: Func<_>, twoHandler: Func<_, _>, threeHandler: Func<_, _>) =
        match x with
        | One -> oneHandler.Invoke()
        | Two(s) -> twoHandler.Invoke(s)
        | Three(i) -> threeHandler.Invoke(i)
