package aio
package buffer

import java.nio.ByteBuffer
import java.util.concurrent.atomic.AtomicBoolean

import scala.math.min

/**
 *
 */
class DumpByteBuffer(

    private[this] final val buffer: ByteBuffer) {

  final def dump: String = dump(Int.MaxValue)

  final def dump(length: Int): String = {
    val builder = new StringBuilder(min(buffer.remaining, length) * 5)
    builder.append(s"${buffer}\n")
    if (buffer.hasArray) {
      DumpByteBuffer.dump(builder, buffer.array, buffer.position, min(buffer.remaining, length))
    } else {
      val a = new Array[Byte](buffer.position + buffer.remaining)
      val p = buffer.position
      buffer.get(a, p, buffer.remaining)
      buffer.position(p)
      DumpByteBuffer.dump(builder, a, buffer.position, min(buffer.remaining, length))
    }
  }

}

/**
 *
 */
object DumpByteBuffer {

  final def dump(builder: StringBuilder, array: Array[Byte], offset: Int, length: Int): String = try {
    val HEXCHAR = Array[Char]('0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f')
    @inline def dumpOffset(i: Int) = {
      builder.append(s"\n${String.format("%08x", Integer.valueOf(i * 16))}  ")
    }
    @inline def dumpHex(i: Int) = {
      for (j ← 0 to 15 if i * 16 + j < length) {
        val pos = ((i * 16) + j)
        builder.append((HEXCHAR((array(offset + pos) & 0x00f0) >> 4))).append((HEXCHAR(array(offset + pos) & 0x000f))).append(" ")
      }
      if (length / 16 == i) for (k ← 0 until (16 - (length % 16))) builder.append("   ")
    }
    @inline def dumpChar(i: Int) = {
      builder.append("     ")
      for (j ← 0 to 15 if i * 16 + j < length) {
        val pos = ((i * 16) + j)
        val c = array(offset + pos).toChar
        builder.append(if (31 < c && c < 255) c else ".")
      }
    }
    builder.append("position--0--1--2--3--4--5--6--7--8--9--A--B--C--D--E--F-------0123456789ABCDEF")
    for (i ← 0 to (if (0 == length % 16) length / 16 - 1 else length / 16)) {
      dumpOffset(i)
      dumpHex(i)
      dumpChar(i)
    }
    builder.toString
  } catch {
    case e: Throwable ⇒ s"dump failed : $e"
  }

}
