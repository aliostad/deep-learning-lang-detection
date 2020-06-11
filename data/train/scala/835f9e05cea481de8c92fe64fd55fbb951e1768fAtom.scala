package com.codahale.yoink

import java.util.concurrent.atomic.AtomicReference

/**
 * A Scala atomic reference.
 */
class Atom[A](initial: A) {
  private val ref = new AtomicReference[A](initial)

  /**
   * Returns the atom's current value.
   */
  def value = ref.get

  /**
   * Swaps the atom's value for another value.
   *
   * N.B. f() may be called more than once. Calling swap and passing it a
   * mutator with side effects is cruising for a bruising.
   */
  def swap(f: A => A) {
    var updated = false
    while (!updated) {
      val oldValue = value
      updated = ref.compareAndSet(oldValue, f(oldValue))
    }
  }

  override def toString = ref.toString
}
