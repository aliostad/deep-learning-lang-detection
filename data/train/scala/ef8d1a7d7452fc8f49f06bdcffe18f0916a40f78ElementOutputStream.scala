package net.wrap_trap.goju

import java.io.{DataOutputStream, OutputStream}

/**
  * goju: HanoiDB(LSM-trees (Log-Structured Merge Trees) Indexed Storage) clone

  * Copyright (c) 2016 Masayuki Takahashi

  * This software is released under the MIT License.
  * http://opensource.org/licenses/mit-license.php
  */
class ElementOutputStream(os: OutputStream) extends AutoCloseable {

  val internal = new DataOutputStream(os)
  var p = 0L

  def writeShort(s: Short) = {
    p += 2
    this.internal.writeShort(s)
  }

  def writeInt(i: Int) = {
    p += 4
    this.internal.writeInt(i)
  }

  def writeTimestamp(l: Long) = {
    p += 4
    // write last 4bytes
    this.internal.writeInt(l.asInstanceOf[Int])
  }

  def writeLong(l: Long) = {
    p += 8
    this.internal.writeLong(l)
  }

  def writeByte(b: Byte) = {
    p += 1
    this.internal.writeByte(b)
  }

  def write(bytes: Array[Byte]) = {
    p += bytes.length
    this.internal.write(bytes)
  }

  def writeEndTag() = {
    writeByte(0xFF.asInstanceOf[Byte])
  }

  def pointer(): Long = p

  def close() = {
    try {
      this.internal.close
      p = 0L
    } catch {
      case e: Exception => ???
    }
  }
}
