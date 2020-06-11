namespace EvoDistroLisa.Engine.ZMQ

module ZmqServer = 
    open fszmq
    open FSharp.Fx
    open EvoDistroLisa.Domain
    open EvoDistroLisa.Engine
    open EvoDistroLisa.Engine.ZMQ.Message

    let createServer port pixels best token =
        let zmq = new ZMQLoop(token = token)
        let ctx = zmq.Context

        let randomTcpPort () = Socket.randomTcpPort 50000 60000

        let repSocket = 
            let socket = Context.rep ctx
            port |> sprintf "tcp://*:%d" |> Socket.bind socket
            zmq.RegisterSocket(socket)
        let pubSocket, pubPort =
            let socket = Context.pub ctx
            let port = randomTcpPort () |> Socket.bindToAny socket (sprintf "tcp://*:%d")
            zmq.RegisterSocket(socket), port
        let pullSocket, pullPort =
            let socket = Context.pull ctx
            let port = randomTcpPort () |> Socket.bindToAny socket (sprintf "tcp://*:%d")
            zmq.RegisterSocket(socket), port

        let agent = Agent.createPassiveAgent pixels best token

        let repHandler message = 
            match message with
            | Handshake -> Bootstrap (pubPort, pullPort, { Pixels = pixels; Scene = agent.Best })
            | _ -> message |> sprintf "Unrecognized message: %A" |> Error
        zmq.CreateResponder(repSocket, decode, encode, repHandler)

        let pullHandler message = 
            match message with
            | Improved scene -> agent.Push(scene)
            | Mutated count -> agent.Push(count)
            | _ -> message |> sprintf "Unrecogniezed message: %A" |> trace |> ignore
        zmq.CreateReceiver(pullSocket, decode, pullHandler)

        let pubHandler = zmq.CreateSender(pubSocket, encode)

        agent.Improved |> Observable.subscribe (Improved >> pubHandler) |> ignore

        agent