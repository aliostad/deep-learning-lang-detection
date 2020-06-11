
namespace Futility

open System
open System.Threading
open System.IO
open System.IO.Pipes
open System.Net
open System.Net.Sockets

module TcpServer =
  let start (ipAddress : IPAddress) (port : int) (queue : int) (threads : int) (handler : Stream -> unit) =
    let cts = new CancellationTokenSource ()
    let listener = new Socket (AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp)
    listener.Bind (IPEndPoint (ipAddress, port))
    listener.Listen queue
    let asyncAccept () = Async.FromBeginEnd (listener.BeginAccept, listener.EndAccept)
    let rec loop () = async {
      let! socket = asyncAccept ()
      let stream = new NetworkStream (socket, false)
      try
        handler stream
      finally
        dispose stream
        socket.Shutdown SocketShutdown.Both
        dispose socket
      return! loop ()
    }
    [1 .. threads]
    |> List.iter (fun _ -> Async.Start (loop (), cts.Token))
    { new IDisposable with
        member o.Dispose () =
          cts.Cancel ()
          dispose listener
    }

module NamedPipeServer =
  let startWithSecurity ps (pipeName : string) (threads : int) (handler : Stream -> unit) =
    let cts = new CancellationTokenSource ()
    let rec loop () = async {
      let stream = new NamedPipeServerStream (
                        pipeName,
                        PipeDirection.InOut,
                        threads,
                        PipeTransmissionMode.Byte,
                        PipeOptions.Asynchronous,
                        4096, 4096, ps)
      do! Async.FromBeginEnd (stream.BeginWaitForConnection, stream.EndWaitForConnection)
      try
        handler stream
      finally
        stream.WaitForPipeDrain ()
        dispose stream
      return! loop ()
    }
    [1 .. threads]
    |> List.iter (fun _ -> Async.Start (loop (), cts.Token))
    { new IDisposable with
      member o.Dispose () =
        cts.Cancel ()
    }
  let start (pipeName : string) (threads : int) (handler : Stream -> unit) =
    let ps = PipeSecurity ()
    let sid = Security.Principal.SecurityIdentifier (Security.Principal.WellKnownSidType.WorldSid, null)
    let par = PipeAccessRule (sid, PipeAccessRights.FullControl, Security.AccessControl.AccessControlType.Allow)
    ps.AddAccessRule par
    startWithSecurity ps pipeName threads handler
