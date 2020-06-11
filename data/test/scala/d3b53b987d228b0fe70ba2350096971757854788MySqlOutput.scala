package com.mediav.mysqlproxy.protocol.io

import java.nio.charset.Charset

/**
  * An output that write basic mysql data types.
  * All integers are little endian.
  */
trait MySqlOutput {
  /**
    * The first part are methods for write unsigned integers.
    *
    * @param data
    */
  def write1U(data: Byte): Unit

  def write2U(data: Short): Unit

  def write3U(data: Int): Unit

  def write4U(data: Int): Unit

  def write6U(data: Long): Unit

  def write8U(data: Long): Unit

  /**
    * Write length encoded integer.
    *
    * @param data
    */
  def writeInteger(data: Long): Unit

  /**
    * Write fixed length bytes.
    *
    * @param data
    * @param start
    * @param length
    */
  def writeBytes(data: Seq[Byte], start: Int, length: Int): Unit

  def writeBytes(data: Byte*): Unit = {
    writeBytes(data, 0, data.length)
  }

  def writeString(data: String): Unit = {
    writeBytes(data.getBytes(Charset.forName("UTF-8")):_*)
  }

  /**
    * Write null terminated bytes.
    *
    * @param data
    * @param start
    * @param length
    */
  def writeNullTerminatedBytes(data: Seq[Byte], start: Int, length: Int): Unit = {
    writeBytes(data, start, length)
    writeBytes(0x00.toByte)
  }

  def writeNullTerminatedBytes(data: Byte*): Unit = {
    writeNullTerminatedBytes(data, 0, data.length)
  }

  def writeNullTerminatedString(data: String): Unit = {
    writeNullTerminatedBytes(data.getBytes(Charset.forName("UTF-8")):_*)
  }

  /**
    * If other methods are called after this method, an IllegalStateException will be thrown.
    * @param data
    * @param start
    * @param length
    */
  def writeEOFBytes(data: Seq[Byte], start: Int, length: Int): Unit
  def writeEOFBytes(data: Byte*): Unit = {
    writeEOFBytes(data, 0, data.length)
  }
  def writeEOFString(data: String): Unit = {
    writeEOFBytes(data.getBytes(Charset.forName("UTF-8")):_*)
  }
}

