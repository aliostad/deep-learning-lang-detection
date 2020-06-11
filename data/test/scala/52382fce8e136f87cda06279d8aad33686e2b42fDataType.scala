package ipfix.ie

import java.net.InetAddress
import java.nio.ByteBuffer
import java.sql.Timestamp
import ipfix.ByteIterCounter
import ipfix.ie.DataType._

sealed trait DataType {
  def load(byteIter: ByteIterCounter, length: Int): Any
  val placeHolder = "?"
}

object DataType {
  def loadUnsigned8(byteIter: ByteIterCounter): Int = byteIter.getU8AsInt

  def loadUnsigned16(byteIter: ByteIterCounter, len: Int): Int = {
    if (len == 1) loadUnsigned8(byteIter)
    else byteIter.getU16AsInt
  }

  def loadUnsigned32(byteIter: ByteIterCounter, len: Int): Int = {
    if (len <= 2) loadUnsigned16(byteIter, len)
    else if (len == 3) ByteBuffer.wrap(0.toByte +: Array.fill[Byte](3)(byteIter.next())).getInt
    else byteIter.getU32AsInt
  }

  def loadUnsigned64(byteIter: ByteIterCounter, len: Int): Long = {
    if (len <= 4) loadUnsigned32(byteIter, len)
    else if (len == 5) ByteBuffer.wrap(Array[Byte](0, 0, 0) ++ Array.fill[Byte](5)(byteIter.next())).getLong
    else if (len == 6) ByteBuffer.wrap(Array[Byte](0, 0) ++ Array.fill[Byte](6)(byteIter.next())).getLong
    else if (len == 7) ByteBuffer.wrap(0.toByte +: Array.fill[Byte](7)(byteIter.next())).getLong
    else byteIter.getU64AsLong
  }

  def loadSigned8(byteIter: ByteIterCounter): Int = byteIter.getByte

  def loadSigned16(byteIter: ByteIterCounter, len: Int): Int = {
    if (len == 1) loadSigned8(byteIter)
    else byteIter.getShort
  }

  def loadSigned32(byteIter: ByteIterCounter, len: Int): Int = {
    if (len <= 2) loadSigned16(byteIter, len)
    else if (len == 3) ByteBuffer.wrap(0.toByte +: Array.fill[Byte](3)(byteIter.next())).getInt
    else byteIter.getInt
  }

  def loadSigned64(byteIter: ByteIterCounter, len: Int): Long = {
    if (len <= 4) loadSigned32(byteIter, len)
    else if (len == 5) ByteBuffer.wrap(Array[Byte](0, 0, 0) ++ Array.fill[Byte](5)(byteIter.next())).getLong
    else if (len == 6) ByteBuffer.wrap(Array[Byte](0, 0) ++ Array.fill[Byte](6)(byteIter.next())).getLong
    else if (len == 7) ByteBuffer.wrap(0.toByte +: Array.fill[Byte](7)(byteIter.next())).getLong
    else byteIter.getLong
  }

  def loadFloat32(byteIter: ByteIterCounter): Float = byteIter.getFloat

  def loadFloat64(byteIter: ByteIterCounter, len: Int): Double = {
    if (len == 4) loadFloat32(byteIter)
    else byteIter.getDouble
  }

  def loadOctetArray(byteIter: ByteIterCounter, len: Int): Array[Byte] = byteIter.getBytes(len)

  def loadString(byteIter: ByteIterCounter, len: Int): String = String.valueOf(loadOctetArray(byteIter, len).map(_.toChar))

  def loadIpv4Address(byteIter: ByteIterCounter): InetAddress = InetAddress.getByAddress(loadOctetArray(byteIter, 4))

  def loadIpv6Address(byteIter: ByteIterCounter): InetAddress = InetAddress.getByAddress(loadOctetArray(byteIter, 16))

  def loadMacAddress(byteIter: ByteIterCounter): Array[Byte] = loadOctetArray(byteIter, 6)

  def loadBoolean(byteIter: ByteIterCounter): Boolean = {
    val i = byteIter.getByte
    if (i == 1) true
    else false
  }

  def loadDateTimeSeconds(byteIter: ByteIterCounter): Timestamp = new Timestamp(byteIter.getU32AsInt * 1000)

  def loadDateTimeMilliSeconds(byteIter: ByteIterCounter): Timestamp = new Timestamp(byteIter.getU64AsLong)

  def loadDateTimeMicroSeconds(byteIter: ByteIterCounter): Timestamp = new Timestamp(byteIter.getU64AsLong / 1000)

  def loadDateTimeNanoSeconds(byteIter: ByteIterCounter): Timestamp = new Timestamp(byteIter.getU64AsLong / 1000000)
}

case object Unsigned8 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Int = loadUnsigned8(byteIter)
}

case object Unsigned16 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Int = loadUnsigned8(byteIter)
}

case object Unsigned32 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Int = loadUnsigned32(byteIter, length)
}

case object Unsigned64 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Long = loadUnsigned64(byteIter, length)
}

case object Signed8 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Int = loadSigned8(byteIter)
}

case object Signed16 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Int = loadSigned8(byteIter)
}

case object Signed32 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Int = loadSigned32(byteIter, length)
}

case object Signed64 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Long = loadSigned64(byteIter, length)
}

case object Float32 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Float = loadFloat32(byteIter)
}

case object Float64 extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Double = loadFloat64(byteIter, length)
}

case object BooleanIE extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Boolean = loadBoolean(byteIter)
}

case object MacAddress extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Array[Byte] = loadMacAddress(byteIter)
}

case object OctetArray extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Array[Byte] = loadOctetArray(byteIter, length)
}

case object StringIE extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): String = loadString(byteIter, length)
}

case object DateTimeSeconds extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Timestamp = loadDateTimeSeconds(byteIter)
}

case object DateTimeMilliseconds extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Timestamp = loadDateTimeMilliSeconds(byteIter)
}

case object DateTimeMicroseconds extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Timestamp = loadDateTimeMicroSeconds(byteIter)
}

case object DateTimeNanoseconds extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): Timestamp = loadDateTimeNanoSeconds(byteIter)
}

case object Ipv4Address extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): InetAddress = loadIpv4Address(byteIter)
  override val placeHolder = "?::inet"
}

case object Ipv6Address extends DataType {
  def load(byteIter: ByteIterCounter, length: Int): InetAddress = loadIpv6Address(byteIter)
  override val placeHolder = "?::inet"
}