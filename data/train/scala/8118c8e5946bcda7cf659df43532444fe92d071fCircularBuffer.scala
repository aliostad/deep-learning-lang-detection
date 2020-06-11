package com.gilt.gfc.collection

/**
 * Simple circular buffer class, which supports adding a new item,
 * finding the oldest item, the newest item, or iterating from oldest
 * to newest.  Not thread safe.
 */
class CircularBuffer[@specialized T: Manifest](capacity: Int) extends Iterable[T] {
  var nextWrite = 0
  var full = false
  val buffer = new Array[T](capacity)

  def add(item: T) {
    if (nextWrite == capacity) {
      nextWrite = 0
      full = true
    }
    buffer(nextWrite) = item
    nextWrite += 1
  }

  def oldest: T = {
    if (full) {
      if (nextWrite == capacity) {
        buffer(0)
      } else {
        buffer(nextWrite)
      }
    } else {
      assert(nextWrite != 0, "no data yet")
      buffer(0)
    }
  }

  def newest: T = {
    if (full) {
      if (nextWrite == 0) {
        buffer.last
      } else {
        buffer(nextWrite - 1)
      }
    } else {
      assert(nextWrite != 0, "no data yet")
      buffer(nextWrite - 1)
    }
  }

  override def size: Int = {
    if (!full) {
      nextWrite
    } else {
      capacity
    }
  }

  def iterator: Iterator[T] = {
    if (full) {
      (buffer.drop(nextWrite).take(buffer.size - nextWrite) ++ buffer.take(nextWrite)).toIterator
    } else {
      if (nextWrite == 0) {
        new Iterator[T] {
          def hasNext = false

          def next() = 0.asInstanceOf[T]
        }
      } else {
        buffer.take(nextWrite).toIterator
      }
    }
  }
}
