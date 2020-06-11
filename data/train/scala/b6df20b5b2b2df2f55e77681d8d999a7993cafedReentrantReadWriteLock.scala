package scala.util.concurrent.locks

import java.util.concurrent.locks.{ReentrantReadWriteLock => JReentrantReadWriteLock}

object ReentrantReadWriteLock {
  def apply(lock: JReentrantReadWriteLock): ReentrantReadWriteLock =
    new JavaReentrantReadWriteLock(lock)
  def apply(fair: Boolean /* = false */): ReentrantReadWriteLock =
    apply(new JReentrantReadWriteLock(fair))
}

trait ReentrantReadWriteLock extends ReadWriteLock {
  def fair: Boolean
}

class JavaReentrantReadWriteLock(override val underlying: JReentrantReadWriteLock)
    extends JavaReadWriteLock(underlying) with ReentrantReadWriteLock {
  override def fair = underlying.isFair
}
