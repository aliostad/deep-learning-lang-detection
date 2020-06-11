package info.kghost.wow.protocol

import org.jboss.netty.channel.Channel
import org.jboss.netty.channel.ChannelHandlerContext
import org.jboss.netty.handler.codec.oneone.OneToOneEncoder
import org.jboss.netty.buffer.ChannelBuffers
import org.jboss.netty.buffer.ChannelBuffer

class ArmoryEncoder extends OneToOneEncoder {
  override protected def encode(ctx: ChannelHandlerContext, channel: Channel, msg: Object): Object = {
    val (continuation, request) = msg.asInstanceOf[((Response => Unit), Request)]
    val buffer = ChannelBuffers.dynamicBuffer

    def writeString(buf: ChannelBuffer, s: String) = { buf.writeInt(s.length); buf.writeBytes(s.getBytes) }
    def writeObject(buf: ChannelBuffer, obj: Object): Unit = obj match {
      case m: Map[String, Object] => {
        buf.writeByte(1)
        m foreach { case (k, v) => writeString(buf, k); writeObject(buf, v) }
      }
      case a: Array[Object] => { buf.writeByte(2); buf.writeInt(a.length); a foreach { writeObject(buf, _) } }
      case i: java.lang.Integer => { buf.writeByte(3); buf.writeInt(i) }
      case bs: Bytes => { buf.writeByte(4); buf.writeInt(bs.content.length); buf.writeBytes(bs.content) }
      case s: String => { buf.writeByte(5); buf.writeInt(s.length); buf.writeBytes(s.getBytes) }
      case b: java.lang.Boolean => { buf.writeByte(6); if (b) buf.writeByte(1) else buf.writeByte(0) }
      case i: java.lang.Long => { buf.writeByte(7); buf.writeLong(i) }
    }

    writeString(buffer, request.target)
    buffer.writeInt(request.id)
    request.data foreach {
      case (k, v) =>
        if (v.isInstanceOf[Map[_, _]] || v.isInstanceOf[Array[_]] || v.isInstanceOf[Bytes]) {
          buffer.writeByte(4)
          writeString(buffer, k)
          val emb = ChannelBuffers.dynamicBuffer
          writeObject(emb, v)
          val embl = emb.readableBytes
          buffer.writeInt(embl)
          val bs = new Array[Byte](embl)
          emb.readBytes(bs)
          buffer.writeBytes(bs)
        } else {
          buffer.writeByte(5)
          writeString(buffer, k)
          writeString(buffer, v.toString)
        }
        buffer.writeByte(0xff)
    }
    buffer.writeByte(0xff)
    buffer
  }
}