package com.mediav.mysqlproxy.protocol.io

import java.io.OutputStream

/**
  * Created by liurenjie on 21/08/2017.
  */
class MySqlOutputStream(private val output: OutputStream) extends MySqlOutput {
  private var closed = false

  /**
    * The first part are methods for write unsigned integers.
    *
    * @param data
    */
  override def write1U(data: Byte): Unit = writeNumber(data, 1)

  override def write2U(data: Short): Unit = writeNumber(data, 2)

  override def write3U(data: Int): Unit = writeNumber(data, 3)

  override def write4U(data: Int): Unit = writeNumber(data, 4)

  override def write6U(data: Long): Unit = writeNumber(data, 6)

  override def write8U(data: Long): Unit = writeNumber(data, 8)

  /**
    * Write length encoded integer.
    *
    * @param data
    */
  override def writeInteger(data: Long): Unit = {
    checkNotClosed
    data match {
      case t if t >=0 && t <= 250 =>
        output.write(data.toByte)
      case t if t >=0 && t <= 0xFFFF =>
        output.write(0xFC)
        writeNumber(data, 2)
      case t if t >=0 && t <= 0xFFFFFF =>
        output.write(0xFD)
        writeNumber(data, 3)
      case _ =>
        output.write(0xFE)
        writeNumber(data, 8)
    }
  }

  /**
    * Write fixed length bytes.
    *
    * @param data
    * @param start
    * @param length
    */
  override def writeBytes(data: Seq[Byte], start: Int, length: Int): Unit = {
    checkNotClosed
    require(length >= 0, s"Invalid length: ${length}")
    data.view(start, start + length)
      .foreach(x => output.write(x))
  }

  /**
    * If other methods are called after this method, an IllegalStateException will be thrown.
    *
    * @param data
    * @param start
    * @param length
    */
  override def writeEOFBytes(data: Seq[Byte], start: Int, length: Int): Unit = {
    checkNotClosed
    writeBytes(data, start, length)
    output.flush()
    output.close()
    closed = true
  }

  private def writeNumber(value: Long, numBytes: Int): Unit = {
    checkNotClosed
    (0 until numBytes).map(8*_)
      .map(b => (value & (0xFF << b)) >> b)
      .map(_.toInt)
      .foreach(output.write)
  }

  private def checkNotClosed: Unit = {
    require(!closed, "Stream already closed!")
  }
}
