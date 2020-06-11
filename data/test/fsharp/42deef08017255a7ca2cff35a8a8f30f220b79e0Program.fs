module Program

open System
open Akka
open Akka.Actor
open Akka.FSharp

[<AutoOpen>]
module Types = 

    type Handler<'TData, 'TMessage> = 'TData -> 'TMessage -> Instruction<'TData, 'TMessage>

    and Instruction<'TData, 'TMessage> = 
        | Continue of 'TData
        | Become of ('TData * Handler<'TData, 'TMessage>)
        | Unhandled
        | Stop

[<AutoOpen>]
module StatefulActor = 

    let statefulActorOf handlers initialData (mailbox : Actor<_>) = 

        let rec run data handler = actor {

            let! message = mailbox.Receive ()
                
            //Process the message
            let next, handled = 
                match (handler data message) with
                | Continue data' -> Some (data', handler), true
                | Become (data', handler') -> Some (data', handler'), true
                | Unhandled -> Some (data, handler), false
                | Stop -> None, true
                
            //Report unhandled messages
            if (not handled) then
                mailbox.Unhandled (message)

            //Continue or exit the loop
            match next with
            | None -> 
                mailbox.Context.Stop (mailbox.Self)
                return ()

            | Some (data', handler') ->
                return! (run data' handler')
        }

        run initialData (List.head handlers)

[<RequireQualifiedAccess>]
module Example = 

    [<AutoOpen>]
    module private Helpers = 

        let concat (values : String list) = String.Join (",", values)

    type Message = 
        | StartCollecting of Int32
        | StopCollecting
        | Collected of String

    let initialData = (0, [])

    let rec private waiting _ = function
        | StartCollecting count -> 

            printfn "Starting collection"

            Become ((count, []), collecting)

        | _ -> Unhandled

    and private collecting (count, values) = 

        let stopCollecting () = 
            Become (initialData, waiting)
            //Or stop
            //Stop
    
        function
        | Collected value ->

            let values' = value :: values

            if (List.length values') = count then

                printfn "Finished collecting (%u/%u): %s" 
                <| count 
                <| count 
                <| (concat values')

                stopCollecting () 

            else
                Continue (count, values')

        | StopCollecting -> 

            printfn "Stopping collecting (%u/%u): %s" 
            <| (List.length values) 
            <| count 
            <| (concat values)
                
            stopCollecting () 

        | _ -> Unhandled

    let handlers = [ waiting; collecting; ]

[<EntryPoint>]
let main _ = 
    
    let system = ActorSystem.Create ("ExampleSystem")
    
    let actor = 
        spawn system "ExampleActor" (statefulActorOf Example.handlers Example.initialData)

    actor.Tell (Example.Collected "Hello, World (0)") //Unhandled
    actor.Tell (Example.StartCollecting 3)
    actor.Tell (Example.Collected "Hello, World (1)")
    actor.Tell (Example.Collected "Hello, World (2)")
    actor.Tell (Example.Collected "Hello, World (3)")
    actor.Tell (Example.Collected "Hello, World (4)") //Unhandled (or dead letter if actor stopped)

    Console.ReadLine ()
    |> ignore

    system.Shutdown ()

    0 // return an integer exit code

    