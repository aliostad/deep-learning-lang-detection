import java.nio.ByteBuffer
import java.util.concurrent.locks.ReentrantReadWriteLock

package object endo {

  def withWriteLock[T](rwLock: ReentrantReadWriteLock)(body: => T): T = {
    val writeLock = rwLock.writeLock()
    writeLock.lock()
    try {
      body
    } finally {
      writeLock.unlock()
    }
  }

  def withReadLock[T](rwLock: ReentrantReadWriteLock)(body: => T): T = {
    val readLock = rwLock.readLock()
    readLock.lock()
    try {
      body
    } finally {
      readLock.unlock()
    }
  }

  def slice(buffer: ByteBuffer, offset: Int, length: Int): ByteBuffer = {
    buffer.position(offset).limit(offset + length).asInstanceOf[ByteBuffer].slice()
  }
}
