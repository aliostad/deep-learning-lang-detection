package bruce.io.elf.core

import java.nio.channels.SocketChannel
import java.nio.ByteBuffer
import bruce.io.elf.util.IoUtil
import bruce.io.elf.buffer.ChannelBuffer

class NioSession(control: Control, reactor: ReadWriteReactor, private[core]channel: SocketChannel) {
  private val writeQueue = new java.util.concurrent.ConcurrentLinkedQueue[Any]
  private val attributeMap = new java.util.HashMap[String, Any]

  lazy private val buffer = ChannelBuffer(control.config.sessionBufferSize)
  private var writeBuffer: ByteBuffer = null
  @volatile private var closeAfterSent = false

  def write(message: Any) {
    if (message == null) return

    if (closeAfterSent) throw new IllegalStateException("session is closing .")

    if (writeBuffer == null) {
      writeBuffer = control.codec.encode(this, message).readableByteBuffer()
      val isFinished = writeIO() // 先写一次再注册写
      if (!isFinished) reactor.enableWrite(this)
      else if (isCloseNow()) closeNow()

    } else writeQueue.offer(message)
  }

  private def writeIO(): Boolean = {
    channel.write(writeBuffer)
    if (!writeBuffer.hasRemaining()) writeBuffer = null

    writeBuffer == null
  }

  private[core] def onWriteable() {
    if (writeBuffer != null) writeIO()
    else if (writeQueue.isEmpty())
      if (isCloseNow) closeNow() else reactor.suspendWrite(this)
    else {
      val message = writeQueue.poll()
      writeBuffer = control.codec.encode(this, message).readableByteBuffer()
      writeIO()
    }
  }

  def close(immediatly: Boolean) {
    if (closeAfterSent) return

    if (immediatly) closeNow()
    else {
      closeAfterSent = true
      if (isCloseNow()) closeNow()
    }
  }

  private def isCloseNow(): Boolean = { closeAfterSent && writeBuffer == null && writeQueue.isEmpty() }

  private def closeNow() {
    reactor.unregister(this)
    channel.close()
  }

  private[core] def onReadable() {
    val writeBuffer = buffer.writeableByteBuffer()

    val (totalReaded, isInputEnd) = IoUtil.readAllPossible(channel, writeBuffer)
    buffer.writeIndex = buffer.writeIndex + totalReaded

    if (totalReaded > 0 || (buffer.readable() > 0 && buffer.writable() <= 0)) {
      // 解码消息，直到没有消息生成或没有数据可解码
      var continue = false
      do {
        val message = control.codec.decode(this, buffer)
        if (message != null) control.handler.onMessageReceived(this, message)
        continue = message != null && buffer.readable() > 0
      } while (continue)

      buffer.discardReaded()
    }

    if (!isInputEnd) reactor.enableRead(this)
    else control.handler.onSessionClosed(this) // 客户端关闭连接
  }

  def focusRead() { reactor.focusRead(this) }
  def focusWrite() { reactor.focusWrite(this) }
  def enableRead() { reactor.enableRead(this) }
  def enableWrite() { reactor.enableWrite(this) }
  def suspendRead() { reactor.suspendRead(this) }
  def suspendWrite() { reactor.suspendWrite(this) }

  def setAttribute(name: String, value: Any) { attributeMap.put(name, value) }
  def attribute(name: String): Any = attributeMap.get(name)
  def removeAttribute(name: String) { attributeMap.remove(name) }

}