package guru.nidi.minecraft.core

import java.io._

import scala.collection.mutable

/**
 *
 */
object NbtWriter {
  def write(root: Tag): Array[Byte] = {
    val writer = new NbtWriter
    writer.writeTag(root)
    writer.baos.toByteArray
  }
}


private class NbtWriter {
  val baos = new ByteArrayOutputStream()
  private val out = new DataOutputStream(baos)

  def writeByteArray(value: Array[Byte]) = {
    out.writeInt(value.length)
    out.write(value)
  }

  def writeIntArray(value: Array[Int]) = {
    out.writeInt(value.length)
    for (v <- value) {
      out.writeInt(v)
    }
  }

  def writeCompound(value: collection.Map[String, Tag]) = {
    for (v <- value.values) {
      writeTag(v)
    }
    writeTag(EndTag())
  }

  def writeList[T <: Tag](id: Byte, value: mutable.Buffer[T]) = {
    out.writeByte(id)
    out.writeInt(value.length)
    for (v <- value) {
      writeTagValue(v)
    }
  }

  def writeTag(tag: Tag): Unit = {
    out.writeByte(tag match {
      case EndTag() => 0
      case ByteTag(_, _) => 1
      case ShortTag(_, _) => 2
      case IntTag(_, _) => 3
      case LongTag(_, _) => 4
      case FloatTag(_, _) => 5
      case DoubleTag(_, _) => 6
      case ByteArrayTag(_, _) => 7
      case StringTag(_, _) => 8
      case ListTag(_, _, _) => 9
      case CompoundTag(_, _) => 10
      case IntArrayTag(_, _) => 11
      case other => throw new IllegalArgumentException(s"unknown tag id $other")
    })
    tag match {
      case EndTag() =>
      case _ =>
        out.writeUTF(tag.name)
        writeTagValue(tag)
    }
  }

  def writeTagValue(tag: Tag): Unit = {
    tag match {
      case ByteTag(_, value) => out.writeByte(value)
      case ShortTag(_, value) => out.writeShort(value)
      case IntTag(_, value) => out.writeInt(value)
      case LongTag(_, value) => out.writeLong(value)
      case FloatTag(_, value) => out.writeFloat(value)
      case DoubleTag(_, value) => out.writeDouble(value)
      case ByteArrayTag(_, value) => writeByteArray(value)
      case StringTag(_, value) => out.writeUTF(value)
      case ListTag(_, id, value) => writeList(id, value)
      case CompoundTag(_, value) => writeCompound(value)
      case IntArrayTag(_, value) => writeIntArray(value)
      case other => throw new IllegalArgumentException(s"unknown tag id $other")
    }

  }
}

