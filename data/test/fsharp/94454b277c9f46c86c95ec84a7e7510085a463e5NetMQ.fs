namespace Kollege.Messaging.NetMQ
open System
open NetMQ
open Kollege.Messaging

type NetMQBaseAddress = 
| NetMQBaseAddress of string

type NetMQAddress = 
  { BaseAddress:NetMQBaseAddress
    Port:int} with   
  member this.Value =
    match this.BaseAddress with
    | NetMQBaseAddress addr -> 
      sprintf "%s:%d" addr this.Port

  override this.ToString() = this.Value


[<AutoOpen>]
module NetMQ = 
  open System
  open NetMQ
    
  type NetMQContext with
    member this.CreateRouter(address) =
      let socket = this.CreateRouterSocket() 
      socket.Bind(address.ToString())
    

type MessagePublisher() =
  interface IPublisher with
    member this.Publish message = ()      

type NetMQMessageBroker(frontendAddress,backendAddress) =
  class end