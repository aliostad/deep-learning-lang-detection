package tel.schich.webnbt

import scala.scalajs.js.annotation.JSExport

@JSExport
class JsonNbtRenderer(prettyPrint: Boolean = true, indention: String = "\t") extends NbtRenderer[String] {

  override def render(compound: NbtCompound): String = {
    val builder = new StringBuilder
    write(builder, compound, 0)
    builder.toString()
  }

  private def writeValueSeparator(buffer: StringBuilder): Unit = {
    buffer.append(',')
    if (prettyPrint) {
      buffer.append('\n')
    }
  }

  private def writeBeginObject(buffer: StringBuilder): Unit = {
    buffer.append('{')
    if (prettyPrint) {
      buffer.append('\n')
    }
  }

  private def writeEndObject(buffer: StringBuilder, level: Int): Unit = {
    if (prettyPrint) {
      buffer.append('\n')
      writeIndention(buffer, level)
    }
    buffer.append('}')
  }

  private def writeEmptyObject(buffer: StringBuilder): Unit = {
    buffer.append("{}")
  }

  private def writePairSeparator(buffer: StringBuilder): Unit = {
    buffer.append(':')
    if (prettyPrint) {
      buffer.append(' ')
    }
  }

  private def writeBeginArray(buffer: StringBuilder): Unit = {
    buffer.append('[')
    if (prettyPrint) {
      buffer.append('\n')
    }
  }

  private def writeEndArray(buffer: StringBuilder, level: Int): Unit = {
    if (prettyPrint) {
      buffer.append('\n')
      writeIndention(buffer, level)
    }
    buffer.append(']')
  }

  private def writeEmptyArray(buffer: StringBuilder): Unit = {
    buffer.append("[]")
  }

  private def writeIndention(buffer: StringBuilder, level: Int): Unit = {
    if (prettyPrint) {
      buffer.append(indention * level)
    }
  }

  private def writeList(buffer: StringBuilder, elements: Seq[Any], level: Int): Unit = {
    writeBeginArray(buffer)
    if (elements.nonEmpty) {
      writeIndention(buffer, level + 1)
      buffer.append(elements.head)
      for (elem <- elements.tail) {
        writeValueSeparator(buffer)
        writeIndention(buffer, level + 1)
        buffer.append(elem)
      }
    }
    writeEndArray(buffer, level)
  }

  private def write(buffer: StringBuilder, value: NbtValue, level: Int): Unit = {
    value match {
      case NbtCompound(children) if children.nonEmpty =>
        writeBeginObject(buffer)
        val (k, v) = children.head
        writeIndention(buffer, level + 1)
        write(buffer, k)
        writePairSeparator(buffer)
        write(buffer, v, level + 1)
        for ((key, value) <- children.tail) {
          writeValueSeparator(buffer)
          writeIndention(buffer, level + 1)
          write(buffer, key)
          writePairSeparator(buffer)
          write(buffer, value, level + 1)
        }
        writeEndObject(buffer, level)
      case NbtCompound(_) => writeEmptyObject(buffer)
      case NbtList(_, children) if children.nonEmpty =>
        writeBeginArray(buffer)
        writeIndention(buffer, level + 1)
        write(buffer, children.head, level + 1)
        for (child <- children.tail) {
          writeValueSeparator(buffer)
          writeIndention(buffer, level + 1)
          write(buffer, child, level + 1)
        }
        writeEndArray(buffer, level)
      case NbtList(_, _) => writeEmptyArray(buffer)
      case NbtByteArray(bytes) => writeList(buffer, bytes, level)
      case NbtIntArray(ints) => writeList(buffer, ints, level)
      case NbtByte(n) => buffer.append(n)
      case NbtShort(n) => buffer.append(n)
      case NbtInt(n) => buffer.append(n)
      case NbtLong(n) => buffer.append(n)
      case NbtFloat(n) => buffer.append(n)
      case NbtDouble(n) => buffer.append(n)
      case NbtString(s) => write(buffer, s)
    }
  }

  private def write(buffer: StringBuilder, s: String): Unit = {
    val escaped = s.flatMap {
      case '"' => "\\\""
      case '\\' => "\\\\"
      case '/' => "\\/"
      case '\b' => "\\b"
      case '\f' => "\\f"
      case '\n' => "\\n"
      case '\r' => "\\r"
      case '\t' => "\\t"
      case c => "" + c
    }
    buffer.append('"').append(escaped).append('"')
  }
}
