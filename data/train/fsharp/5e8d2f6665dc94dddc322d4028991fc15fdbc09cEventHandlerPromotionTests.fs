namespace AutoFluent.Tests

open System
open NUnit.Framework
open FsUnit
open AutoFluent.Syntax

type Promoted() = 
    class end

type EventHandlerWithoutSender = 
    delegate of
        xx:obj * e:EventArgs -> unit

type CustomEventHandlerWithSender = 
    delegate of
        sender:obj * e:EventArgs -> unit

type CustomEventHandlerWithTypedSender = 
    delegate of
        sender:string * e:EventArgs -> unit

type CustomEventHandlerWithSenderAndReturnValue = 
    delegate of
        sender:string * e:EventArgs -> string

[<TestFixture>]
type EventHandlerPromotionTests() = 

    let promotedTypeName = typeName (typeof<Promoted>)

    [<Test>]
    member this.promotesEventHandler() = 
        typeof<EventHandler>
        |> tryPromoteEventHandler promotedTypeName
        |> should equal (Some (typeName typeof<Action<Promoted, EventArgs>>))

    [<Test>]
    member this.promotesTypedEventHandler() = 
        typeof<EventHandler<string>>
        |> tryPromoteEventHandler promotedTypeName
        |> should equal (Some (typeName typeof<Action<Promoted, string>>))

    [<Test>]
    member this.doesNotPromoteEventHandlerWithoutSender() = 
        typeof<EventHandlerWithoutSender>
        |> tryPromoteEventHandler promotedTypeName
        |> should equal None

    [<Test>]
    member this.promotesCustomEventHandlerWithSender() = 
        typeof<CustomEventHandlerWithSender>
        |> tryPromoteEventHandler promotedTypeName
        |> should equal (Some (typeName typeof<Action<Promoted, EventArgs>>))

    [<Test>]
    member this.doesNotPromoteCustomEventHandlerWithSenderAndReturnValue() = 
        typeof<CustomEventHandlerWithSenderAndReturnValue>
        |> tryPromoteEventHandler promotedTypeName
        |> should equal None

    [<Test>]
    member this.doesNotPromoteEventHandlerWithTypedSender() = 
        typeof<CustomEventHandlerWithTypedSender>
        |> tryPromoteEventHandler promotedTypeName
        |> should equal None

    [<Test>]
    member this.doesNotPromoteNonDelegate() = 
        typeof<string>
        |> tryPromoteEventHandler promotedTypeName
        |> should equal None
        
