package player.comms

import org.jboss.netty.buffer.ChannelBuffer
import PacketSerializer._

/**
 * User: michael
 * Date: 5/28/12
 * Time: 7:01 PM
 */

class PacketSerializer(val channel : ChannelBuffer) {

  def writePacket(packet: Packet) {
      packet match {
        case ServerHandshake(hash) =>
          channel.writeByte(MessageTypes.Handshake)
          channel.write(hash)
        case ServerLoginRequest(entity, level, mode, dimension, difficulty, max) =>
          channel.writeByte(MessageTypes.Login)
          channel.writeInt(entity)
          channel.write("")
          channel.write(level)
          channel.writeInt(mode)
          channel.writeInt(dimension)
          channel.writeByte(difficulty)
          channel.writeByte(0)
          channel.writeByte(128)
        case ServerChunk(x,y,primary,add,size,data,groundUp) =>
          channel.writeByte(MessageTypes.Chunk)
          channel.writeInt(x)
          channel.writeInt(y)
          channel.writeByte(if (groundUp) 1 else 0)
          channel.writeShort(primary)
          channel.writeShort(add)
          channel.writeInt(size)
          channel.writeBytes(data)
        case ServerAllocateBlock(x,y,mode) =>
          channel.writeByte(MessageTypes.MapAlloc)
          channel.writeInt(x)
          channel.writeInt(y)
          channel.writeByte(if (mode == true) 1 else 0)
        case ServerKick(reason) =>
          channel.writeByte(MessageTypes.Kick)
          channel.write(reason)
        case ServerPositionLook(x,stance,y,z,yaw,pitch,ground) =>
          channel.writeDouble(x)
          channel.writeDouble(stance)
          channel.writeDouble(y)
          channel.writeDouble(z)
          channel.writeDouble(yaw)
          //channel.write
        case _ =>
      }
    }

  def write(message: String) {
    channel.writeShort(message.length)
    channel.writeBytes(message.getBytes("UTF-16BE"))
  }

  /**
   * Write several values to a channel
   * @param any
   */
  def write(any: Any*) {

  }
}

object PacketSerializer {

  implicit def toPacket(channel: ChannelBuffer) : PacketSerializer = {
    new PacketSerializer(channel)
  }
}
