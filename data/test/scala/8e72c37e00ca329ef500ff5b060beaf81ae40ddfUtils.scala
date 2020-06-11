package im.xun.shadowriver

import java.nio.ByteBuffer

import akka.util.ByteString

object Utils {

  def bytesToHexStr(bytes: Seq[Byte], sep: String = "", lineBreak: Int=16, ascLine: Boolean = false): String = {
    val sb = new StringBuilder
    val line = new StringBuilder
    val bLine = new StringBuilder
    for((b,i) <- bytes.view.zipWithIndex) {
      bLine.append("%C ".format(b))
      if ((i+1) % lineBreak == 0) {
        if(ascLine) {
          line.append("%02X | %s\n".format(b, bLine.toString()))
        } else {
          line.append("%02X\n".format(b))
        }
        sb.append(line.toString())
        bLine.clear()
        line.clear()
      } else {
        line.append("%02X%s".format(b, sep))
      }
    }

    sb.toString()
//    bytes.map("%02X".format(_)).mkString(sep)
  }
//  println(bytesToHexStr("adfasdfasdfasdf3rwe9-q4-9rjefnagagsdg".getBytes," "))
//  hexdump
  def bytesFromHexStr(hexStr: String, sep: String = "") = {
    hexStr.trim.replace(sep,"").replace("\n","").replaceAll(" +","")
      .sliding(2, 2).toArray.map(Integer.parseInt(_, 16).toByte)
  }


  def dumpBytes(buf: ByteString): Unit = {
    dumpBytes(buf.asByteBuffer)
  }
  def dumpBytes(buf: ByteBuffer): Unit = {
    dumpBytes(buf, buf.limit())
  }

  def dumpBytes(buf: ByteBuffer, size: Int ): Unit = {
    log.info("Dump bytes:")
    val sb = new StringBuilder
    0 until size map { i =>
      if(i % 16 == 0) {
        sb.append("\n")
      }
      sb.append("%02X ".format(buf.get(i)))
    }
    sb.append("\n")
    log.info(sb.toString)
  }
}
