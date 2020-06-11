package pl.lolczak.io.stream

import java.io.OutputStream

import SerializerConstants._

/**
 *
 *
 * @author Lukasz Olczak
 */
class SerializerOutputStream(private val outStream: OutputStream) extends OutputStream {

  def write(oneByte: Int) = outStream.write(oneByte)

  override def write(buffer: Array[Byte], offset: Int, count: Int) = outStream.write(buffer, offset, count)

  override def write(buffer: Array[Byte]) = outStream.write(buffer)

  override def flush() = outStream.flush()

  override def close() = outStream.close()

  def writeShort(value: Short) {
    write(value >> 8 & ByteMask)
    write(value & ByteMask)
  }

  def writeInt(value: Int) {
    write(value >> 24 & ByteMask)
    write(value >> 16 & ByteMask)
    write(value >> 8 & ByteMask)
    write(value & ByteMask)
  }

  def writeLong(value: Long) {
    write((value >> 56 & ByteMask).toInt)
    write((value >> 48 & ByteMask).toInt)
    write((value >> 40 & ByteMask).toInt)
    write((value >> 32 & ByteMask).toInt)
    write((value >> 24 & ByteMask).toInt)
    write((value >> 16 & ByteMask).toInt)
    write((value >> 8 & ByteMask).toInt)
    write((value & ByteMask).toInt)
  }

  def writeBoolean(value: Boolean) {
    write(if (value) TrueValue else FalseValue)
  }

  def writeString(value: String) {
    writeInt(value.length)
    value.foreach { char: Char =>
        if (char <= Utf8OneByteBoundary) {
          write(char)
        } else if (char <= Utf8TwoByteBoundary) {
          write(0xC0 | char >> 6 & 0x1F)
          write(0x80 | char & 0x3F)
        } else {
          write(0xE0 | char >> 12 & 0x0F)
          write(0x80 | char >> 6 & 0x3F)
          write(0x80 | char >> 0 & 0x3F)
        }
    }
  }

}

