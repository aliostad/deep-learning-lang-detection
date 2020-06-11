package cjdns.util.concurrent

import java.util.concurrent.locks.{ReentrantReadWriteLock, ReadWriteLock}

/**
 * User: willzyx
 * Date: 01.07.13 - 0:30
 */
class ReadWriteLockWrapper(rwLock: ReadWriteLock) {

  def read[T](f: => T): T = {
    val lock = rwLock.readLock
    lock.lock()
    try {
      f
    } finally {
      lock.unlock()
    }
  }

  def write[T](f: => T): T = {
    val lock = rwLock.writeLock
    lock.lock()
    try {
      f
    } finally {
      lock.unlock()
    }
  }

  def tryRead[T](f: => T): Option[T] = {
    val lock = rwLock.readLock
    if (lock.tryLock) {
      try {
        Option(f)
      } finally {
        lock.unlock()
      }
    } else None
  }

}

object ReadWriteLockWrapper {
  def allocate = new ReadWriteLockWrapper(new ReentrantReadWriteLock)
}