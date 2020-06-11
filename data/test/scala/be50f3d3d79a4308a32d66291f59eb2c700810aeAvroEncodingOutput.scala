package com.gilt.pickling.avro

import scala.pickling.Output
import org.apache.avro.io.EncoderFactory
import java.io.ByteArrayOutputStream

class AvroEncodingOutput extends Output[Array[Byte]] {
  val stream = new ByteArrayOutputStream()
  val encoder = EncoderFactory.get.directBinaryEncoder(stream, null)

  override def put(obj: Array[Byte]): this.type = {
    stream.write(obj)
    this
  }

  override def result(): Array[Byte] = {
    encoder.flush()
    stream.toByteArray
  }

  def copyTo(pos: Int, bytes: Array[Byte]): Unit =
    Array.copy(stream.toByteArray, 0, bytes, pos, bytes.length)

  def encodeIntTo(value: Int): Unit = encoder.writeInt(value)

  def encodeLongTo(value: Long): Unit = encoder.writeLong(value)

  def encodeFloatTo(value: Float): Unit = encoder.writeFloat(value)

  def encodeDoubleTo(value: Double): Unit = encoder.writeDouble(value)

  def encodeBooleanTo(value: Boolean): Unit = encoder.writeBoolean(value)

  def encodeStringTo(value: String): Unit = encoder.writeString(value)

  def encodeByteTo(value: Byte): Unit = encoder.writeInt(value.toInt)

  def encodeCharTo(value: Char): Unit = encoder.writeInt(value.toInt)

  def encodeShortTo(value: Short): Unit = encoder.writeInt(value.toInt)

  def encodeIntArrayTo(value: Array[Int]): Unit = writePrimitiveArray(value, encoder.writeInt)

  def encodeLongArrayTo(value: Array[Long]): Unit = writePrimitiveArray(value, encoder.writeLong)

  def encodeFloatArrayTo(value: Array[Float]): Unit = writePrimitiveArray(value, encoder.writeFloat)

  def encodeDoubleArrayTo(value: Array[Double]): Unit = writePrimitiveArray(value, encoder.writeDouble)

  def encodeBooleanArrayTo(value: Array[Boolean]): Unit = writePrimitiveArray(value, encoder.writeBoolean)

  def encodeStringArrayTo(value: Array[String]): Unit = writePrimitiveArray(value, (s: String) => encoder.writeString(s))

  def encodeByteArrayTo(value: Array[Byte]): Unit = encoder.writeBytes(value)

  def encodeFixedByteArrayTo(value: Array[Byte]): Unit = encoder.writeFixed(value)

  def encodeCharArrayTo(value: Array[Char]): Unit = writePrimitiveArray(value, (c: Char) => encoder.writeInt(c.toInt))

  def encodeShortArrayTo(value: Array[Short]): Unit = writePrimitiveArray(value, (s: Short) => encoder.writeInt(s.toInt))

  private def writePrimitiveArray[T](value: Array[T], writeFunction: (T) => Unit) {
    encoder.writeArrayStart()
    encoder.setItemCount(value.length)
    value.foreach(writeFunction)
    encoder.writeArrayEnd()
  }
}
