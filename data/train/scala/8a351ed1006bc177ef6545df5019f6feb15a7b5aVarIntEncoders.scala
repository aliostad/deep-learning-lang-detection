package nl.grons.thriftstream.encoder

import nl.grons.thriftstream.encoder.EncodeResult._
import uk.co.real_logic.agrona.MutableDirectBuffer

/**
  * Write an i32 on the wire as a varint. The MSB of each byte is set
  * if there is another byte to follow. This can write up to 5 bytes.
  */
object VarInt32Encoder extends Encoder[Int] {
  override def encode(value: Int, buffer: MutableDirectBuffer, writeOffset: Int): EncodeResult = {
    val availableByteCount = buffer.capacity() - writeOffset
    if (availableByteCount >= 5) {
      // Direct byte writes, the fast path
      var offset = writeOffset
      var toWrite = value
      while ((toWrite & ~0x7f) != 0) {
        buffer.putByte(offset, ((toWrite & 0x7f) | 0x80).toByte)
        offset += 1
        toWrite >>>= 7
      }
      buffer.putByte(offset, toWrite.toByte)
      offset += 1
      Encoded(buffer, offset)

    } else {
      // First create byte array, the slow path
      val bytes = Array.ofDim[Byte](5)
      var varIntByteCount = 0
      var toWrite = value
      while ((toWrite & ~0x7f) != 0) {
        bytes(varIntByteCount) = ((toWrite & 0x7f) | 0x80).toByte
        varIntByteCount += 1
        toWrite >>>= 7
      }
      bytes(varIntByteCount) = toWrite.toByte
      varIntByteCount += 1
      val varIntBytes = bytes.take(varIntByteCount)
      BytesEncoder.encode(varIntBytes, buffer, writeOffset)
    }
  }
}

/**
  * Write an i64 on the wire as a varint. The MSB of each byte is set
  * if there is another byte to follow. This can write up to 10 bytes.
  */
object VarInt64Encoder extends Encoder[Long] {
  override def encode(value: Long, buffer: MutableDirectBuffer, writeOffset: Int): EncodeResult = {
    val availableByteCount = buffer.capacity() - writeOffset
    if (availableByteCount >= 10) {
      // Direct byte writes, the fast path
      var offset = writeOffset
      var toWrite = value
      while ((toWrite & ~0x7fL) != 0) {
        buffer.putByte(offset, ((toWrite & 0x7fL) | 0x80).toByte)
        offset += 1
        toWrite >>>= 7
      }
      buffer.putByte(offset, toWrite.toByte)
      offset += 1
      Encoded(buffer, offset)

    } else {
      // First create byte array, the slow path
      val bytes = Array.ofDim[Byte](10)
      var varIntByteCount = 0
      var toWrite = value
      while ((toWrite & ~0x7fL) != 0) {
        bytes(varIntByteCount) = ((toWrite & 0x7fL) | 0x80).toByte
        varIntByteCount += 1
        toWrite >>>= 7
      }
      bytes(varIntByteCount) = toWrite.toByte
      varIntByteCount += 1
      val varIntBytes = bytes.take(varIntByteCount)
      BytesEncoder.encode(varIntBytes, buffer, writeOffset)
    }
  }
}

