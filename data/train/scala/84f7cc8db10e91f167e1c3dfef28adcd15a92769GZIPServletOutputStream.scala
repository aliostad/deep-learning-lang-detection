package com.outr.net.http.servlet

import java.io.OutputStream
import javax.servlet.{WriteListener, ServletOutputStream}
import java.util.zip.GZIPOutputStream

/**
 * @author Matt Hicks <matt@outr.com>
 */
class GZIPServletOutputStream(out: OutputStream) extends ServletOutputStream {
  val output = new GZIPOutputStream(out)

  override def close() = {
    output.finish()
    output.flush()
    output.close()
  }

  override def flush() = output.flush()

  override def write(b: Array[Byte], off: Int, len: Int) = output.write(b, off, len)

  override def write(b: Array[Byte]) = output.write(b)

  def write(b: Int) = output.write(b)

  override def isReady = true

  override def setWriteListener(writeListener: WriteListener) = throw new UnsupportedOperationException("setWriteListener is not supported yet")
}
