package gameengine.impl

import java.util.concurrent.atomic.AtomicReference


package object pimps {
	implicit class AtomicReferencePimps[T](val ar: AtomicReference[T]) {
		/**
		 * Try to compare-and-set the value until it succeeds
		 * @param f Function that transforms the current value to the new value
		 * @note f MUST NOT have any side effects, since it is executed until the compare-and-set operation succeeds
		 */
		def transform(f: T => T) {
			var oldV: Option[T] = None
			var newV: Option[T] = None
			do {
				oldV = Some(ar.get)
				newV = Some(f(oldV.get))
			} while(!ar.compareAndSet(oldV.get, newV.get))
		}
	}
}
