package com.ibm.haploid.io

import java.io.InputStream
import java.io.OutputStream
import java.nio.ByteBuffer

trait BinaryOutput {

  def writeBoolean(v: Boolean)
  def writeByte(v: Byte)
  def writeChar(v: Char)
  def writeShort(v: Short)
  def writeInt(v: Int)
  def writeLong(v: Long)
  def writeDouble(v: Double)
  def writeShortString(v: String)
  def writeString(v: String)
  def writeMap(v: Map[String, Any])
  def writeList(v: List[Any])
  def writeOption(v: Option[Any])

}

trait BinaryInput {

  def readBoolean: Boolean
  def readByte: Byte
  def readChar: Char
  def readShort: Short
  def readInt: Int
  def readLong: Long
  def readDouble: Double
  def readShortString: String
  def readString: String
  def readMap: Map[String, Any]
  def readList: List[Any]
  def readOption: Option[Any]

}

final class BinaryFormatByteBuffer(
  private[this] val buffer: ByteBuffer,
  private[this] var position: Int,
  limit: Int) extends BinaryInput {

  def writeBoolean(v: Boolean) = {
    buffer.put(advance(1), if (v) 1 else 0); ()
  }

  def writeByte(v: Byte) = {
    buffer.put(advance(1), v); ()
  }

  def writeChar(v: Char) = {
    buffer.putChar(advance(2), v); ()
  }

  def writeShort(v: Short) = {
    buffer.putShort(advance(2), v); ()
  }

  def writeInt(v: Int) = {
    buffer.putInt(advance(4), v); ()
  }

  def writeLong(v: Long) = {
    buffer.putLong(advance(8), v); ()
  }

  def writeDouble(v: Double) = {
    buffer.putLong(advance(8), java.lang.Double.doubleToLongBits(v)); ()
  }

  def writeShortString(v: String) = {
    writeByte(v.length.toByte)
    var i = 0; while (i < v.length) { buffer.putChar(advance(2), v.charAt(i)); i += 1 }
  }

  def writeString(v: String) = {
    writeInt(v.length)
    var i = 0; while (i < v.length) { buffer.putChar(advance(2), v.charAt(i)); i += 1 }
  }

  def writeMap(v: Map[String, Any]) = {
    writeByte(v.size.toByte)
    v.toList.foreach {
      case (k, v) =>
        writeString(k)
        writeAny(v)
    }
  }

  def writeList(v: List[Any]) = {
    writeByte(v.size.toByte)
    v.foreach(writeAny)
  }

  def writeOption(v: Option[Any]) = {
    writeBoolean(v.isDefined)
    v match {
      case None =>
      case Some(v) => writeAny(v)
    }
  }

  def readBoolean: Boolean = {
    0 != buffer.get(advance(1))
  }

  def readByte: Byte = {
    buffer.get(advance(1))
  }

  def readChar: Char = {
    buffer.getChar(advance(2))
  }

  def readShort: Short = {
    buffer.getShort(advance(2))
  }

  def readInt: Int = {
    buffer.getInt(advance(4))
  }

  def readLong: Long = {
    buffer.getLong(advance(8))
  }

  def readDouble: Double = {
    java.lang.Double.longBitsToDouble(readLong)
  }

  def readShortString: String = {
    new String(Array.fill(readByte)(readChar))
  }

  def readString: String = {
    new String(Array.fill(readInt)(readChar))
  }

  def readMap: Map[String, Any] = {
    val len = readByte
    (0 until len).foldLeft(Map[String, Any]()) { case (m, _) => m ++ Map(readString -> readAny) }
  }

  def readList: List[Any] = {
    val len = readByte
    (0 until len).foldLeft(List[Any]()) { case (l, _) => l ++ List(readAny) }
  }

  def readOption: Option[Any] = {
    if (readBoolean) Some(readAny) else None
  }

  private[this] def writeType(v: Any): Unit = {
    writeByte((v: @unchecked) match {
      case _: Boolean => 1
      case _: Byte => 2
      case _: Char => 3
      case _: Short => 4
      case _: Int => 5
      case _: Long => 6
      case _: Double => 7
      case v: String if 128 > v.length => 8
      case _: String => 9
      case _: Map[_, _] => 100
      case _: List[_] => 101
      case _: Option[_] => 102
      case _ => throw new UnsupportedOperationException(v.getClass.getName)
    })
  }

  private[this] def writeAny(v: Any): Unit = {
    writeType(v)
    (v: @unchecked) match {
      case v: Boolean => writeBoolean(v)
      case v: Byte => writeByte(v)
      case v: Char => writeChar(v)
      case v: Short => writeShort(v)
      case v: Int => writeInt(v)
      case v: Long => writeLong(v)
      case v: Double => writeDouble(v)
      case v: String if 128 > v.length => writeShortString(v)
      case v: String => writeString(v)
      case v: Map[_, _] => writeMap(v.asInstanceOf[Map[String, Any]])
      case v: List[_] => writeList(v.asInstanceOf[List[Any]])
      case v: Option[_] => writeOption(v.asInstanceOf[Option[Any]])
      case _ => throw new UnsupportedOperationException(v.getClass.getName)
    }
  }

  private[this] def readAny: Any = {
    readByte match {
      case 1 => readBoolean
      case 2 => readByte
      case 3 => readChar
      case 4 => readShort
      case 5 => readInt
      case 6 => readLong
      case 7 => readDouble
      case 8 => readShortString
      case 9 => readString
      case 100 => readMap
      case 101 => readList
      case 102 => readOption
      case invalid => throw new UnsupportedOperationException("Invalid type : " + invalid)
    }
  }

  @inline private[this] def advance(by: Int) = {
    val p = position
    position += by
    p
  }

}
