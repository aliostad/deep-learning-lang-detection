package dscript

import java.util.concurrent.locks.{ReentrantReadWriteLock, ReentrantLock}

package object synchronizers {
  def syncrhonized[T](lock: ReentrantLock)(lambda: => T) = {
    lock.lock()
    try lambda finally lock.unlock()
  }

  def synchronizedRead[T](lock: ReentrantReadWriteLock)(lambda: => T) = {
    lock.readLock().lock()
    try lambda finally lock.readLock().unlock()
  }

  def synchronizedWrite[T](lock: ReentrantReadWriteLock)(lambda: => T) = {
    lock.writeLock().lock()
    try lambda finally lock.writeLock().unlock()
  }
}
