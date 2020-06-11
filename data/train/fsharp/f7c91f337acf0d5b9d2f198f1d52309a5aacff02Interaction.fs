namespace IRTB

module Interaction = 

    open System.Net.Sockets
    open System
    open IRTB.UserMessages

    type InMemoryConnection() = 
        let recieved = new System.Collections.Queue()

        member this.send_message msg = 
            printfn "%A" msg
            recieved.Enqueue msg

        member this.read = "Im a message"


    type SendToUser = {
        send: UserMessage -> unit
    }

    let InMemoryConnectionAPI (connection: InMemoryConnection) = {
        send = connection.send_message;
        read = connection.read
    }

    let create_connection = 
        let connection = InMemoryConnection()
        InMemoryConnectionAPI connection

    type UserMailBox (api: user_communication) = 
        member this.api = api
        member this.box = MailboxProcessor.Start(fun inbox ->
            async { while true do

                        let! (msg : UserMessage) = inbox.Receive()
 
                        api.send msg

                  }
                )

        member this.send msg = this.box.Post msg

    let create_user_communication = 
        let low_level_api = create_connection 
        let box = new UserMailBox(low_level_api)
        box.send

//Code snippets for implementing low level communication

//
//
//    let propogate_events_to_client (client: TcpClient) = async {
//        let stream = client.GetStream()
//        while true do
//            do! stream.
//            do! Async.Sleep 1000.0 // sleep one second
//    }
//
//
//    let rec asyncSendInput (stream : NetworkStream) =
//        async {
//            let input = Console.Read() |> BitConverter.GetBytes
//            input |> Array.iter stream.WriteByte
//            return! asyncSendInput stream
//        }

//
//    let send_message (socket: Socket) (message: string) = 
//        async {
//            System.Text.Encoding.ASCII.GetBytes(message)
//                |> socket.Send
//                |> ignore
//            }