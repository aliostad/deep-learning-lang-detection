package com.hypertino.binders.json.api

import com.hypertino.binders.core.BindOptions

trait JsonGeneratorApi {
  def writeNull(): Unit
  def writeInt(value: Int): Unit
  def writeLong(value: Long): Unit
  def writeString(value: String): Unit
  def writeFloat(value: Float): Unit
  def writeDouble(value: Double): Unit
  def writeBoolean(value: Boolean): Unit
  def writeBigDecimal(value: BigDecimal): Unit
  def writeStartObject(): Unit
  def writeEndObject(): Unit
  def writeStartArray(): Unit
  def writeEndArray(): Unit
  def writeFieldName(name: String): Unit
  protected def bindOptions: BindOptions
}
