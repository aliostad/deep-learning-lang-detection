package org.rebeam.tree.server.util

import java.util.concurrent.locks.ReentrantReadWriteLock

class RWLock() {
  private val lock: ReentrantReadWriteLock = new ReentrantReadWriteLock()

  def write[T](w: =>T): T = {
    lock.writeLock().lock()
    try {
      return w
    } finally {
      lock.writeLock().unlock()
    }
  }

  def read[T](r: =>T): T = {
    lock.readLock().lock()
    try {
      return r
    } finally {
      lock.readLock().unlock()
    }
  }
}

object RWLock {
  def apply() = new RWLock()
}
