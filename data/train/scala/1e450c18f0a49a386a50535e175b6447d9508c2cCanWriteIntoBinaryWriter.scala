package almhirt.io

trait CanWriteIntoBinaryWriter[T] {
  def writeInto(v: T, into: BinaryWriter)
}

object CanWriteByteIntoBinaryWriter extends CanWriteIntoBinaryWriter[Byte] {
  def writeInto(v: Byte, into: BinaryWriter) = into.writeByte(v)
}

object CanWriteShortIntoBinaryWriter extends CanWriteIntoBinaryWriter[Short] {
  def writeInto(v: Short, into: BinaryWriter) = into.writeShort(v)
}

object CanWriteIntIntoBinaryWriter extends CanWriteIntoBinaryWriter[Int] {
  def writeInto(v: Int, into: BinaryWriter) = into.writeInt(v)
}

object CanWriteLongIntoBinaryWriter extends CanWriteIntoBinaryWriter[Long] {
  def writeInto(v: Long, into: BinaryWriter) = into.writeLong(v)
}

