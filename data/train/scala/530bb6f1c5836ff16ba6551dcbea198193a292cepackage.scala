package org.pico.atomic.syntax.std

import java.util.concurrent.atomic.AtomicReference

import scala.annotation.tailrec

package object atomicReference {
  implicit class AtomicReferenceOps_YYKh2cf[A](val self: AtomicReference[A]) extends AnyVal {
  
    /** Repeatedly attempt to update the reference using the update function f
      * until the condition is satisfied and is able to set it atomically.
      * @param f The function to transform the current reference
      * @param cond The value predicate
      * @return An old value and a new value if an update happened
      */
    @inline
    final def updateIf(cond: A => Boolean, f: A => A): Option[(A, A)] = {
      @tailrec
      def go(): Option[(A, A)] = {
        val oldValue = self.get()
        val isOk = cond(oldValue)
      
        if (!isOk) None
        else {
          val newValue = f(oldValue)
          if (self.compareAndSet(oldValue, newValue)) Some(oldValue -> newValue)
          else go()
        }
      }
      go()
    }
    
    /** Repeatedly attempt to update the reference using the update function f until able to
      * set it atomically.
      * @param f The function to transform the current reference
      * @return A pair of the old and new values
      */
    @inline
    final def update(f: A => A): (A, A) = {
      updateIf(_ => true, f).get //Safe to call .get by construction, the predicate is hardcoded to be true
    }
    
    /** Atomically swap a value for the existing value in an atomic reference.  Same as getAndSet.
      *
      * @param newValue The new value to atomically swap into the atomic reference
      * @return The old value that was swapped out.
      */
    @inline
    final def swap(newValue: A): A = self.getAndSet(newValue)

    /** Get the value
      *
      * @return The value
      */
    @inline
    final def value: A = self.get
  }
}
