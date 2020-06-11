package com.hypertino.binders.json

import java.io.Writer

import com.hypertino.binders.core.BindOptions
import com.hypertino.binders.json.api.JsonGeneratorApi

import scala.collection.mutable
import scala.scalajs.js.JSON

// todo: implement pretty print
class JsGeneratorAdapter(val writer: Writer)
                        (implicit protected val bindOptions: BindOptions)
  extends JsonGeneratorApi {
  private var isSequence = false
  private var prependComma = false
  private val sequenceStack = mutable.Stack[Boolean]()

  override def writeNull(): Unit = {
    prependCommaIfNeeded()
    writer.write("null")
  }
  override def writeInt(value: Int): Unit = {
    prependCommaIfNeeded()
    writer.write(value.toString)
  }
  override def writeLong(value: Long): Unit = {
    prependCommaIfNeeded()
    writer.write(value.toString)
  }

  override def writeString(value: String): Unit = {
    prependCommaIfNeeded()
    writer.write(JSON.stringify(value))
  }

  override def writeFloat(value: Float): Unit = {
    prependCommaIfNeeded()
    writer.write(f"$value%g")
  }

  override def writeDouble(value: Double): Unit = {
    prependCommaIfNeeded()
    writer.write(value.toString)
  }

  override def writeBoolean(value: Boolean): Unit = {
    prependCommaIfNeeded()
    writer.write(if (value) "true" else "false")
  }

  override def writeBigDecimal(value: BigDecimal): Unit = {
    prependCommaIfNeeded()
    writer.write(value.toString)
  }

  override def writeStartObject(): Unit = {
    prependCommaIfNeeded()
    writer.write("{")
    sequenceStack.push(isSequence)
    isSequence = true
    prependComma = false
  }

  override def writeEndObject(): Unit = {
    writer.write("}")
    isSequence = sequenceStack.pop()
  }

  override def writeStartArray(): Unit = {
    prependCommaIfNeeded()
    writer.write("[")
    sequenceStack.push(isSequence)
    isSequence = true
    prependComma = false
  }

  override def writeEndArray(): Unit = {
    writer.write("]")
    isSequence = sequenceStack.pop()
  }

  override def writeFieldName(name: String): Unit = {
    prependCommaIfNeeded()
    writer.write(JSON.stringify(name))
    writer.write(":")
    prependComma = false
  }

  private def prependCommaIfNeeded(): Unit = {
    if (prependComma) {
      writer.write(',')
    }
    if (isSequence) {
      prependComma = true
    }
  }
}
