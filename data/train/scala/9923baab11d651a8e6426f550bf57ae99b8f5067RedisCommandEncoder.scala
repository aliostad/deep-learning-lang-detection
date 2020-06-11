import org.jboss.netty.channel._
import org.jboss.netty.buffer._

class RedisCommandEncoder extends SimpleChannelDownstreamHandler {
  override def writeRequested(ctx: ChannelHandlerContext, e: MessageEvent) = {
    val buf : ChannelBuffer = e.getMessage match {
      case None => {
        val buffer = ChannelBuffers.dynamicBuffer()
        buffer.writeByte('$')
        buffer.writeByte('-')
        buffer.writeByte('1')
        buffer.writeByte('\r')
        buffer.writeByte('\n')
        buffer
      }

      case (ok : Boolean, line : String) => {
        val buffer = ChannelBuffers.dynamicBuffer()
        buffer.writeByte((if (ok) '+' else '-'))
        buffer.writeBytes(line.getBytes("UTF-8"))
        buffer.writeByte('\r')
        buffer.writeByte('\n')
        buffer
      }
      
      case number : Integer => {
        val buffer = ChannelBuffers.dynamicBuffer()
        buffer.writeByte(':')
        buffer.writeBytes(number.toString.getBytes("UTF-8"))
        buffer.writeByte('\r')
        buffer.writeByte('\n')
        buffer
      }

      case bytes : Array[Byte] => {
        val buffer = ChannelBuffers.dynamicBuffer()
        buffer.writeByte('$')
        buffer.writeBytes(bytes.length.toString.getBytes("UTF-8"))
        buffer.writeByte('\r')
        buffer.writeByte('\n')
        buffer.writeBytes(bytes)
        buffer.writeByte('\r')
        buffer.writeByte('\n')
        buffer
      }
        
    }

    Channels.write(ctx, e.getFuture(), buf)

        
  }
}

