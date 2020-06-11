package topology
package pickling.avro.binary

import scala.pickling.Output

import org.apache.avro.io.{ EncoderFactory, DirectBinaryEncoder }

class AvroBinaryEncoder extends Output[ByteString] {

  private val builder = new ByteStringBuilder

  import AvroBinaryEncoder.{ apacheEncoderFactory => factory }
  private val apacheEncoder = factory.directBinaryEncoder(
    builder.asOutputStream,
    null // the encoder to (not) re-use
  )

  def put(bs: ByteString): this.type = {
    builder ++= bs
    this
  }

  def result(): ByteString = builder.result

  final val trueByte = 1.toByte
  final val falseByte = 0.toByte

  def writeBoolean(value: Boolean): Unit =
    writeByte(if (value) trueByte else falseByte)

  def writeNull(): Unit = { /* does nothing */ }

  def writeByte(value: Byte): Unit = builder += value

  def writeBytes(bytes: Seq[Byte]): Unit = builder ++= bytes

  def writeBytes(bytes: Array[Byte]): Unit = builder putBytes bytes

  def writeString(value: String): Unit = apacheEncoder writeString value

  def writeChar(value: Char): Unit = apacheEncoder writeInt value.toInt

  def writeShort(value: Short): Unit = apacheEncoder writeInt value.toInt

  def writeInt(value: Int): Unit = apacheEncoder writeInt value

  def writeLong(value: Long): Unit = apacheEncoder writeLong value

  def writeFloat(value: Float): Unit = apacheEncoder writeFloat value

  def writeDouble(value: Double): Unit = apacheEncoder writeDouble value

}

object AvroBinaryEncoder {
  private[topology] val apacheEncoderFactory = EncoderFactory.get()
}
