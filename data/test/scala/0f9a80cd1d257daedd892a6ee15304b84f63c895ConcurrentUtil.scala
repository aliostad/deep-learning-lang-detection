package isabelle.eclipse.core.util

import java.util.concurrent.locks.{Lock, ReadWriteLock}


/**
 * Utility classes and methods related to concurrency uses
 *
 * @author Andrius Velykis
 */
object ConcurrentUtil {

  /**
   * A wrapper for ReadWriteLock to allow functional style (more concise) usage
   * 
   * @author Andrius Velykis
   */
  implicit class FunReadWriteLock(val rwLock: ReadWriteLock) {
    
    def read[R] = withLock[R](rwLock.readLock) _
    def write[R] = withLock[R](rwLock.writeLock) _

    def withLock[R](lock: Lock)(f: => R): R = {
      lock.lock
      val res = f
      lock.unlock
      
      res
    }
  }

}
