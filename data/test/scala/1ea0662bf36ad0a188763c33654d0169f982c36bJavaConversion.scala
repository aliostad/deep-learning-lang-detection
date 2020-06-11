package org.photon.common

import java.util.concurrent.locks.ReentrantReadWriteLock

object JavaConversion {
	import scala.language.implicitConversions

	implicit def fn2runnable(fn: => Unit) = new Runnable {
		def run = fn
	}

	implicit class RichReentrantReadWriteLock(val l: ReentrantReadWriteLock) extends AnyVal {
		def write[R](fn: => R): R = {
			l.writeLock.lock()
			try {
				fn
			} finally {
				l.writeLock.unlock()
			}
		}

		def read[R](fn: => R): R = {
			l.readLock.lock()
			try {
				fn
			} finally {
				l.readLock.unlock()
			}
		}
	}
}
