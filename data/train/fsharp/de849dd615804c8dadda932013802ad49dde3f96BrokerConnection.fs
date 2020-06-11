module ElectroElephant.Connection

open ElectroElephant.Request
open System
open System.IO
open System.Net.Sockets

type BrokerConfig = 
  { host : string
    port : int32 }

let tcp_client (conf : BrokerConfig) = new TcpClient(conf.host, conf.port)
let socket (cl : TcpClient) = cl.Client

let setup_broker_conn() = 
  let conf = 
    { host = "127.0.0.1"
      port = 1234 }
  tcp_client conf |> socket
//  tcp_client conf 
//let send_data 
//  ()
//let send_req (req : Request) callback =
//  let sock = setup_broker_conn
//  sock.BeginSend([||],
//      0, 0 , SocketFlags.None, new AsyncCallback( fun _ -> ()), null)
// -> Should have TCP Connection to a single broker in here
// Sending
// -> G: Should be able to send many messages and buffer them in the Socket
// -> G: Timeouts for each message should be handled somehow
// Recieveing 
// -> G: Every sent message should bind a callback
// -> G: When receiving a response, the message should be examined
//        if it contains an error code we might need to rebuild our 
//        metadata DB and postpone all other messages.
