module DotNettyTransport

open System
open System.IO
open System.Security.Cryptography.X509Certificates
open System.Threading.Tasks
open DotNetty.Codecs
open DotNetty.Handlers.Logging
open DotNetty.Handlers.Tls
open DotNetty.Transport.Bootstrapping
open DotNetty.Transport.Channels
open DotNetty.Transport.Channels.Sockets
open DotNetty.Buffers
open Transport
open System.Net
open System.Text

// DotNetty can read the length and prefix off the wire for us.
// It's API is very Javaesque though

let channelRead (clientToServerFeed: Event<_>) (context: IChannelHandlerContext, message: obj) = 
    //printfn "Message received from client"


    let processStringToSend (s: string) = 
        let encodingLength = Encoding.UTF8.GetMaxByteCount(s.Length)

        let byteBuffer = Unpooled.Buffer(encodingLength)
                    
        byteBuffer.WriteBytes(Encoding.UTF8.GetBytes(s)) |> ignore
        //printfn "Attempting to send message %s to client" s
        context.WriteAndFlushAsync(byteBuffer) |> Async.AwaitTask

    let client = {
        new IServerClient with
            member x.Send ssm = async {
                match ssm with 
                | ServerSentMessage.SendByteMessage bm -> 
                    failwith "Lets not test byte messages yet"
                | ServerSentMessage.SendStringMessage s -> do! processStringToSend s }
            member x.Flush() = async { do context.Flush() }
        }
    
    match message with 
    | null -> ()
    | :? IByteBuffer as x -> 
        let messageFromClientString = x.ToString(Encoding.UTF8)
        printfn "Message from client %s" messageFromClientString
        clientToServerFeed.Trigger(client, ServerReceivedMessage.ReceivedStringMessage (messageFromClientString))
    | _ -> failwith "Unexpected object here"

type ServerChannelHandler(clientToServerFeed: Event<_>) =
    inherit ChannelHandlerAdapter()

    override x.ChannelRead(context: IChannelHandlerContext, message: obj) = 
        channelRead clientToServerFeed (context, message)

    override x.ChannelReadComplete context = context.Flush() |> ignore
    override x.ExceptionCaught(context, ex) = 
        printfn "Exception caugt in server handler %s" ex.Message
        context.CloseAsync() |> ignore

    override x.IsSharable = true

let createServer (port: int32) =

    let bossGroup = MultithreadEventLoopGroup(1);
    let workerGroup = MultithreadEventLoopGroup();

    let stringEncoder = StringEncoder();
    let stringDecoder = StringDecoder();

    let serverEvent = Event<_>()

    let bootstrap = ServerBootstrap()
    bootstrap.Group(bossGroup, workerGroup).Channel<TcpServerSocketChannel>().Option(ChannelOption.SoBacklog, 100)
        .Handler(LoggingHandler("SRV-LSTN"))
        .ChildHandler(
            (ActionChannelInitializer<ISocketChannel>(fun channel->                    
                let pipeline = channel.Pipeline

                pipeline.AddLast(LoggingHandler("CONN")) |> ignore
                pipeline.AddLast("framing-enc", new LengthFieldPrepender(2)) |> ignore
                pipeline.AddLast("framing-dec", new LengthFieldBasedFrameDecoder(65535, 0, 2, 0, 2)) |> ignore

                pipeline.AddLast("handler", (ServerChannelHandler(serverEvent))) |> ignore);
        ))
        |> ignore

    let bootstrapChannel = bootstrap.BindAsync(port) |> Async.AwaitTask |> Async.RunSynchronously

    printfn "Server started on port using DotNetty %i" port

    { new IServerTransport with
        member __.Dispose() = bootstrapChannel.CloseAsync() |> Async.AwaitTask |> Async.RunSynchronously
        member __.InMessageObservable = serverEvent.Publish :> IObservable<_> }

type DotNettyClientHandler(clientEvent: Event<_>) = 
    inherit ChannelHandlerAdapter()
    override x.ChannelRead(context: IChannelHandlerContext, message: obj) = 
        //printfn "Message received from Server to client"
        match message with 
        | null -> ()
        | :? IByteBuffer as x -> 
            let stringMessageFromServer = x.ToString(Encoding.UTF8)
            //printfn "Message received from Server to client [%s]" stringMessageFromServer
            clientEvent.Trigger(SendStringMessage stringMessageFromServer)
        | _ -> failwith "Unexpected message type from server"

    override x.ExceptionCaught(context, ex) = 
        printfn "Exception caught on client handler %s" ex.Message
        context.CloseAsync() |> ignore

let createClient port = 

    let clientEvent = Event<_>()

    let bootstrap = new Bootstrap()
    let group = MultithreadEventLoopGroup()

    bootstrap
        .Group(group)
        .Channel<TcpSocketChannel>()
        .Option(ChannelOption.TcpNodelay, true)
        .Handler(
            (ActionChannelInitializer<ISocketChannel>(fun channel -> 
                let pipeline = channel.Pipeline
                pipeline.AddLast(new LoggingHandler()) |> ignore
                pipeline.AddLast("framing-enc", new LengthFieldPrepender(2)) |> ignore
                pipeline.AddLast("framing-dec", new LengthFieldBasedFrameDecoder(65535, 0, 2, 0, 2)) |> ignore

                pipeline.AddLast("client", new DotNettyClientHandler(clientEvent)) |> ignore
            )))
        |> ignore

    let host = IPAddress.Parse("127.0.0.1")
    
    let bootstrapChannel = 
        try bootstrap.ConnectAsync(new IPEndPoint(host, port)) |> Async.AwaitTask |> Async.RunSynchronously
        with | ex -> printfn "Client connection failed"; reraise()

    printfn "Client Connected"

    let writeString (s: string) = 
        let encodingLength = Encoding.UTF8.GetMaxByteCount(s.Length)
        let mutable writeBuffer = Unpooled.Buffer(encodingLength)
        let stringBytes = Encoding.UTF8.GetBytes(s)
        let byteBufferToSend = writeBuffer.WriteBytes(stringBytes)
        try bootstrapChannel.WriteAndFlushAsync(byteBufferToSend) |> Async.AwaitTask |> Async.RunSynchronously
        with | ex -> printfn "Failed to send string message over to the server %s" s; reraise()

    { new IClient with 
        member x.Send clientMessage = 
            match clientMessage with 
            | SendClientMessage.ByteMessage b -> failwith "DotNetty client does nto support byte messages yet"
            | SendClientMessage.StringMessage s -> writeString s
        member x.ReceivedMessages = clientEvent.Publish :> IObservable<_>
        member x.Dispose() = 
            async {
                do! bootstrapChannel.CloseAsync() |> Async.AwaitTask
                do! group.ShutdownGracefullyAsync() |> Async.AwaitTask
            } |> Async.RunSynchronously
        }
