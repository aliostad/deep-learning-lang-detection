package scaster.utils

import java.io.DataOutputStream

object NativesHelper {
  def writeUInt32(uint32: Long, stream: DataOutputStream): Unit = {
    writeUInt16(((uint32 & 0xffff0000) >> 16).asInstanceOf[Int], stream)
    writeUInt16((uint32 & 0x0000ffff).asInstanceOf[Int], stream)
  }

  def writeUInt16(uint16: Int, stream: DataOutputStream): Unit = {
    writeUInt8(uint16 >> 8, stream)
    writeUInt8(uint16, stream)
  }

  def writeUInt8(uint8: Int, stream: DataOutputStream): Unit = {
    stream.write(uint8 & 0xFF)
  }
}
