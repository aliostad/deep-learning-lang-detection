package cnauroth.dumpservlet

import scala.annotation.tailrec
import scala.collection.JavaConversions._

import java.io._
import java.util.Enumeration

/**
 * Provides implicit type conversion of responses to a more convenient
 * interface.
 */
private[dumpservlet] object DumpResponse {

  /**
   * Implicitly converts an HttpServletResponse to a DumpResponse.
   *
   * @param response HTTP response.
   * @return DumpResponse wrapping the response.
   */
  implicit def asDumpResponse(response: Response) = new DumpResponse(response)

  /** All 8-bit values represented in hex, padded to 2 characters. */
  private val HEX = 0x00 to 0xFF map {
    value => "%02x" format value.asInstanceOf[java.lang.Integer]
  }

  /** Number of bytes to group together in hex dump. */
  private val HEX_DUMP_BYTES_PER_GROUP = 2

  /** Number of bytes to display in a line in hex dump. */
  private val HEX_DUMP_BYTES_PER_LINE = 16

  /** Maximum total number of bytes to display in hex dump. */
  private val HEX_DUMP_MAX_BYTES = 1024

  /** Replacement for non-displayable characters in hex dump. */
  private val HEX_DUMP_REPLACEMENT = '.'

  /** An empty space character. */
  private val SPACE = " "

  /** Number of spaces in each level of indentation. */
  private val SPACES_PER_INDENT = 4
}

/**
 * Wraps HTTP responses in a more convenient interface.  The class exposes
 * various convenience methods for writing different kinds of output.  The
 * write methods return this instance to support method call chaining.
 *
 * @param response HTTP response.
 */
private[dumpservlet] final class DumpResponse(wrapped: Response) {

  import DumpResponse._

  /** Current nesting level of indentation. */
  var currentIndent: Int = 0

  /**
   * Writes a line of output.
   *
   * @param line to output.
   * @return this.
   */
  def write(line: Any): DumpResponse = {
    this.wrapped.getWriter().println(
      format("%s%s", SPACE * SPACES_PER_INDENT * this.currentIndent,
             String.valueOf(line))
    )
    this
  }

  /**
   * Writes a key-value pair.
   *
   * @param key the key to write.
   * @param value the value to write.
   */
  def write(key: Any, value: Any): DumpResponse = {
    this.write(format("%s = %s", String.valueOf(key), String.valueOf(value)))
  }

  /**
   * Writes a titled collection of key-value pairs.
   *
   * @param title heading name.
   * @param keysGetter function returning an enumeration over all keys.
   * @param valueGetter function returning the value for a given key.
   * @return this.
   */
  def writeKeyValuePairs(title: String,
                         keysGetter: () => Enumeration[_],
                         valueGetter: (Any) => _) = {
    this.writeSection(title, wrapper => {
      keysGetter().foreach(key => {
        valueGetter(key) match {
          case value: Enumeration[_] => wrapper.writeFlatList(key, asIterator(value))
          case value: Array[Any] => wrapper.writeFlatList(key, value.iterator)
          case value => wrapper.write(key, value)
        }
      })
    })
  }

  /**
   * Writes a titled list of values.
   *
   * @param title heading name.
   * @param values iterator over all values.
   * @return this.
   */
  def writeFlatList(title: Any, values: Iterator[Any]) = {
    this.beginList(title)
    values foreach { this.write }
    this.endList()
  }

  /**
   * Writes a hexadecimal dump of the given input.
   *
   * @param title heading name.
   * @param in input stream.
   * @return this.
   */
  def writeHex(title: Any, in: InputStream) = {
    /*
    The output is inspired by the xxd tool.  i.e.:
    0000: 1f8b 0808 9707 074d 0003 6170 6163 6865  .......M..apache
    0010: 2d64 6570 6c6f 796d 656e 742d 7265 7632  -deployment-rev2
    */

    this.writeSection(title, wrapper => {
      // Read from the input stream.
      val bytes = new Array[Byte](HEX_DUMP_MAX_BYTES)
      val len = in.read(bytes)

      // Group the bytes into lines for display.
      val lines = ((bytes take len) grouped HEX_DUMP_BYTES_PER_LINE) map {
        _.toList } toList

      // Define recursive output function.
      @tailrec
      def writeHexRecursive(lines: List[List[Byte]], lineCount: Int = 0) {
        lines match {
          case(head :: tail) => {
            // Separate the bytes into display groups and convert to hex.
            // Conversion of byte to int can yield negative numbers in 2's
            // complement representation, so mask away everything but the low 8
            // bits.
            val hexGroups = head map { byte => HEX(byte & 0xFF) } grouped(
              HEX_DUMP_BYTES_PER_GROUP)

            // Get the hex portion of the display.
            val hex = hexGroups map { group => group.mkString } mkString SPACE

            // Get the ASCII portion of the display.
            val asciiLine = head map {
              byte => (byte & 0xFF).asInstanceOf[Char] match {
                case replaced: Char if replaced.isControl || replaced >= 0x80 =>
                  HEX_DUMP_REPLACEMENT
                case char => char
              }
            }

            val ascii = asciiLine.mkString

            // Write the line count as hex, the hex representation, and the
            // ASCII representation.
            this.write("%04x: %-40s  %-16s" format(lineCount, hex, ascii))
            writeHexRecursive(tail, lineCount + 1)
          }

          case _ => return
        }
      }

      writeHexRecursive(lines)
    })
  }

  /**
   * Writes a titled list of values, labeled with sequential numbers.  For each
   * value, all properties are evaluated and written as key-value pairs.
   *
   * @tparam T type of the values.
   * @param values iterator over all values.
   * @return this.
   */
  def writeNumberedList[T <: PropertyProvider](values: Iterator[T]) = {

    @tailrec
    def writeNumberedListRecursive(values: Iterator[T], i: Int = 0) {
      if (values.hasNext()) {
        this.beginList(i)

        val propertyProvider = values.next()
        propertyProvider.getPropertyNames().foreach(name => {
          this.write(name, propertyProvider.getProperty(name))
        });

        this.endList()
        writeNumberedListRecursive(values, i + 1)
      }
    }

    writeNumberedListRecursive(values)
    this
  }

  /**
   * Writes a titled section of output.
   *
   * @param title heading name.
   */
  def writeSection(title: Any, writer: (DumpResponse) => Unit): DumpResponse = {
    this.write(title)
    this.indent()
    writer(this)
    this.outdent()
    this.newline()
  }

  /**
   * Begins a new list.
   *
   * @param title heading title.
   * @return this.
   */
  private def beginList(title: Any): DumpResponse = {
    this
      .write(format("%s [", title))
      .indent()
  }

  /**
   * Begins a new section.
   *
   * @param title heading title.
   * @return this.
   */
  private def beginSection(title: Any): DumpResponse = {
    this
      .write(title)
      .indent()
  }

  /**
   * Ends the current list.
   *
   * @return this.
   */
  private def endList(): DumpResponse = {
    this
      .outdent()
      .write("]")
  }

  /**
   * Ends the current section.
   *
   * @return this.
   */
  private def endSection(): DumpResponse = {
    this
      .outdent()
      .newline()
  }

  /**
   * Indents 1 level.
   *
   * @return this.
   */
  private def indent(): DumpResponse = {
    this.currentIndent += 1
    this
  }

  /**
   * Writes a new line.
   *
   * @return this.
   */
  private def newline(): DumpResponse = {
    this.wrapped.getWriter().println()
    this
  }

  /**
   * Outdents 1 level.
   *
   * @return this.
   */
  private def outdent(): DumpResponse = {
    this.currentIndent -= 1
    this
  }
}

