package de.otds.exi.util

import java.io.OutputStream
import java.util.logging.Logger

class IgnoreCloseOutputStream(os: OutputStream) extends OutputStream {
  private val log = Logger.getLogger(getClass.getName)

  override def write(b: Int): Unit = os.write(b)

  override def flush(): Unit = os.flush()

  override def write(b: Array[Byte]): Unit = os.write(b)

  override def write(b: Array[Byte], off: Int, len: Int): Unit = os.write(b, off, len)

  override def close(): Unit = {
    log.fine("Ignore close")
  }
}
