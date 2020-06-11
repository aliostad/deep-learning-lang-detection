package com.gilt.opm.lock

import com.gilt.opm.utils.RichLongForMeasurement
import org.scalatest.{BeforeAndAfterAll, FunSuite}
import org.scalatest.Matchers
import com.gilt.opm.CollectionHelper
import RichLongForMeasurement._

/**
 * Document Me.
 *
 * @author Eric Bowman
 * @since 1/9/13 9:54 AM
 */
class LockReaperTest extends FunSuite with Matchers with LockManager with CollectionHelper with BeforeAndAfterAll {
  self =>
  override val collectionName = "opm_LockReaperTest"

  // If the lock is taken, wait up to this long to retrieve it
  override val waitMs = 500L

  // If the lock is taken, sleep this long before trying again
  override val sleepMs = 10L

  test("a lock left long enough should be reaped if the reaper is running, and not if it is not") {
    val reaper = new LockReaper {
      override def periodMs = 100.milliseconds

      override def initialDelayMs = 0.milliseconds

      override def maxLifespanMs = 2 * waitMs

      def locks = self.locks
    }

    reaper.startReaper()
    val aLock = lock("oldLock")
    an [RuntimeException] should be thrownBy lock("oldLock")
    Thread.sleep(reaper.maxLifespanMs + 1)
    lock("oldLock")
    aLock.unlock()
    reaper.stopReaper()

    lock("oldLock")
    an [RuntimeException] should be thrownBy lock("oldLock")
    Thread.sleep(reaper.maxLifespanMs + 1)
    an [RuntimeException] should be thrownBy lock("oldLock")
  }
}
