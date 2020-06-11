package net.qbert.network

import net.qbert.framing.{ AMQArray, AMQShortString, AMQLongString, AMQFieldTable, BasicProperties }
import java.util.{Date => JDate}
import org.jboss.netty.buffer.ChannelBuffers

trait CanWriteOut {
  def writeTo(fw: FrameWriter): Unit
  //def encodedSize(): Int
}

/* We use a dynamic buffer here in the case where someone creates a writer
 * without knowing the size of the frame they intend to write.  Now, for the
 * most part this is not possible since the frame hierarchy forces one to
 * always know the size of the frame so we will never need to reallocate and
 * waste space.
 *
 * For now, keep it this way and deprecate once we're sure we dont need it
 */
class FrameWriter(size: Int) {
  private val buf = ChannelBuffers.buffer(size)

  def bytesWritten() = buf.readableBytes

  def writeOctet(byte: Int) = buf.writeByte(byte)
  def writeShort(short: Int) = buf.writeShort(short)
  def writeLong(int: Int) = buf.writeInt(int)
  def writeLongLong(long: Long) = buf.writeLong(long)
  def writeFloat(float: Float) = buf.writeFloat(float)
  def writeTimestamp(d: JDate) = buf.writeLong(d.getTime/1000)

  /*
  def writeShortString(s: String) = {
    buf.writeShort(s.length())
    buf.writeBytes(s.getBytes("utf-8"))
  }
  */

  def writeShortString(s: AMQShortString) = s.writeTo(this)

  /*
  def writeLongString(s: String) = {
    buf.writeInt(s.length())
    buf.writeBytes(s.getBytes("utf-8"))
  }
  */

  def writeLongString(s: AMQLongString) = s.writeTo(this)

  def writeFieldTable(table: AMQFieldTable): Unit = table.writeTo(this)

  /*
  def writeFieldTable(m: Map[String, Any]):Unit = {
    val tempBuf = new FrameWriter
    var size = 0
    m foreach{ case (k, v) => 
      tempBuf writeShortString k
      tempBuf writeFieldValue v
    }

    val len = tempBuf.frame.readableBytes
    buf.writeLong(len)
    buf.writeBytes(tempBuf.frame)
  }

  def writeFieldValue(value: Any):Unit = value match {
    case t: Boolean => buf.writeByte('t'); buf.writeByte(if(t) 1 else 0)
    case b: Byte => buf.writeByte('b'); buf.writeByte(b)
    case s: Short => buf.writeByte('u'); buf.writeShort(s)
    case i: Int => buf.writeByte('I'); buf.writeInt(i)
    case l: Long => buf.writeByte('l'); buf.writeLong(l)
    case f: Float => buf.writeByte('f'); buf.writeFloat(f)
    case s: String => buf.writeByte('s'); val bytes = s.getBytes("utf-8"); buf.writeShort(bytes.length); buf.writeBytes(bytes)
    case a: Array[Any] => buf.writeByte('A'); writeArray(a)
    case table: Map[String,Any] => buf.writeByte('F'); writeFieldTable(table)
    case _ => println("none")
  }
  */

  def writeArray(array: AMQArray) = array.writeTo(this)
    
  /*
  def writeArray(array: Array[Any]) = {
    val len = array.length 
    buf.writeInt(len)
    array foreach( value => writeFieldValue(value))
  }
  */
  
  def writeBasicProperties(props: BasicProperties) = props.writeTo(this)
                    

  def writeBytes(b: Array[Byte]) = buf.writeBytes(b)

  def frame() = buf
}
