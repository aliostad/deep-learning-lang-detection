module ElectroElephant.Model

open ElectroElephant.Common
open ElectroElephant.Response
open System.IO
open System.Net.Sockets

type ReceiveState = 
  { /// The socket which we read from.
    socket : Socket
    /// This buffer will contain the buffered data from the TCP socket.
    buffer : byte []
    /// The size of the message, so we know when to stop reading.
    msg_size : MessageSize
    /// To keep track of how far we've read.
    mutable total_read_bytes : int32
    /// a callback which we can send the deserialized object to
    callback : Response -> unit
    /// the correlation_id set when sending the request to the server
    corr_id : CorrelationId
    /// This stream is where we store the body of our response and will be given
    /// to the corresponding Response Serializer when we've read everything we need.
    stream : MemoryStream }

type SendState =
  { /// The socket currently used to send the data
    /// which should already be connected to a specific
    /// kafka broker.
    socket : Socket
    /// The data that we wish to send to a kafka broker
    payload : byte[]
    /// how much of the payload that is sent
    mutable sent_bytes : int32}