package memcached.netty

import io.netty.handler.codec.MessageToByteEncoder
import io.netty.channel.ChannelHandlerContext
import io.netty.buffer.ByteBuf
import memcached.netty.messages._
import scala.annotation.switch
import io.netty.util.CharsetUtil
import memcached.netty.messages.SetRequest
import memcached.netty.messages.GetRequest

class MemcachedEncoder extends MessageToByteEncoder[ClientRequest] {

  def encode(ctx: ChannelHandlerContext, msg: ClientRequest, out: ByteBuf) {
    (msg.code: @switch) match {
      case Keys.Set => encodeSet(out, msg.asInstanceOf[SetRequest])
      case Keys.Get => encodeGet(out, msg.asInstanceOf[GetRequest])
      case Keys.Delete => encodeDelete(out, msg.asInstanceOf[DeleteRequest])
      case _ => throw new UnknownRequestException(msg)
    }
  }

  def encodeSet(buffer : ByteBuf, set: SetRequest) {
    val key = set.key.getBytes(CharsetUtil.US_ASCII)
    buffer
      .writeByte(Keys.RequestKey)
      .writeByte(Keys.Set)
      .writeShort(key.size)
      .writeByte(8) // extras length
      .writeByte(0) // data type
      .writeShort(0) // reserved
      .writeInt(key.size + 8 + set.value.size) // total body size
      .writeInt(0) // opaque
      .writeLong(0) // CAS
      .writeInt(set.flags)
      .writeInt(set.expiration)
      .writeBytes(key)
      .writeBytes(set.value)
  }

  def encodeGet(buffer : ByteBuf, get: GetRequest) {
    encodeKeyMessage(buffer, get.key, Keys.Get)
  }

  def encodeDelete(buffer : ByteBuf, delete: DeleteRequest) {
    encodeKeyMessage(buffer, delete.key, Keys.Delete)
  }

  def encodeKeyMessage( buffer : ByteBuf, keyName : String, code : Int ) {
    val key = keyName.getBytes(CharsetUtil.US_ASCII)
    buffer
      .writeByte(Keys.RequestKey)
      .writeByte(code) // message code
      .writeShort(key.size) // key size
      .writeByte(0) // extras length
      .writeByte(0) // data type
      .writeShort(0) // reserved
      .writeInt(key.size) // total body size
      .writeInt(0) // opaque
      .writeLong(0) // CAS
      .writeBytes(key)
  }

}
