package cgta.serland
package backends


import cgta.serland.SerHints.Ser32Hints.Ser32Hint
import cgta.serland.SerHints.Ser64Hints.Ser64Hint
import cgta.serland.json.{JsonWriterCompact, JsonWriterPretty, JsonWriter}


//////////////////////////////////////////////////////////////
// Copyright (c) 2011 Ben Jackman
// All Rights Reserved
// please contact ben@jackman.biz
// for licensing inquiries
// Created by bjackman @ 1/7/11 3:27 PM
//////////////////////////////////////////////////////////////


object JsonOutOpts {
  val legacy  = JsonOutOpts(onlyBigLongsAsStrings = true)
}
case class JsonOutOpts(onlyBigLongsAsStrings: Boolean)

object SerJsonOut {
  def toJsonCompact[A: SerClass](a: A, opts: JsonOutOpts = JsonOutOpts.legacy): String = {
    val w = JsonWriterCompact()
    val sjo = new SerJsonOut(w, opts)
    serClass[A].write(a, sjo)
    w.get()
  }
  def toJsonPretty[A: SerClass](a: A, opts: JsonOutOpts = JsonOutOpts.legacy): String = {
    val w = JsonWriterPretty()
    val sjo = new SerJsonOut(w, opts)
    serClass[A].write(a, sjo)
    w.get()
  }
}

class SerJsonOut(val w: JsonWriter, opts: JsonOutOpts) extends SerOutput {
  //When true the SerClasses should write themselves out in a Human Readable format
  override def isHumanReadable: Boolean = true

  var monNestingStack: List[Int] = 0 :: Nil
  var nextField      : String    = null

  private def writeFieldIfNeeded() {
    if (nextField != null) {
      w.writeFieldName(nextField)
      nextField = null
    }
  }

  override def writeStructBegin() {
    writeFieldIfNeeded()
    w.writeStartObject()
    monNestingStack ::= 0
  }
  override def writeStructEnd() {
    monNestingStack = monNestingStack.tail
    w.writeEndObject()
  }

  override def writeOneOfBegin(keyName: String, keyId: Int) = {
    writeFieldIfNeeded()
    w.writeStartObject()
    w.writeStringField("key", keyName)
    w.writeFieldName("value")
  }
  override def writeOneOfEnd() {
    w.writeEndObject()
  }

  override def writeFieldBegin(name: String, id: Int) = {
    if (nextField == null) {
      nextField = name
    } else {
      WRITE_ERROR(s"Unexpected state, there should not be a value in nextField [$nextField] cur[$name]")
    }
  }
  override def writeFieldEnd() {
    nextField = null
  }
  override def writeString(s: String) {
    writeFieldIfNeeded()
    w.writeString(s)
  }
  override def writeBoolean(b: Boolean) = {
    writeFieldIfNeeded()
    w.writeBoolean(b)
  }
  override def writeByte(b: Byte) = {
    writeFieldIfNeeded()
    w.writeNumber(b.toString)
  }
  override def writeChar(c: Char) = {
    writeFieldIfNeeded()
    w.writeString(c.toString)
  }
  override def writeByteArrLen(a: Array[Byte], offset: Int, length: Int) = {
    writeFieldIfNeeded()
    w.writeStartArray()
    a.view.drop(offset).take(length).foreach(b => w.writeNumber(b.toString))
    w.writeEndArray()
  }
  override def writeInt32(a: Int, hint: Ser32Hint) = {
    writeFieldIfNeeded()
    w.writeNumber(a.toString)
  }
  override def writeInt64(a: Long, hint: Ser64Hint) = {
    writeFieldIfNeeded()
    if (opts.onlyBigLongsAsStrings) {
      if (a > 9007199254740992L || a < -9007199254740992L) {
        w.writeString(a.toString)
      } else {
        w.writeNumber(a.toString)
      }
    } else {
      w.writeString(a.toString)
    }
  }
  override def writeDouble(a: Double) = {
    writeFieldIfNeeded()
    w.writeNumber(a.toString)
  }

  override def writeIterable[A](xs: Iterable[A], sca: SerWritable[A]) = {
    writeFieldIfNeeded()
    w.writeStartArray()
    monNestingStack = (monNestingStack.head + 1) :: monNestingStack.tail
    xs.foreach(x => sca.write(x, this))
    monNestingStack = (monNestingStack.head - 1) :: monNestingStack.tail
    w.writeEndArray()
  }
  override def writeOption[A](x: Option[A], sca: SerWritable[A]) = {
    val curDepth = monNestingStack.head
    if (curDepth > 0) {
      writeFieldIfNeeded()
      w.writeStartArray()
    }
    monNestingStack = (curDepth + 1) :: monNestingStack.tail
    if (x.isDefined) {
      writeFieldIfNeeded()
      sca.write(x.get, this)
    }
    monNestingStack = curDepth :: monNestingStack.tail
    if (curDepth > 0) w.writeEndArray()
  }
}


