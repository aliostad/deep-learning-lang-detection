namespace Foom.Network

open System

[<Sealed>]
type internal Sender =

    member Enqueue : byte [] * startIndex : int * size : int -> unit

    member Flush : TimeSpan -> unit

    member Process : (Packet -> unit) -> unit

    static member CreateUnreliable : PacketPool -> Sender

    static member CreateReliableOrderedAck : PacketPool -> Sender

[<Sealed>]
type internal SenderAck =

    member Enqueue : byte [] * startIndex : int * size : int -> unit

    member Flush : TimeSpan -> unit

    member Process : (Packet -> unit) -> unit

    member Ack : uint16 -> unit

    static member CreateReliableOrdered : PacketPool -> SenderAck

[<Sealed>]
type internal Receiver =

    member Enqueue : Packet -> unit

    member Flush : TimeSpan -> unit

    member Process : (Packet -> unit) -> unit

    static member CreateUnreliable : PacketPool -> Receiver

[<Sealed>]
type internal ReceiverAck =

    member Enqueue : Packet -> unit

    member Flush : TimeSpan -> unit

    member Process : (Packet -> unit) -> unit

    static member CreateReliableOrdered : PacketPool -> ReceiverAck