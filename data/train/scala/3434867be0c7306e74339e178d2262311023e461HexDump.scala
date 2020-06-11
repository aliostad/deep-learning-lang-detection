package com.socrata.util.io

import java.io.{ByteArrayInputStream, PrintStream, InputStream}

object HexDump {
  def fromStream(in: InputStream, out: PrintStream = Console.out) {
    var offset = 0
    val size = 16
    val buf = new Array[Byte](size)
    var end = 0

    def dump() {
      if(end != 0) {
        out.printf("%08x  ", Integer.valueOf(offset))
        var i = 0
        while(i != end) {
          out.printf("%02x ", Integer.valueOf(buf(i) & 0xff))
          if(i == 7) out.print(' ')
          i += 1
        }
        while(i != size) {
          out.print("   ")
          if(i == 7) out.print(' ')
          i += 1
        }
        out.print(" |")
        i = 0
        while(i != end) {
          val b = buf(i)
          if(b >= 32 && b < 127) out.print(b.toChar)
          else out.print('.')
          i += 1
        }
        out.println('|')
        offset += end
        end = 0
      }
    }

    while(true) {
      in.read(buf, end, size - end) match {
        case -1 =>
          dump()
          return
        case n =>
          end += n
          if(n == size) dump()
      }
    }
  }

  def fromByteArray(bs: Array[Byte], out: PrintStream = Console.out) {
    fromStream(new ByteArrayInputStream(bs), out)
  }
}
