package monitoring.atomic

import annotation.tailrec
import java.util.concurrent.atomic.AtomicReference

object Atomic {
  def apply[T]( obj : T) = new Atomic(new AtomicReference(obj))
  implicit def toAtomic[T]( ref : AtomicReference[T]) : Atomic[T] = new Atomic(ref)
}

class Atomic[T](val atomic : AtomicReference[T]) {
  @tailrec
  final def update(f: T => T) : T = {
    val oldValue = atomic.get()
    val newValue = f(oldValue)
    if (atomic.compareAndSet(oldValue, newValue)) newValue else update(f)
  }

  def get() = atomic.get()
}