package com.anakiou.modbus.io

import java.io.DataOutput
import java.io.DataOutputStream

class BytesOutputStream(size: Int) extends FastByteArrayOutputStream(size) with DataOutput {

  private var dout: DataOutputStream = new DataOutputStream(this)

  def this(buffer: Array[Byte]) {
    this(buffer.length)
    buf = buffer
    count = 0
    dout = new DataOutputStream(this)
  }

  override def getBuffer(): Array[Byte] = buf

  override def reset() {
    count = 0
  }

  def writeBoolean(v: Boolean) {
    dout.writeBoolean(v)
  }

  def writeByte(v: Int) {
    dout.writeByte(v)
  }

  def writeShort(v: Int) {
    dout.writeShort(v)
  }

  def writeChar(v: Int) {
    dout.writeChar(v)
  }

  def writeInt(v: Int) {
    dout.writeInt(v)
  }

  def writeLong(v: Long) {
    dout.writeLong(v)
  }

  def writeFloat(v: Float) {
    dout.writeFloat(v)
  }

  def writeDouble(v: Double) {
    dout.writeDouble(v)
  }

  def writeBytes(s: String) {
    val len = s.length
    for (i <- 0 until len) {
      this.write(s.charAt(i).toByte)
    }
  }

  def writeChars(s: String) {
    dout.writeChars(s)
  }

  def writeUTF(str: String) {
    dout.writeUTF(str)
  }
}
