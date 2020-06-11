namespace RandomArtsBot.Tests

open FsUnit
open NUnit.Framework
open System.Threading

open RandomArtsBot

module ``Extensions tests`` =
    [<Test>]
    let ``Async.StartProtected should protect an async loop from exceptions`` () = 
        let ranOnce = ref false
        let evt = new ManualResetEvent(false)
        let failTheFirstTime = async {
            if not !ranOnce then
                ranOnce := true
                failwith "boom"
            
            evt.Set() |> ignore
        }

        let exnHandlerCalled = ref 0
        Async.StartProtected 
            (failTheFirstTime, 
             fun _ -> exnHandlerCalled := !exnHandlerCalled + 1)
        
        evt.WaitOne(1000) |> should equal true
        !ranOnce          |> should equal true
        !exnHandlerCalled |> should equal 1

    [<Test>]
    let ``Agent.StartProtected should protect an agent from exceptions`` () =
        let lastN : int option ref = ref None
        let evt = new ManualResetEvent(false)
        let agent = Agent<int>.StartProtected(fun inbox ->
            async {
                let! n = inbox.Receive()
                match n with
                | 4 -> failwith "boom"
                | _ -> 
                    lastN := Some n
                    evt.Set() |> ignore
            })

        agent.Post(4)
        agent.Post(42)

        evt.WaitOne(1000) |> should equal true
        !lastN            |> should equal <| Some 42