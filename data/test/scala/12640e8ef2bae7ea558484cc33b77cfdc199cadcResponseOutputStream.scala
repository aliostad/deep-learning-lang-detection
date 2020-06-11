package net.koofr.play.ws.util

import scala.concurrent.Promise
import java.io.PipedOutputStream

class ResponseOutputStream(responsePromise: Promise[Unit]) extends PipedOutputStream {
  private[this] var isFirstWrite = true

  def onFirstWrite() = {
    isFirstWrite = false
    responsePromise.success(())
  }

  override def write(bytes: Array[Byte]) = {
    if (isFirstWrite) onFirstWrite()
    super.write(bytes)
  }

  override def write(bytes: Array[Byte], offset: Int, length: Int) = {
    if (isFirstWrite) onFirstWrite()
    super.write(bytes, offset, length)
  }

  override def write(ch: Int) = {
    if (isFirstWrite) onFirstWrite()
    super.write(ch)
  }
}
