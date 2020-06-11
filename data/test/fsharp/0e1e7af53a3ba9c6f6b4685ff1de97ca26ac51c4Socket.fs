namespace Nata.IO.WebSocket

module Socket =

    open System
    open System.IO
    open System.Threading
    open WebSocket4Net

    open Nata.IO

    type Settings = {
        Host : string
        AutoPingInterval : int option
    }

    type Status =
        | Opened
        | Received of string
        | Closed of exn option

    let connect : Source<Settings,string,unit> =
        function
        | { Host=host; AutoPingInterval=autoPing } ->

            let multicast = new Multicast<Status>()
            let socket = new WebSocket(host)

            match autoPing with
            | None ->
                socket.EnableAutoSendPing <- false
            | Some interval ->
                socket.EnableAutoSendPing <- true
                socket.AutoSendPingInterval <- interval
            
            socket.Opened.AddHandler(fun s e -> multicast.Publish(Opened))
            socket.Closed.AddHandler(fun s e -> multicast.Publish(Closed(None)))
            socket.Error.AddHandler(fun s e -> multicast.Publish(Closed(Some e.Exception)))
            socket.MessageReceived.AddHandler(fun s e -> multicast.Publish(Received(e.Message)))

               
            let initialize =
                new Lazy<unit>((fun () ->
                    let events = multicast.Subscribe()
                    socket.Open()
                    events
                    |> Seq.takeWhile(function Status.Opened -> false | _ -> true)
                    |> Seq.iter ignore),
                    true)

            let write(message:Event<string>) = 
                initialize.Force()
                socket.Send(message |> Event.data)

            let listen() =
                let events = multicast.Subscribe()
                initialize.Force()
                seq {
                    for event in events do
                        match event with
                        | Status.Opened
                        | Status.Closed(None) -> ()
                        | Status.Closed(Some exn) ->
                            raise exn
                        | Status.Received(message) ->
                            yield Event.create message
                }

            [
                Writer <| write

                Subscriber <| listen
            ]