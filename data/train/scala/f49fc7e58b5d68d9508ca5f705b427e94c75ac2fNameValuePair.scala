package server.handler.FastCgi

import java.io.ByteArrayOutputStream

class NameValuePair(val name: String, val value: String) {
  def toByteArray: Array[Byte] = {
    val nameBytes = name.getBytes("UTF-8")
    val valueBytes = value.getBytes("UTF-8")
    val out = new ByteArrayOutputStream()
    writeLength(nameBytes.length, out)
    writeLength(valueBytes.length, out)
    out.write(nameBytes)
    out.write(valueBytes)
    out.toByteArray
  }

  private def writeLength(l: Int, b: ByteArrayOutputStream): Unit = {
    if(l <= 127) {
      b.write(l.toByte)
    }
    else {
      b.write(((l >> 24) | 0x80).toByte)
      b.write((l >> 16).toByte)
      b.write((l >> 8).toByte)
      b.write(l.toByte)
    }
  }
}
