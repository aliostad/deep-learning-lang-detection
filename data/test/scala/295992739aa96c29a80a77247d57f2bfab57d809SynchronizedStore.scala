package com.futurenotfound.scalastore




import scala.actors.threadpool.locks.ReentrantReadWriteLock

class SynchronizedStore[T](private val innerStore: Store[T]) extends Store[T] {
  private val lock = new ReentrantReadWriteLock()
  private val readLock = lock.readLock()
  private val writeLock = lock.writeLock
  def lookup(key: String): Option[T] = {
    readLock.lock()
    try
    {
      innerStore.lookup(key)
    }
    finally readLock.unlock()
  }
  def update(key: String, update: Update[T]): Option[T] = {
    writeLock.lock()
    try
    {
      innerStore.update(key, update)
    }
    finally writeLock.unlock()
  }
}
