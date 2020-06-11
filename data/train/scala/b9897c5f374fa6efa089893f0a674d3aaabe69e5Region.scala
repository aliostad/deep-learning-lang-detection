package bigtop
package concurrent

import java.util.concurrent.locks.{ReentrantLock,ReentrantReadWriteLock}

/** Represents a protected region. Only one thread can execute wuthin a protected region at a time */
trait Region[-T,+R] extends Function1[T,R] {

  def apply(in: T): R

}

trait LockedRegion[-T,+R] extends Region[T,R] with Lock {

  def body(in: T): R

  val mechanism = new ReentrantLock()

  def apply(in: T): R = {
    locked {
      body(in)
    }
  }

}

trait ReadWriteRegion[-T,+R] extends Region[T,R] {

  def body(in: T): R

  val mechanism = new ReentrantReadWriteLock()
  val readLock = mechanism.readLock()
  val writeLock = mechanism.writeLock()

  def read[A](f: => A): A = {
    readLock.lock()
    try {
      f
    } finally {
      readLock.unlock()
    }
  }

  def write[A](f: => A): A = {
    writeLock.lock()
    try {
      f
    } finally {
      writeLock.unlock()
    }
  }

  def apply(in: T): R = {
    body(in)
  }

}
