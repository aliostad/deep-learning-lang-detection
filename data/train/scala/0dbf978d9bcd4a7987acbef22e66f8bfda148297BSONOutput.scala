/*
 * Copyright 2016 Frugal Mechanic (http://frugalmechanic.com)
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package fm.serializer.bson

import fm.serializer.{FieldOutput, NestedOutput, Output}
import org.bson.types.ObjectId
import org.bson.{BsonBinary, BsonWriter}

final class BSONOutput(writer: BsonWriter) extends Output {
  def allowStringMap: Boolean = true

  //
  // RAW Output
  //

  // Special types
  def writeRawBsonBinary(value: BsonBinary): Unit = {
    if (null == value) writer.writeNull()
    else writer.writeBinaryData(value)
  }

  def writeRawObjectId(value: ObjectId): Unit = {
    if (null == value) writer.writeNull()
    else writer.writeObjectId(value)
  }

  def writeRawDateTime(value: Long): Unit = writer.writeDateTime(value)
  def writeRawMaxKey(): Unit = writer.writeMaxKey()
  def writeRawMinKey(): Unit = writer.writeMinKey()

  // Basic Types
  def writeRawBool(value: Boolean): Unit = writer.writeBoolean(value)
  def writeRawFloat(value: Float): Unit = writer.writeDouble(value)
  def writeRawDouble(value: Double): Unit = writer.writeDouble(value)

  def writeRawString(value: String): Unit = {
    if (null == value) writer.writeNull()
    else writer.writeString(value)
  }

  def writeRawByteArray(value: Array[Byte]): Unit = {
    if (null == value) writer.writeNull()
    else writer.writeBinaryData(new BsonBinary(value))
  }

  // Ints
  def writeRawInt(value: Int): Unit = writer.writeInt32(value)
  def writeRawUnsignedInt(value: Int): Unit = writer.writeInt32(value)
  def writeRawSignedInt(value: Int): Unit = writer.writeInt32(value)
  def writeRawFixedInt(value: Int): Unit = writer.writeInt32(value)

  // Longs
  def writeRawLong(value: Long): Unit = writer.writeInt64(value)
  def writeRawUnsignedLong(value: Long): Unit = writer.writeInt64(value)
  def writeRawSignedLong(value: Long): Unit = writer.writeInt64(value)
  def writeRawFixedLong(value: Long): Unit = writer.writeInt64(value)

  // Objects
  def writeRawObject[T](obj: T)(f: (FieldOutput, T) => Unit): Unit = {
    if (null == obj) {
      writer.writeNull()
    } else {
      writer.writeStartDocument()
      f(this, obj)
      writer.writeEndDocument()
    }
  }

  // Collections
  def writeRawCollection[T](col: T)(f: (NestedOutput, T) => Unit): Unit = {
    if (null == col) {
      writer.writeNull()
    } else {
      writer.writeStartArray()
      f(this, col)
      writer.writeEndArray()
    }
  }

  //
  // NESTED Output
  //

  // Special Types
  def writeNestedBsonBinary(value: BsonBinary): Unit = writeRawBsonBinary(value)
  def writeNestedObjectId(value: ObjectId): Unit = writeRawObjectId(value)
  def writeNestedDateTime(value: Long): Unit = writeRawDateTime(value)
  def writeNestedMaxKey(): Unit = writeRawMaxKey()
  def writeNestedMinKey(): Unit = writeRawMinKey()

  // Basic Types
  def writeNestedBool(value: Boolean): Unit = writeRawBool(value)
  def writeNestedFloat(value: Float): Unit = writeRawFloat(value)
  def writeNestedDouble(value: Double): Unit = writeRawDouble(value)
  def writeNestedString(value: String): Unit = writeRawString(value)

  // Bytes
  def writeNestedByteArray(value: Array[Byte]): Unit = writeRawByteArray(value)

  // Ints
  def writeNestedInt(value: Int): Unit = writeRawInt(value)
  def writeNestedUnsignedInt(value: Int): Unit = writeRawUnsignedInt(value)
  def writeNestedSignedInt(value: Int): Unit = writeRawSignedInt(value)
  def writeNestedFixedInt(value: Int): Unit = writeRawFixedInt(value)

  // Longs
  def writeNestedLong(value: Long): Unit = writeRawLong(value)
  def writeNestedUnsignedLong(value: Long): Unit = writeRawUnsignedLong(value)
  def writeNestedSignedLong(value: Long): Unit = writeRawSignedLong(value)
  def writeNestedFixedLong(value: Long): Unit = writeRawFixedLong(value)

  def writeNestedObject[T](obj: T)(f: (FieldOutput, T) => Unit): Unit = writeRawObject(obj)(f)
  def writeNestedCollection[T](col: T)(f: (NestedOutput, T) => Unit): Unit = writeRawCollection(col)(f)

  //
  // FIELD Output
  //

  // Special types
  def writeFieldBsonBinary(number: Int, name: String, value: BsonBinary): Unit = {
    if (null == value) writer.writeNull(name)
    else writer.writeBinaryData(name, value)
  }

  def writeFieldObjectId(number: Int, name: String, value: ObjectId): Unit = {
    if (null == value) writer.writeNull(name)
    else writer.writeObjectId(name, value)
  }

  def writeFieldDateTime(number: Int, name: String, value: Long): Unit = writer.writeDateTime(name, value)
  def writeFieldMaxKey(number: Int, name: String): Unit = writer.writeMaxKey(name)
  def writeFieldMinKey(number: Int, name: String): Unit = writer.writeMinKey(name)

  // Basic Types
  def writeFieldBool(number: Int, name: String, value: Boolean): Unit = writer.writeBoolean(name, value)
  def writeFieldFloat(number: Int, name: String, value: Float): Unit = writer.writeDouble(name, value)
  def writeFieldDouble(number: Int, name: String, value: Double): Unit = writer.writeDouble(name, value)

  def writeFieldString(number: Int, name: String, value: String): Unit = {
    if (null == value) writer.writeNull(name)
    else writer.writeString(name, value)
  }

  // Bytes
  def writeFieldByteArray(number: Int, name: String, value: Array[Byte]): Unit = {
    if (null == value) writer.writeNull(name)
    else writer.writeBinaryData(name, new BsonBinary(value))
  }

  // Ints
  def writeFieldInt(number: Int, name: String, value: Int): Unit = writer.writeInt32(name, value)
  def writeFieldUnsignedInt(number: Int, name: String, value: Int): Unit = writer.writeInt32(name, value)
  def writeFieldSignedInt(number: Int, name: String, value: Int): Unit = writer.writeInt32(name, value)
  def writeFieldFixedInt(number: Int, name: String, value: Int): Unit = writer.writeInt32(name, value)

  // Longs
  def writeFieldLong(number: Int, name: String, value: Long): Unit = writer.writeInt64(name, value)
  def writeFieldUnsignedLong(number: Int, name: String, value: Long): Unit = writer.writeInt64(name, value)
  def writeFieldSignedLong(number: Int, name: String, value: Long): Unit = writer.writeInt64(name, value)
  def writeFieldFixedLong(number: Int, name: String, value: Long): Unit = writer.writeInt64(name, value)

  // Objects
  def writeFieldObject[T](number: Int, name: String, obj: T)(f: (FieldOutput, T) => Unit): Unit = {
    if (null == obj) {
      writer.writeNull(name)
    } else {
      writer.writeStartDocument(name)
      f(this, obj)
      writer.writeEndDocument()
    }
  }

  // Collections
  def writeFieldCollection[T](number: Int, name: String, col: T)(f: (NestedOutput, T) => Unit): Unit = {
    if (null == col) {
      writer.writeNull(name)
    } else {
      writer.writeStartArray(name)
      f(this, col)
      writer.writeEndArray()
    }
  }

  // Null
  def writeFieldNull(number: Int, name: String): Unit = writer.writeNull(name)
}
