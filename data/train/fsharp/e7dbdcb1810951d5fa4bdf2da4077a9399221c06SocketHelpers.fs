module ElectroElephant.SocketHelpers

open ElectroElephant.Common
open ElectroElephant.Model
open ElectroElephant.Response
open System
open System.IO
open System.Net.Sockets
open System.Collections.Generic

/// <summary>
///   This method inits a begin receive for the given socket
/// </summary>
/// <param name="state"></param>
/// <param name="remaining_bytes"></param>
/// <param name="callback"></param>
//let begin_receive (state : ReceiveState) remaining_bytes callback = 
//  state.socket.BeginReceive
//    (state.buffer, 0, remaining_bytes, SocketFlags.None, 
//     new AsyncCallback(callback), state)

/// <summary>
///  This call is blocks until the remote closes the socket 
///  or until we've gotten the requested amount of bytes on our stream.
/// </summary>
/// <param name="state"></param>
/// <param name="result"></param>
//let end_receive (state : ReceiveState) result =
//   state.socket.EndReceive(result)

/// <summary>
///   Begins to send data to the broker, in a async fashion.
/// </summary>
/// <param name="socket">the socket on which to send the data on</param>
/// <param name="payload">the data to send.</param>
/// <param name="callback">what callback to call when the send is done.</param>
//let begin_send (send_state : SendState) callback = 
//  send_state.socket.BeginSend(
//    send_state.payload, 
//    send_state.sent_bytes, 
//    send_state.payload.Length, 
//    SocketFlags.None, 
//    new AsyncCallback(callback),
//    send_state)

/// <summary>
///   returns the number of bytes that was successfully sent to the underlying socket.
///   if the nunbers of bytes that are sent are less than what we wanted to send then 
///   begin send must be called again.
/// </summary>
/// <param name="socket"></param>
/// <param name="result"></param>
//let end_send (state : SendState) result =
//  state.socket.EndSend(result)

let toIList<'T> (data : 'T array) =
    let segment = new System.ArraySegment<'T>(data)
    let data = new List<System.ArraySegment<'T>>() :> IList<System.ArraySegment<'T>>
    data.Add(segment)
    data

type Socket with 
  member socket.AsyncReceive(buffer:byte[], ?offset, ?count) =
    let offset = defaultArg offset 0
    let count = defaultArg count buffer.Length
    let beginReceive(b,o,c,cb,s) = socket.BeginReceive(b,o,c,SocketFlags.None,cb,s)
    Async.FromBeginEnd(buffer, offset, count, beginReceive, socket.EndReceive)

  member socket.AsyncSend(buffer:byte[], ?offset, ?count) =
    let offset = defaultArg offset 0
    let count = defaultArg count buffer.Length
    let beginSend(b,o,c,cb,s) = socket.BeginSend(b,o,c,SocketFlags.None,cb,s)
    Async.FromBeginEnd(buffer, offset, count, beginSend, socket.EndSend)