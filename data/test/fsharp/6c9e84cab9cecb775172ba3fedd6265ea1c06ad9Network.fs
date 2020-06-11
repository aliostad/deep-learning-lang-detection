module AkkaMUD.Network

open System.Text
open System.Net
open Akka.FSharp
open Akka.IO
open World

let handler world connection (mailbox: Actor<obj>) =  
    let rec loop connection = actor {
        let! msg = mailbox.Receive()

        match msg with
        | :? Tcp.Received as received ->
            let data = (Encoding.ASCII.GetString (received.Data.ToArray())).Trim().Split([|' '|], 2)

            match data with
            | [| "say"; text |] ->
                world <! Send (text.Trim())

            | [| "quit" |] ->
                world <! Leave mailbox.Self
                mailbox.Context.Stop mailbox.Self

            | _ ->
                connection <! Tcp.Write.Create (ByteString.FromString "Invalid request.\n")
    
        | :? Tcp.ConnectionClosed as closed ->
            world <! Leave mailbox.Self
            mailbox.Context.Stop mailbox.Self

        | :? string as response ->
            connection <! Tcp.Write.Create (ByteString.FromString (response + "\n"))

        | _ -> mailbox.Unhandled()

        return! loop connection
    }

    world <! Join mailbox.Self
    loop connection

let server world (mailbox: Actor<obj>) =
    let rec loop() = actor {
        let! msg = mailbox.Receive()
        let sender = mailbox.Sender()
        
        match msg with
        | :? Tcp.Bound as bound ->
            printf "Listening on %O\n" bound.LocalAddress

        | :? Tcp.Connected as connected -> 
            printf "%O connected to the server\n" connected.RemoteAddress
            let handlerName = "handler_" + connected.RemoteAddress.ToString().Replace("[", "").Replace("]", "")
            let handlerRef = spawn mailbox handlerName (handler world sender)
            sender <! Tcp.Register handlerRef

        | _ -> mailbox.Unhandled()

        return! loop()
    }

    mailbox.Context.System.Tcp() <! Tcp.Bind(mailbox.Self, IPEndPoint(IPAddress.Any, 9090))
    loop()