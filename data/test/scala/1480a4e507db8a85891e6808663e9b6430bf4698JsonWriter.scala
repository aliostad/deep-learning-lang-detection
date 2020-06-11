/*
 * Copyright 2013 TeamNexus
 *
 * TeamNexus Licenses this file to you under the MIT License (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at:
 *
 *    http://opensource.org/licenses/mit-license.php
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License
 */

package com.nexus.data.json

import java.io.Writer

object JsonWriter {
  private final val CONTROL_CHARACTERS_START = 0x0000
  private final val CONTROL_CHARACTERS_END = 0x001f
}

class JsonWriter(private final val writer: Writer) {

  private[json] def write(string: String) = writer.write(string)
  private[json] def writeString(string: String) {
    writer.write('"')
    val length: Int = string.length
    val chars: Array[Char] = new Array[Char](length)
    string.getChars(0, length, chars, 0)
    for (i <- 0 until length) {
      val ch: Char = chars(i)
      if (ch == '"' || ch == '\\') {
        writer.write('\\')
        writer.write(ch)
      }
      else if (ch == '\n') {
        writer.write('\\')
        writer.write('n')
      }
      else if (ch == '\r') {
        writer.write('\\')
        writer.write('r')
      }
      else if (ch == '\t') {
        writer.write("\\t")
      }
      else if (ch == '\u2028') {
        writer.write("\\u2028")
      }
      else if (ch == '\u2029') {
        writer.write("\\u2029")
      }
      else if (ch >= JsonWriter.CONTROL_CHARACTERS_START && ch <= JsonWriter.CONTROL_CHARACTERS_END) {
        writer.write("\\u00")
        if (ch <= 0x000f) {
          writer.write('0')
        }
        writer.write(Integer.toHexString(ch))
      }
      else {
        writer.write(ch)
      }
    }
    writer.write('"')
  }

  def writeObject(obj: JsonObject) {
    writeBeginObject()
    var first: Boolean = true
    for (member <- obj) {
      if (!first) {
        writeObjectValueSeparator()
      }
      writeString(member.getName)
      writeNameValueSeparator()
      member.getValue.write(this)
      first = false
    }
    writeEndObject()
  }

  def writeBeginObject() = writer.write('{')
  def writeEndObject() = writer.write('}')
  def writeNameValueSeparator() = writer.write(':')
  def writeObjectValueSeparator() = writer.write(',')
  def writeBeginArray() = writer.write('[')
  def writeEndArray() = writer.write(']')
  def writeArrayValueSeparator() = writer.write(',')

  private [json] def writeArray(array: JsonArray) {
    writeBeginArray()
    var first: Boolean = true
    for (value <- array) {
      if (!first) writeArrayValueSeparator()
      value.write(this)
      first = false
    }
    writeEndArray()
  }
}