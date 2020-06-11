package com.hypertino.binders.json

import com.fasterxml.jackson.core.JsonGenerator
import com.hypertino.binders.core.BindOptions
import com.hypertino.binders.json.api.JsonGeneratorApi

class JacksonGeneratorAdapter(val jsonGenerator: JsonGenerator)
                             (implicit protected val bindOptions: BindOptions) extends JsonGeneratorApi {
  override def writeNull(): Unit = jsonGenerator.writeNull()
  override def writeInt(value: Int): Unit = jsonGenerator.writeNumber(value)
  override def writeLong(value: Long): Unit = jsonGenerator.writeNumber(value)
  override def writeString(value: String): Unit = jsonGenerator.writeString(value)
  override def writeFloat(value: Float): Unit = jsonGenerator.writeNumber(value)
  override def writeDouble(value: Double): Unit = jsonGenerator.writeNumber(value)
  override def writeBoolean(value: Boolean): Unit = jsonGenerator.writeBoolean(value)
  override def writeBigDecimal(value: BigDecimal): Unit = jsonGenerator.writeNumber(value.bigDecimal)
  override def writeStartObject(): Unit = jsonGenerator.writeStartObject()
  override def writeEndObject(): Unit = jsonGenerator.writeEndObject()
  override def writeStartArray(): Unit = jsonGenerator.writeStartArray()
  override def writeEndArray(): Unit = jsonGenerator.writeEndArray()
  override def writeFieldName(name: String): Unit = jsonGenerator.writeFieldName(name)
}
