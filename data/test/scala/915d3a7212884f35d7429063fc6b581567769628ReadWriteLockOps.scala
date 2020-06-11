package net.bzdyl.memoryfs
import java.util.concurrent.locks.ReentrantReadWriteLock
import java.util.concurrent.locks.Lock

trait ReadWriteLockOps {
  private[this] val lock = new ReentrantReadWriteLock
  private[this] val readLock = lock.readLock()
  private[this] val writeLock = lock.writeLock()
  
  private def withLock[T](lock: Lock)(op: => T) = {
    try {
      lock.lock()
      op
    } finally {
      lock.unlock()
    }
  }
  
  def withReadLock[T](op: => T) = withLock(readLock) { op }
  def withWriteLock[T](op: => T) = withLock(writeLock) { op }
}