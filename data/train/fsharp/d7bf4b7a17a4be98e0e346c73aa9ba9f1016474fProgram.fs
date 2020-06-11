open Protocol
open Protocol.MessageHandling
open System.Linq

type Agent<'a> = MailboxProcessor<'a>

type Client = { Id:string; Connection:System.IO.Stream }

type StreamHandlerCommand =
        | StartListening of Client
        | GetBaseStream of AsyncReplyChannel<System.IO.Stream>
        | WriteMessage of obj
        | StopListening
        | Rename of string

type ConnectionHandlerCommand =
    | GetAll of AsyncReplyChannel<Agent<StreamHandlerCommand> list>
    | GetById of string * AsyncReplyChannel<Option<Agent<StreamHandlerCommand>>>
    | AddClient of Option<string> * Agent<StreamHandlerCommand> * System.IO.Stream
    | LoginClient of string * string



(*
        Message handler
*)
let broadcastHandler (clients: Agent<StreamHandlerCommand> list) (senderId:string) (msg:string) =
    async {
        for client in clients do
            client.Post(WriteMessage {Sender=senderId;Message=msg} )
    }

let privateMsgHandler (client:  Agent<StreamHandlerCommand>) (senderId:string) (msg:string) = 
    async{
         client.Post(WriteMessage {Recipient=senderId; Message=msg})
    }

let loginHandler (connectionHandler: Agent<ConnectionHandlerCommand>) (client:  Agent<StreamHandlerCommand>) (currentId:string) (requestedId:string) = 
    async{
        match connectionHandler.PostAndReply(fun replyChannel -> GetById(requestedId, replyChannel)) with
            // Success
            | None ->
                    connectionHandler.Post(LoginClient(currentId, requestedId)) 
                    client.Post(Rename requestedId)
                    client.Post(WriteMessage { LoginSuccessMessage.Message = "successcully loged in as " + requestedId })
            // Error
            | Some _ -> client.Post(WriteMessage {LoginErrorMessage.Message = "name in use"})
    }

let connectionHandler =
    new Agent<ConnectionHandlerCommand>(fun inbox ->
    
    //TODO: two lists, one for loged in clients other for qued
    let clients = new System.Collections.Generic.Dictionary<string, Agent<StreamHandlerCommand>>()

    let rec loop() =
        async {
            let! command = inbox.Receive()

            match command with
            | AddClient (id, conHandler, stream) ->
                match id with
                | Some id ->
                        conHandler.Start()
                        let client = {Id=id; Connection=stream}
                        clients.Add(client.Id, conHandler)
                        conHandler.Post(StartListening client)
                    
                | None -> conHandler.Post(StopListening)
             
            | LoginClient (oldId, newId) -> 
                        let client = clients.[oldId]
                        clients.Remove(oldId) |> ignore
                        clients.Add(newId, client)

            | GetAll replyChannel ->
                clients.Values
                    |> List.ofSeq
                    |> replyChannel.Reply 
            
            | GetById (id, replyChannel) ->
                match clients.ContainsKey(id) with
                | false -> None
                | true   -> Some clients.[id]
                |> replyChannel.Reply

            return! loop()
        }
    loop())


let getStreamHandlerAgent() =
    new Agent<StreamHandlerCommand>(fun inbox ->
        
        let mutable baseStream = null
        let mutable writer = null
        let mutable cl = Unchecked.defaultof<Client>

//        let broadcast = 
//            (fun senderId msg ->
//                 let clients = connectionHandler.PostAndReply(GetAll)
//                 broadcastHandler clients senderId msg)
//       
//        let privateMsg recieverId =
//            (fun senderId msg ->
//                match connectionHandler.PostAndReply(fun replyChannel -> GetById(recieverId, replyChannel)) with
//                | Some handler -> msg |> privateMsgHandler handler senderId
//                | None -> async{()}) //TODO: handle user not found

        //let login requestedId =
            //loginHandler connectionHandler inbox cl.Id requestedId
            
        //let loginErrorHandler _ = async{()}

        //let loginSuccessHandler _ = async{()}

        //let messageHandler = Protocol.MessageHandling.handleMessage broadcast privateMsg login loginErrorHandler loginSuccessHandler

        let rec loop() = 
            async {
                let! command = inbox.Receive()

                match command with
                | Rename newName -> cl <- { cl with Id = newName }

                | GetBaseStream reply -> reply.Reply(baseStream)

                | StartListening client ->

                    baseStream <- client.Connection
                    writer <- new System.IO.StreamWriter(client.Connection)
                    cl <- client

                    async {
                        let streamReader = new System.IO.StreamReader(client.Connection)
                        while true do
                            let! msg = streamReader.ReadLineAsync() |> Async.AwaitTask
                            printfn "got msg from %s: %s" cl.Id msg 
//                            do! messageHandler (cl.Id.ToString()) msg
                            do! Protocol.MessageHandling.getMsgHandler msg
                    } |> Async.Start

                | StopListening -> return () //TODO: dispose

                | WriteMessage msg ->

                    async{
                        match isNull writer with
                        | false ->
                            do! writer.WriteLineAsync(serializeMessage msg) |> Async.AwaitTask
                            do! writer.FlushAsync() |> Async.AwaitTask
                        | true -> ()
                    } |> Async.Start
                return! loop()
            }
        loop())


let connectionListener =
    new Agent<unit>(fun _ ->

        let listener = new System.Net.Sockets.TcpListener(System.Net.IPAddress.Parse("0.0.0.0"), 8888)

        connectionHandler.Start()

        listener.Start()

        let rec listenLoop() =

            async{
                let! client = listener.AcceptTcpClientAsync() |> Async.AwaitTask

                let addCommand = 
                    let agent = getStreamHandlerAgent()
                    let stream = client.GetStream()
                    let g = 
                        let guid = System.Guid.NewGuid()
                        guid.ToString()
                        
                    AddClient (Some g, agent, stream)

                connectionHandler.Post addCommand

                printfn "client connected: %s" (client.Client.RemoteEndPoint.ToString())

                return! listenLoop()
            }
        listenLoop())
 

[<EntryPoint>]

let main _ =

    connectionListener.Start()

    System.Console.ReadLine() |> ignore

    0