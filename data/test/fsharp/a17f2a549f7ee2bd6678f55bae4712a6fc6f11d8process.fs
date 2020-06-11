module Test.``process``

open node
open Xunit
open FsUnit.Xunit

type ``Given a process`` ()=

    [<Fact>]
    let ``cwd() returns the working directory`` ()=
        proc.cwd |> should equal System.Environment.CurrentDirectory

    [<Fact>]
    let ``nextTick(f) fires f only on the next tick`` ()=
        let callCount = ref 0
        let handler = fun () -> callCount := !callCount + 1
        proc.nextTick handler
        !callCount |> should equal 0
        node.tick()
        node.tick()
        node.tick()
        !callCount |> should equal 1

    [<Fact>]
    let ``the end event fires when the event loop exits`` ()=
        let eventFired = ref false

        proc.addListener("exit", fun data ->
            eventFired := true
        )

        node.start( fun () ->
            node.stop()
        )     

        node.tick()
        !eventFired |> should equal true