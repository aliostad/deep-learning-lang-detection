/**********************************************************************/
// Debugging dump utility.

package org.davidb.jpool

import java.nio.ByteBuffer

// TODO: Generalize output stream, instead of just using print.
// TODO: More functional.  This is a direct translation of Java/C#.

object Pdump {
  def dump(data: Array[Byte], offset: Int, length: Int) {
    val line = new StringBuilder
    val ascii = new StringBuilder

    var len = length
    var off = offset
    while (len > 0) {
      line.setLength(0)
      ascii.setLength(0)

      val lineBase = off & (~15)

      line.append(String.format("%08x: ", int2Integer(lineBase)))
      ascii.append('|')

      for (pos <- lineBase until lineBase + 16) {
        if (pos < off || pos >= off + len) {
          line.append("   ")
          ascii.append(' ')
        } else {
          val ch = data(pos)
          line.append(String.format("%02x ", int2Integer(ch & 0xff)))
          if (ch >= 32 && ch <= 126)
            ascii.append(ch.toChar)
          else
            ascii.append('.')
        }

        if ((pos & 15) == 7) {
          line.append(" ")
          // ascii.append(' ')   // Annoying.
        }
      }
      ascii.append('|')

      print(line.toString)
      print(' ')
      println(ascii.toString)

      val oldOff = off
      off = (off + 16) & (~15)
      len -= off - oldOff
    }
  }

  def dump(data: Array[Byte]): Unit = dump(data, 0, data.size)

  def dump(data: ByteBuffer): Unit =
    dump(data.array, data.arrayOffset + data.position, data.remaining)
}
