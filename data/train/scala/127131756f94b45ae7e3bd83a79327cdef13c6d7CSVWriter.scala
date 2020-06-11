package hr.element.doit.csv

import scala.annotation.tailrec

import java.io._

class CSVWriter(val config: CSVConfig, writer: Writer) {
  private val quoteLen = config.quotes.length

  private val escapes =
    Seq(config.delimiter, config.quotes, config.newLine)

  private def quoteIfNecessary(l: String) {
    if (escapes.exists(l.contains)) {
      writer.write(config.quotes)
      quote(l)
      writer.write(config.quotes)
    } else {
      writer.write(l)
    }
  }

  private def quote(l: String, i: Int = -quoteLen) {
    val oldValHead = math.max(i, 0)

    l.indexOf(config.quotes, i + quoteLen) match {
      case oldValTail if oldValTail == -1 =>
        writer.write(l substring oldValHead)
      case oldValTai =>
        writer.write(l substring(oldValHead, oldValTai))
        writer.write(config.quotes)
        quote(l, oldValTai)
    }
  }

  def write(line: Array[String]) {
    if (null ne line) {
      quoteIfNecessary(line(0))
      for (i <- line.indices.tail) {
        writer.write(config.delimiter)
        quoteIfNecessary(line(i))
      }
      writer.write(config.newLine)
      writer.flush()
    }
  }
}
