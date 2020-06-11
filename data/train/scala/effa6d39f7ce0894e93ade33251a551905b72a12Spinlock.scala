package oslib

import scalanative.native._

@struct class Spinlock (
  var l: Ptr[Int],
  var desc: CString
)

@extern object nativeAtomic {
  def atomic_compare_exchange_weak(obj: Ptr[Int], expected: Ptr[Int], desired: Int): Boolean = extern
  def atomic_store(obj: Ptr[Int], desr: Int): Unit = extern
}

object Spinlock {
    def create(lock: Spinlock, description: CString): Spinlock = {
        !lock.l = 0
        lock.desc = description
        lock
    }
    
    def acquire(lock: Spinlock): Unit = {
        var old = stackalloc[Int]
        !old = 0
        
        while(!nativeAtomic.atomic_compare_exchange_weak(lock.l, old, 1)) {
            !old = 0
        }
    }
    
    def release(lock: Spinlock): Unit = {
        nativeAtomic.atomic_store(lock.l, 0)
    }
}