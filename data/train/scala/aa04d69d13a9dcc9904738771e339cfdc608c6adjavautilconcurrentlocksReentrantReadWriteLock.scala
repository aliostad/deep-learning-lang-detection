package insane
package predefined

import annotations._

@AbstractsClass("java.util.concurrent.locks.ReentrantReadWriteLock")
abstract class javautilconcurrentlocksReentrantReadWriteLock {
  @AbstractsMethod("java.util.concurrent.locks.ReentrantReadWriteLock.<init>(()java.util.concurrent.locks.ReentrantReadWriteLock)")
  def ____init__(): javautilconcurrentlocksReentrantReadWriteLock = {
    this
  }
  @AbstractsMethod("java.util.concurrent.locks.ReentrantReadWriteLock.readLock(()java.util.concurrent.locks.ReentrantReadWriteLock$ReadLock)")
  def __readLock(): java.util.concurrent.locks.ReentrantReadWriteLock$ReadLock
  @AbstractsMethod("java.util.concurrent.locks.ReentrantReadWriteLock.writeLock(()java.util.concurrent.locks.ReentrantReadWriteLock$WriteLock)")
  def __writeLock(): java.util.concurrent.locks.ReentrantReadWriteLock$WriteLock
}
