package com.maqdev.mprop

import java.io.Writer

class PropertiesPrinter(writer: Writer, endOfLine: String) {

  def write(propertiesAst: Iterable[AstElement]): Unit = {
    propertiesAst.foreach {
      case KeyValue(k, v) ⇒
        writer.write(k.replace("=", "\\=").replace("\\", "\\\\"))
        writer.write("=")
        writer.write(v)

      case NewLine ⇒
        writer.write(endOfLine)

      case Comment(s) ⇒
        writer.write('#')
        writer.write(s)
    }
  }
}

object PropertiesPrinter {
  def write(writer: Writer, propertiesAst: Iterable[AstElement]) : Unit = {
    new PropertiesPrinter(writer, System.lineSeparator()).write(propertiesAst)
  }
}
