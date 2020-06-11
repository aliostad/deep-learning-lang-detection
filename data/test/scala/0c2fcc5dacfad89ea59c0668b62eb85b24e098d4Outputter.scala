package jlss.services

import jlss._

class Outputter(out : java.io.Writer) extends StreamSink {
  private def escapeStr(s : String) = s.replaceAll("([\\\\\"])","\\\\$1")

  def apply(input : Json) : Unit = input match {
    case JsonArray(values) => {
      out.write("[")
      var first = true
      for(value <- values) {
        if(!first) {
          out.write(",")
        } else {
          first = false
        }
        apply(value)
      }
      out.write("]")
    }
    case JsonObject(values) => {
      out.write("{")
      var first = true
      for(JsonField(key, value) <- values) {
        if(!first) {
          out.write(",")
        } else {
          first = false
        }
        out.write("\"")
        out.write(escapeStr(key))
        out.write("\":")
        apply(value)
      }
      out.write("}")
    }
    case JsonString(s) => {
      out.write("\"")
      out.write(escapeStr(s))
      out.write("\"")
    }
    case JsonInt(i) => out.write(i.toString)
    case JsonNumber(d) => out.write(d.toString)
    case JsonBoolean(b) => out.write(b.toString)
    case JsonNull => out.write("null")
  }
}
