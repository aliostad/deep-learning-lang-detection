package msgpack4z

import java.io.ByteArrayOutputStream
import java.math.BigInteger

final class MsgOutBuffer private(buf: ByteArrayOutputStream) extends MsgPacker{

  override def result(): Array[Byte] = {
    buf.toByteArray
  }

  private[msgpack4z] def writeByteAndShort(b: Byte, sh: Short): Unit = {
    buf.write(b)
    buf.write((sh >>> 8) & 0xFF)
    buf.write((sh >>> 0) & 0xFF)
  }

  private[this] def writeByteAndByte(b: Byte, b1: Byte): Unit = {
    buf.write(b)
    buf.write(b1)
  }

  private[this] def writeInt(l: Int): Unit = {
    buf.write((l >>> 24).asInstanceOf[Byte])
    buf.write((l >>> 16).asInstanceOf[Byte])
    buf.write((l >>> 8).asInstanceOf[Byte])
    buf.write(l.asInstanceOf[Byte])
  }

  private[this] def writeLong(l: Long): Unit = {
    buf.write((l >>> 56).asInstanceOf[Byte])
    buf.write((l >>> 48).asInstanceOf[Byte])
    buf.write((l >>> 40).asInstanceOf[Byte])
    buf.write((l >>> 32).asInstanceOf[Byte])
    buf.write((l >>> 24).asInstanceOf[Byte])
    buf.write((l >>> 16).asInstanceOf[Byte])
    buf.write((l >>> 8).asInstanceOf[Byte])
    buf.write(l.asInstanceOf[Byte])
  }

  private[msgpack4z] def writeByteAndInt(b: Byte, i: Int): Unit = {
    buf.write(b)
    writeInt(i)
  }

  private[msgpack4z] def writeByteAndLong(b: Byte, l: Long): Unit = {
    buf.write(b)
    writeLong(l)
  }

  private[this] def writeByteAndFloat(b: Byte, f: Float): Unit = {
    buf.write(b)
    writeInt(java.lang.Float.floatToIntBits(f))
  }

  private[this] def writeByteAndDouble(b: Byte, d: Double) = {
    buf.write(b)
    writeLong(java.lang.Double.doubleToLongBits(d))
  }

  override def packByte(b: Byte): Unit = {
    if (b < -(1 << 5)) {
      buf.write(Code.INT8)
      buf.write(b)
    } else {
      buf.write(b)
    }
  }

  def packShort(v: Short): Unit = {
    if (v < -(1 << 5)) {
      if (v < -(1 << 7)) {
        writeByteAndShort(Code.INT16, v)
      } else {
        writeByteAndByte(Code.INT8, v.asInstanceOf[Byte])
      }
    } else if (v < (1 << 7)) {
      buf.write(v.asInstanceOf[Byte])
    } else {
      if (v < (1 << 8)) {
        writeByteAndByte(Code.UINT8, v.asInstanceOf[Byte])
      }
      else {
        writeByteAndShort(Code.UINT16, v)
      }
    }
  }

  def packInt(r: Int): Unit = {
    if (r < -(1 << 5)) {
      if (r < -(1 << 15)) {
        writeByteAndInt(Code.INT32, r)
      } else if (r < -(1 << 7)) {
        writeByteAndShort(Code.INT16, r.asInstanceOf[Short])
      } else {
        writeByteAndByte(Code.INT8, r.asInstanceOf[Byte])
      }
    } else if (r < (1 << 7)) {
      buf.write(r.asInstanceOf[Byte])
    } else {
      if (r < (1 << 8)) {
        writeByteAndByte(Code.UINT8, r.asInstanceOf[Byte])
      } else if (r < (1 << 16)) {
        writeByteAndShort(Code.UINT16, r.asInstanceOf[Short])
      } else {
        writeByteAndInt(Code.UINT32, r)
      }
    }
  }


  def packLong(v: Long): Unit = {
    if (v < -(1L << 5)) {
      if (v < -(1L << 15)) {
        if (v < -(1L << 31)) {
          writeByteAndLong(Code.INT64, v)
        } else {
          writeByteAndInt(Code.INT32, v.asInstanceOf[Int])
        }
      } else {
        if (v < -(1 << 7)) {
          writeByteAndShort(Code.INT16, v.asInstanceOf[Short])
        } else {
          writeByteAndByte(Code.INT8, v.asInstanceOf[Byte])
        }
      }
    } else if (v < (1 << 7)) {
      buf.write(v.asInstanceOf[Byte])
    } else {
      if (v < (1L << 16)) {
        if (v < (1 << 8)) {
          writeByteAndByte(Code.UINT8, v.asInstanceOf[Byte])
        } else {
          writeByteAndShort(Code.UINT16, v.asInstanceOf[Short])
        }
      } else {
        if (v < (1L << 32)) {
          writeByteAndInt(Code.UINT32, v.asInstanceOf[Int])
        } else {
          writeByteAndLong(Code.UINT64, v)
        }
      }
    }
  }

