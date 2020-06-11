package mot.dump

import mot.impl.Connection
import mot.protocol.Frame
import java.text.SimpleDateFormat
import java.io.OutputStream
import java.nio.charset.StandardCharsets.US_ASCII
import mot.protocol.AttributesSupport
import mot.protocol.BodySupport
import mot.protocol.MessageTypes

case class MotEvent(conn: Connection, direction: Direction.Value, message: Frame) extends Event {
  
  def protocol = "mot"
  
  def print(os: OutputStream, sdf: SimpleDateFormat, showBody: Boolean, maxBodyLength: Int, showAttributes: Boolean) = {
    val ts = sdf.format(timestampMs) 
    val parties = s"$fromName[$fromAddress] > $toName[$toAddress]"
    val messageType = MessageTypes.reverse(message.messageType)
    val firstLine = s"$ts [mot] $parties $messageType, length ${message.length}, ${message.dump}\n"
    os.write(firstLine.getBytes(US_ASCII))
    if (showAttributes) {
      message match {
        case am: AttributesSupport => am.dumpAttributes(os)
        case _ => // pass
      }
    }
    if (showBody) {
      message match {
        case bm: BodySupport => bm.dumpBody(os, maxBodyLength)
        case _ => // pass
      }
    }
  }
  
}

