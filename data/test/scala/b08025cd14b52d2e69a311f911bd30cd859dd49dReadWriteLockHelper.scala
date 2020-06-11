package com.yaochin.battleship.util

import java.util.concurrent.locks.{ReentrantReadWriteLock, ReadWriteLock}

/**
  * Created on 2/1/17.
  */
trait ReadWriteLockHelper {

  protected val readWriteLock: ReadWriteLock = new ReentrantReadWriteLock()

  def withReadLock[T](f: => T): T = {
    try {
      readWriteLock.readLock().lock()
      f
    } finally {
      readWriteLock.readLock().unlock()
    }
  }

  def withWriteLock[T](f: => T): T = {
    try {
      readWriteLock.writeLock().lock()
      f
    } finally {
      readWriteLock.writeLock().unlock()
    }
  }

}
