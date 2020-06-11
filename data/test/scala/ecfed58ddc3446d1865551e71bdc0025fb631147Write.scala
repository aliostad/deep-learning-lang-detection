package io.coppermine
package internal

import java.nio._
import java.util.UUID

trait Write[A] {
  def write(buf: ByteBuffer, value: A): Unit
}

object Write {
  def apply[A](buf: ByteBuffer, value: A)(implicit W: Write[A]) = W.write(buf, value)

  implicit val uuidWrite = new Write[UUID] {
    def write(buf: ByteBuffer, value: UUID) = {
      val tmp = ByteBuffer
        .allocate(16)
        .order(ByteOrder.LITTLE_ENDIAN)
        .putLong(value.getMostSignificantBits)
        .putLong(value.getLeastSignificantBits)

      tmp.flip()
      buf.put(tmp)
    }
  }
}
