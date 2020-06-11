package com.github.dzhg.tedis.protocol

import java.io.OutputStream

import com.github.dzhg.tedis.TedisErrors
import com.github.dzhg.tedis.protocol.RESP._

class RESPWriter(out: OutputStream) extends TedisErrors {

  def writeValue(value: RESPValue): Unit = {
    value match {
      case SimpleStringValue(s) => writeSimpleString(s)
      case ErrorValue(error, msg) => writeError(error, msg)
      case IntegerValue(i) => writeInteger(i)
      case BulkStringValue(v) => writeBulkString(v)
      case ArrayValue(vs) => writeArray(vs)
      case EOFValue => protocolError()
    }
  }

  def writeSimpleString(str: String): Unit = {
    out.write(SIMPLE_STRING)
    writeString(str)
  }

  def writeError(error: String, msg: String): Unit = {
    out.write(ERROR)
    writeString(s"$error $msg")
  }

  def writeInteger(i: Long): Unit = {
    out.write(INTEGER)
    writeString(i.toString)
  }

  def writeBulkString(value: Option[String]): Unit = {
    out.write(BULK_STRING)
    value match {
      case None => writeString("-1")
      case Some("") =>
        writeString("0")
        out.write(CRLF)
      case Some(s) =>
        val bytes = s.getBytes(ENCODING)
        writeString(bytes.length.toString)
        out.write(bytes)
        out.write(CRLF)
    }
  }

  def writeArray(vs: Option[Seq[RESP.RESPValue]]): Unit = {
    out.write(ARRAY)
    vs match {
      case None => writeString("-1")
      case Some(values) =>
        if (values.isEmpty) {
          writeString("0")
        } else {
          writeString(values.size.toString)
          values.foreach(writeValue)
        }
    }
  }

  def writeString(str: String): Unit = {
    out.write(str.getBytes(ENCODING))
    out.write(CRLF)
  }

  def flush(): Unit = out.flush()
}
