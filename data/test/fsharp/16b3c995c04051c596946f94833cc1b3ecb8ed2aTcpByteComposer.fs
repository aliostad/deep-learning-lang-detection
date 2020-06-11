namespace MUDT.Net.ProtocolV1

  open MUDT.Utilities
  open MUDT.Net.ProtocolV1

  module TcpByteComposer =

    let private createByteArray =
      TypeUtility.nullByteArray TcpPacket.DefaultSize

    let private copyAsBytes (x:System.Object) (offset:int) (bytes:byte[]) =
      x |> ConversionUtility.getBytes
      |> Array.iteri(fun i b -> bytes.[i+offset] <- b)
      bytes

    let composeMeta (packet:TcpPacket) =
      createByteArray
      |> copyAsBytes packet.ptype 0
      |> copyAsBytes packet.fileSize 1
      |> copyAsBytes packet.fnLen 9

    let composePorts (packet:TcpPacket) =
      createByteArray
      |> copyAsBytes packet.ptype 0
      |> copyAsBytes packet.numPorts 1

    let composeAct (packet:TcpPacket) =
      createByteArray
      |> copyAsBytes packet.ptype 0
      |> copyAsBytes packet.action 1

    let composeChecksum (packet:TcpPacket) =
      createByteArray
      |> copyAsBytes packet.ptype 0
      |> copyAsBytes packet.pNum 1
      |> copyAsBytes packet.dLen 5

    let composeChecksumValidation (packet:TcpPacket) =
      createByteArray
      |> copyAsBytes packet.ptype 0
      |> copyAsBytes packet.result 1
      |> copyAsBytes packet.pNum 2

    let composePacketDropped (packet:TcpPacket) =
      createByteArray
      |> copyAsBytes packet.ptype 0
      |> copyAsBytes packet.seqNum 1

    let composePing (packet:TcpPacket) =
      createByteArray
      |> copyAsBytes packet.ptype 0
      |> copyAsBytes packet.timestamp 1

    let tcpPacketToByteArray (packet:TcpPacket) =
      match Tcp.parsePacketType packet with
      | Meta -> Some (composeMeta packet)
      | Ports -> Some (composePorts packet)
      | Action -> Some (composeAct packet)
      | Checksum -> Some (composeChecksum packet)
      | ChecksumValidation -> Some (composeChecksumValidation packet)
      | PacketDropped -> Some (composePacketDropped packet)
      | Ping -> Some (composePing packet)
      | _ -> None