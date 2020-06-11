package me.axiometry.blocknet.nbt

import java.io._

class NBTOutputStream(out: OutputStream) extends DataOutputStream(out) {
  private def invalid() = throw new IOException("invalid NBT tag")

  def writeNBTTag(tag: NBT.Tag) {
    writeByte(tag.`type`.id)
    tag.name match {
      case Some(name) => writeUTF(name)
      case None => throw new IllegalArgumentException("unnamed NBT tag")
    }
    writeNBTTagBody(tag)
  }

  private def writeNBTTagBody(tag: NBT.Tag) {
    import NBT.Tag; import NBT.Tag.Type
    tag match {
      case Tag.Byte     (_, value) => writeByte(value)
      case Tag.Short    (_, value) => writeShort(value)
      case Tag.Int      (_, value) => writeInt(value)
      case Tag.Long     (_, value) => writeLong(value)
      case Tag.Float    (_, value) => writeFloat(value)
      case Tag.Double   (_, value) => writeDouble(value)
      case Tag.ByteArray(_, value) => writeInt(value.length); value foreach (writeByte(_))
      case Tag.IntArray (_, value) => writeInt(value.length); value foreach (writeInt(_))
      case Tag.String   (_, value) => writeUTF(value)

      case Tag.List(_, t, elems @ _*) => writeByte(t.id); writeInt(elems.length); elems foreach (writeNBTTagBody(_))
      case Tag.Compound(_, tags @ _*) => tags foreach (writeNBTTag(_)); writeByte(0)
    }
  }
}
