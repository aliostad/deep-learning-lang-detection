package brotorift

import java.nio.ByteOrder
import akka.util.ByteStringBuilder
import akka.util.ByteString

class OutPacket(header: Int) {
  implicit val byteOrder = ByteOrder.LITTLE_ENDIAN
  
  private val builder = new ByteStringBuilder()
  builder.putInt(header)
  
  def length = builder.length
  def buffer = builder.result
  
  def writeBool(value: Boolean) = {
    if (value) {
      builder.putByte(1)
    } else {
      builder.putByte(0)
    }
  }
  
  def writeByte(value: Byte) = {
    builder.putByte(value)
  }
  
  def writeShort(value: Short) = {
    builder.putShort(value)
  }
  
  def writeInt(value: Int) = {
    builder.putInt(value)
  }
  
  def writeLong(value: Long) = {
    builder.putLong(value)
  }
  
  def writeFloat(value: Float) = {
    builder.putFloat(value)
  }
  
  def writeDouble(value: Double) = {
    builder.putDouble(value)
  }
  
  def writeString(value: String) = {
    this.writeByteBuffer(ByteString(value, "UTF-8"))
  }
  
  def writeByteBuffer(value: ByteString) = {
    this.writeInt(value.length)
    builder ++= value
  }
  
  def writeList[T](value: List[T], writeElement: Function1[T, Unit]) = {
    this.writeInt(value.size)
    for (item <- value) {
      writeElement(item)
    }
  }
  
  def writeSet[T](value: Set[T], writeElement: Function1[T, Unit]) = {
    this.writeInt(value.size)
    for (item <- value) {
      writeElement(item)
    }
  }
  
  def writeMap[K, V](value: Map[K, V], writeKey: Function1[K, Unit], writeValue: Function1[V, Unit]) = {
    this.writeInt(value.size)
    for (item <- value) {
      writeKey(item._1)
      writeValue(item._2)
    }
  }
  
  def writeStruct(value: Struct) = {
    value.writeToPacket(this)
  }
  
  def writeVector2(value: Vector2) = {
    this.writeFloat(value.x)
    this.writeFloat(value.y)
  }
  
  def writeVector3(value: Vector3) = {
    this.writeFloat(value.x)
    this.writeFloat(value.y)
    this.writeFloat(value.z)
  }
  
  def writeColor(value: Color) = {
    this.writeFloat(value.r)
    this.writeFloat(value.g)
    this.writeFloat(value.b)
    this.writeFloat(value.a)
  }
}