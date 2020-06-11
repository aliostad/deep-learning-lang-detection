package com.vandyapps.pubserver

import annotation.tailrec
import java.util.concurrent.atomic.AtomicReference
 
object Nuclear {
  def apply[T]( obj : T) =
    new Nuclear(new AtomicReference(obj))
    
  implicit def atomic2nuclear[T]( ref : AtomicReference[T]) : Nuclear[T] =
    new Nuclear(ref)
}
 
class Nuclear[T](val atomic : AtomicReference[T]) {
  @tailrec
  final def update(f: T => T) : T = {
    val oldValue = atomic.get()
    val newValue = f(oldValue)
    if (atomic.compareAndSet(oldValue, newValue)) newValue else update(f)
  }
 
  def get() = atomic.get()
}