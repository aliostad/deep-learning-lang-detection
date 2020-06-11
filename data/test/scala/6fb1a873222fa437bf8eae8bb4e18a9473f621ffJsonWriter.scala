package cgta.serland
package json

//////////////////////////////////////////////////////////////
// Created by bjackman @ 4/26/14 6:03 PM
//////////////////////////////////////////////////////////////


trait JsonWriter {
  def writeStartObject(): Unit
  def writeEndObject(): Unit
  def writeFieldName(s: String): Unit

  def writeStartArray(): Unit
  def writeEndArray(): Unit

  def writeBoolean(b: Boolean): Unit
  def writeNumber(n : String) : Unit
  def writeString(s: String): Unit
  def writeStringField(k: String, v: String): Unit
  def writeNull() : Unit
}

