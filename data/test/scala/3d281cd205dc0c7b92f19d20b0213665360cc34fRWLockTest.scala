package com.srednal.snug

import org.scalatest._

class RWLockTest extends WordSpec with Matchers {

  "The RWLock" should {

    "create a unique lock" in {
      RWLock().lock should not be RWLock().lock
    }

    "get and release a read lock" in {
      val rwl = RWLock()
      rwl.read {rwl.lock.getReadHoldCount -> rwl.lock.getWriteHoldCount} shouldBe 1 -> 0
      rwl.lock.getReadHoldCount shouldBe 0
      rwl.lock.getWriteHoldCount shouldBe 0
    }

    "be reentrant for reads" in {
      val rwl = RWLock()
      rwl.read {rwl.read {rwl.lock.getReadHoldCount}} shouldBe 2
      rwl.lock.getReadHoldCount shouldBe 0
    }

    "get and release a write lock" in {
      val rwl = RWLock()
      rwl.write {rwl.lock.getReadHoldCount -> rwl.lock.getWriteHoldCount} shouldBe 0 -> 1
      rwl.lock.getReadHoldCount shouldBe 0
      rwl.lock.getWriteHoldCount shouldBe 0
    }

    "be reentrant for writes" in {
      val rwl = RWLock()
      rwl.write {rwl.write {rwl.lock.getWriteHoldCount}} shouldBe 2
      rwl.lock.getWriteHoldCount shouldBe 0
    }

    "not deadlock for write within read" in {
      val rwl = RWLock()
      rwl.read {rwl.write {rwl.lock.getReadHoldCount -> rwl.lock.getWriteHoldCount} -> rwl.lock.getReadHoldCount} shouldBe 1 -> 1 -> 1
      rwl.lock.getReadHoldCount shouldBe 0
      rwl.lock.getWriteHoldCount shouldBe 0
    }

    "nest ridiculously" in {
      val rwl = RWLock()
      rwl.read {
        rwl.read {
          rwl.write {
            rwl.write {
              rwl.read {
                rwl.read {
                  rwl.write {
                    rwl.lock.getReadHoldCount -> rwl.lock.getWriteHoldCount
                  }
                }
              }
            }
          }
        }
      } shouldBe 4 -> 3
    }
  }
}
