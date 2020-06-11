module Client

open System
open Microsoft.VisualStudio.TestTools.UnitTesting
open System.Security.Cryptography
open System.Resources
open System.IO
open System
open System.Net
open System.Net.Sockets
open System.Threading
open System.Collections
open SocketStore
open Relay
open DataDelegate

type DataClient(size: int, ip: IPAddress, port: int,deleg: IDataDelegate) as x =
    let mutable data:byte[] = null
    do
        ()
    member x.Send()=
        x.createRandomData()
        let sendStream = new MemoryStream(data)
        let clientSocket = new Socket(AddressFamily.InterNetwork,SocketType.Stream,ProtocolType.Tcp)
        clientSocket.Connect(ip,port)
        
        let clientStream = new NetworkStream(clientSocket,true)
        deleg.SentDataHash(MD5.Create().ComputeHash(data))
        ignore(clientSocket.Send(data))
        
        clientSocket.Shutdown(SocketShutdown.Both)
        clientSocket.Close()
//        sendStream.CopyToAsync(clientStream)
//        
//        x.CopyDone()

    member x.createRandomData()=
        data <- Array.create size 0uy
        let rng = new RNGCryptoServiceProvider()
        rng.GetBytes(data)

    member x.CopyDone()=
        // send this to delegate
        ()