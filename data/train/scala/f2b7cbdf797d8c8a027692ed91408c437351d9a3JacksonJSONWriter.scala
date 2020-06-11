/*
 * Copyright (c) 2013 Christos KK Loverdos
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.ckkloverdos.thrift3r
package protocol.json
package jackson

import com.fasterxml.jackson.core.{JsonFactory, JsonGenerator}
import java.io.Writer

/**
 *
 * @author Christos KK Loverdos <loverdos@gmail.com>
 */
final class JacksonJSONWriter(
  gen: JsonGenerator,
  factory: JsonFactory
) extends JSONWriter {

  def flush() = gen.flush()

  def writeString(value: String) = gen.writeString(value)

  def writeBool(value: Bool) = gen.writeBoolean(value)

  def writeInt8(value: Int8) = gen.writeNumber(value.toShort)

  def writeInt16(value: Int16) = gen.writeNumber(value)

  def writeInt32(value: Int32) = gen.writeNumber(value)

  def writeInt64(value: Int64) = gen.writeNumber(value)

  def writeFloat32(value: Float32) = gen.writeNumber(value)

  def writeFloat64(value: Float64) = gen.writeNumber(value)

  def writeArrayBegin() = gen.writeStartArray()

  def writeArrayEnd() = gen.writeEndArray()

  def writeObjectBegin() = gen.writeStartObject()

  def writeObjectEnd() = gen.writeEndObject()

  def writeFieldName(value: String) = gen.writeFieldName(value)

  def newJSONWriter(writer: Writer) = new JacksonJSONWriter(factory.createGenerator(writer), factory)
}
