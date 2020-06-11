namespace FtpServer
    open System
    open System.IO
    open System.Net
    open System.Net.Sockets
    open System.Threading
    open System.Text
    open System.Text.RegularExpressions

    open Settings
    open SocketExtensions

    type SocketServer( handlerCreator:unit->ISocketHandler, port, ?ipAddress ) =
        let ipAddress = defaultArg ipAddress IPAddress.Any
        let endpoint = IPEndPoint(ipAddress, port)

        member t.Start() =
            async{
                let cts = new CancellationTokenSource()
        
                use listener = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
                listener.Bind(endpoint)
                listener.Listen(int SocketOptionName.MaxConnections)

                while true do
                    let! socket = listener.AsyncAccept()
                
                    let handle() =
                        //async{
                            try
                                try
                                    let handler = handlerCreator()
                                    //do! handler.Process(socket)
                                    handler.Process(socket) |> Async.RunSynchronously
                                with e -> printfn "exception %s" (e.ToString())
                            finally
                                socket.Shutdown(SocketShutdown.Both)
                                socket.Close()
                        //}

                    //TODO fix async
                    System.Threading.Tasks.Task.Factory.StartNew( (fun() -> handle()) ) |> ignore
                    //Async.StartChild( handle() ) |> ignore
                }
