module FunctionalReactiveProgramming

open Xunit
open Swensen.Unquote

[<Fact>]
let ``Basic FRP using built-in stuff like Events, IObservables and the Observable module`` () = 
    let stream = new Event<string>()
    let source = stream.Publish

    let mutable observed = None
    let handler event = observed <- Some event

    source |> Observable.add handler

    stream.Trigger "some event"

    test <@ Some "some event" = observed @>

[<Fact>]
let ``Can combine streams using merge`` () =
    let first = new Event<string>()
    let second = new Event<string>()

    let sb = new System.Text.StringBuilder()
    let handler (event : string) = sb.Append event |> ignore

    let combined = Observable.merge first.Publish second.Publish
    combined |> Observable.add handler
         
    first.Trigger "a"
    second.Trigger "b"

    test <@ "ab" = sb.ToString() @>

[<Fact>]
let ``Can fold over streams using scan``() =
    let stream = new Event<int>()
    
    let mutable sum = 0
    let listener event = sum <- event
    stream.Publish
    |> Observable.scan (+) 0
    |> Observable.add listener

    stream.Trigger 2
    stream.Trigger 3

    test <@ 5 = sum @>