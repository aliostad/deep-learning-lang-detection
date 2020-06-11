package org.livefx.core.syntax.std

import java.util.concurrent.atomic.AtomicReference

import scala.annotation.tailrec

package object atomicReference {
  implicit class AtomicReferenceOps_YYKh2cf[A](val self: AtomicReference[A]) extends AnyVal {
    def update[B](f: A => A): (A, A) = {
      @tailrec
      def go(oldValue: A): (A, A) = {
        val newValue = f(oldValue)
        val currentValue = self.getAndSet(newValue)

        if (currentValue != oldValue) {
          go(currentValue)
        } else {
          (oldValue, newValue)
        }
      }

      go(self.get())
    }
  }
}
