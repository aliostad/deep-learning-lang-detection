package com.hypertino.binders.json

import com.hypertino.binders.core.{BindOptions, Serializer}
import com.hypertino.binders.json.api.JsonGeneratorApi
import com.hypertino.binders.value.{Bool, Lst, Null, Number, Obj, Text, Value, ValueVisitor}
import com.hypertino.inflector.naming.Converter

import scala.concurrent.duration.{Duration, FiniteDuration}
import scala.language.experimental.macros

class JsonSerializeException(message: String) extends RuntimeException(message)

abstract class JsonSerializerBase[C <: Converter, F <: Serializer[C]] protected (val jsonGenerator: JsonGeneratorApi) extends Serializer[C]{

  protected def bindOptions: BindOptions

  def getFieldSerializer(fieldName: String): Option[F] = {
    jsonGenerator.writeFieldName(fieldName)
    Some(createFieldSerializer())
  }

  protected def createFieldSerializer(): F

  def writeNull(): Unit = jsonGenerator.writeNull()
  def writeInt(value: Int): Unit = jsonGenerator.writeInt(value)
  def writeLong(value: Long): Unit = jsonGenerator.writeLong(value)
  def writeString(value: String): Unit = jsonGenerator.writeString(value)
  def writeFloat(value: Float): Unit = jsonGenerator.writeFloat(value)
  def writeDouble(value: Double): Unit = jsonGenerator.writeDouble(value)
  def writeBoolean(value: Boolean): Unit = jsonGenerator.writeBoolean(value)
  def writeBigDecimal(value: BigDecimal): Unit = jsonGenerator.writeBigDecimal(value.bigDecimal)
  def writeFiniteDuration(value: FiniteDuration): Unit = jsonGenerator.writeLong(value.toMillis)
  def writeDuration(value: Duration): Unit = {
    val s = value.toString
    val s2 = if (s.startsWith("Duration.")) {
      s.substring(9)
    }
    else {
      s
    }
    jsonGenerator.writeString(s2)
  }

  def beginObject(): Unit = {
    jsonGenerator.writeStartObject()
  }

  def endObject(): Unit = {
    jsonGenerator.writeEndObject()
  }

  def beginArray(): Unit = {
    jsonGenerator.writeStartArray()
  }
  def endArray(): Unit = {
    jsonGenerator.writeEndArray()
  }

  def writeValue(value: Value): Unit = {
    if (value == null)
      writeNull()
    else
      value ~~ new ValueVisitor[Unit] {
        override def visitNumber(d: Number): Unit = writeBigDecimal(d.v)
        override def visitBool(d: Bool): Unit = writeBoolean(d.v)
        override def visitObj(d: Obj): Unit = {
          beginObject()
          d.v
            .filterNot(kv ⇒ bindOptions.skipOptionalFields && isOptional(kv._2))
            .foreach(kv => {
            getFieldSerializer(kv._1).get.asInstanceOf[JsonSerializerBase[_,_]].writeValue(kv._2)
          })
          endObject()
        }
        override def visitText(d: Text): Unit = writeString(d.v)
        override def visitLst(d: Lst): Unit = {
          beginArray()
          d.v.foreach(writeValue)
          endArray()
        }
        override def visitNull(): Unit = writeNull()
      }
  }

  protected def isOptional(v: Value): Boolean = {
    v match {
      case Null ⇒ true
      case o: Obj ⇒ o.isEmpty
      case l: Lst ⇒ l.isEmpty
      case _ ⇒ false
    }
  }
}

class JsonSerializer[C <: Converter](override val jsonGenerator: JsonGeneratorApi)
                                    (implicit protected val bindOptions: BindOptions)
  extends JsonSerializerBase[C, JsonSerializer[C]](jsonGenerator){
  protected override def createFieldSerializer(): JsonSerializer[C] = new JsonSerializer[C](jsonGenerator)
}