  def packBigInteger(bi: BigInteger): Unit = {
    if (bi.bitLength() <= 63) {
      packLong(bi.longValue())
    } else if (bi.bitLength() == 64 && bi.signum() == 1) {
      writeByteAndLong(Code.UINT64, bi.longValue())
    } else {
      throw new IllegalArgumentException("Messagepack cannot serialize BigInteger larger than 2^64-1")
    }
  }

  def packFloat(v: Float): Unit = {
    writeByteAndFloat(Code.FLOAT32, v)
  }

  def packDouble(v: Double): Unit = {
    writeByteAndDouble(Code.FLOAT64, v)
  }

  def close(): Unit = {
    buf.close()
  }

  override def packArrayHeader(size: Int): Unit = {
    if(0 <= size) {
      if(size < (1 << 4)) {
        buf.write((Code.FIXARRAY_PREFIX | size).asInstanceOf[Byte])
      } else if(size < (1 << 16)) {
        writeByteAndShort(Code.ARRAY16, size.asInstanceOf[Short])
      } else {
        writeByteAndInt(Code.ARRAY32, size)
      }
    } else {
      writeByteAndInt(Code.ARRAY32, size)
    }
  }

  override def packBinary(array: Array[Byte]): Unit = {
    val len = array.length
    if(len < (1 << 8)) {
      writeByteAndByte(Code.BIN8, len.asInstanceOf[Byte])
    } else if(len < (1 << 16)) {
      writeByteAndShort(Code.BIN16, len.asInstanceOf[Short])
    } else {
      writeByteAndInt(Code.BIN32, len)
    }
    buf.write(array)
  }

  override def packNil(): Unit = {
    buf.write(Code.NIL)
  }

  override def mapEnd(): Unit = {
    // do nothing
  }

  override def packMapHeader(size: Int): Unit = {
    if(0 <= size) {
      if (size < (1 << 4)) {
        buf.write((Code.FIXMAP_PREFIX | size).asInstanceOf[Byte])
      } else if (size < (1 << 16)) {
        writeByteAndShort(Code.MAP16, size.asInstanceOf[Short])
      } else {
        writeByteAndInt(Code.MAP32, size)
      }
    } else {
      writeByteAndInt(Code.MAP32, size)
    }
  }

  override def packBoolean(a: Boolean): Unit = {
    buf.write(if(a) Code.TRUE else Code.FALSE)
  }

  private[this] def writeStringHeader(len: Int): Unit = {
    if(len < (1 << 5)) {
      buf.write((Code.FIXSTR_PREFIX | len).asInstanceOf[Byte])
    } else if(len < (1 << 8)) {
      writeByteAndByte(Code.STR8, len.asInstanceOf[Byte])
    } else if(len < (1 << 16)) {
      writeByteAndShort(Code.STR16, len.asInstanceOf[Short])
    } else {
      writeByteAndInt(Code.STR32, len)
    }
  }

  override def packString(str: String): Unit = {
    val bytes = str.getBytes("UTF-8")
    writeStringHeader(bytes.length)
    buf.write(bytes)
  }

  override def arrayEnd(): Unit = {
    // do nothing
  }

  override def writePayload(a: Array[Byte]): Unit = {
    buf.write(a)
  }

  override def packExtTypeHeader(extType: Byte, payloadLen: Int): Unit = {
    if (0 <= payloadLen) {
      if (payloadLen < (1 << 8)) {
        (payloadLen: @annotation.switch) match {
          case 1 =>
            writeByteAndByte(0xd4.asInstanceOf[Byte], extType);
          case 2 =>
            writeByteAndByte(0xd5.asInstanceOf[Byte], extType)
          case 4 =>
            writeByteAndByte(0xd6.asInstanceOf[Byte], extType)
          case 8 =>
            writeByteAndByte(0xd7.asInstanceOf[Byte], extType)
          case 16 =>
            writeByteAndByte(0xd8.asInstanceOf[Byte], extType)
          case _ =>
            writeByteAndByte(0xc7.asInstanceOf[Byte], payloadLen.asInstanceOf[Byte])
            buf.write(extType);
        }
      } else if (payloadLen < (1 << 16)) {
        writeByteAndShort(0xc8.asInstanceOf[Byte], payloadLen.asInstanceOf[Short])
        buf.write(extType)
      } else {
        writeByteAndInt(0xc9.asInstanceOf[Byte], payloadLen)
        buf.write(extType)
      }
    } else {
      writeByteAndInt(0xc9.asInstanceOf[Byte], payloadLen)
      buf.write(extType)
    }
  }
}

object MsgOutBuffer {
  def create(): MsgOutBuffer = {
    val out = new ByteArrayOutputStream()
    new MsgOutBuffer(out)
  }
}
