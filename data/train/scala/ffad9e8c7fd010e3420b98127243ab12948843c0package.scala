package org.pico.atomic.syntax.std

import java.util.concurrent.atomic.AtomicBoolean

import scala.annotation.tailrec

package object atomicBoolean {
  implicit class AtomicBooleanOps_YYKh2cf(val self: AtomicBoolean) extends AnyVal {
    /** Repeatedly attempt to update the reference using the update function f
      * until the condition is satisfied and is able to set it atomically.
      * @param f The function to transform the current reference
      * @param cond The value predicate
      * @return An old value and a new value if an update happened
      */
    @inline
    final def updateIf(cond: Boolean => Boolean, f: Boolean => Boolean): Option[(Boolean, Boolean)] = {
      @tailrec
      def go(): Option[(Boolean, Boolean)] = {
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
    
    /** Repeatedly attempt to update the value using the update function f until able to
      * set it atomically.
      * @param f The function to transform the current value
      * @return A pair of the old and new values
      */
    def update(f: Boolean => Boolean): (Boolean, Boolean) = {
      updateIf(_ => true, f).get //Safe to call .get by construction, the predicate is hardcoded to be true
    }

    /** Atomically swap a value for the existing value in an AtomicBoolean.  Same as getAndSet.
      *
      * @param newValue The new value to atomically swap into the AtomicBoolean
      * @return The old value that was swapped out.
      */
    @inline
    final def swap(newValue: Boolean): Boolean = self.getAndSet(newValue)

    /** Get the value
      *
      * @return The value
      */
    @inline
    final def value: Boolean = self.get
  }
}
