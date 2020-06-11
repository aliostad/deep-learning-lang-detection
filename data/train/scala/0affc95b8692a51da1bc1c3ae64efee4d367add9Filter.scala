package ftanml.streams

/**
 * A Filter is an Acceptor that passes events to an other Acceptor, typically
 * making changes along the way. The base class, designed to be inherited from,
 * makes no changes to the stream
 */

class Filter(out : Acceptor) extends Acceptor {
  def processString(value: String) {
    out.processString(value)
  }

  def processNumber(value: java.math.BigDecimal) {
    out.processNumber(value)
  }

  def processBoolean(value: Boolean) {
    out.processBoolean(value)
  }

  def processNull() {
    out.processNull()
  }

  def processStartList() {
    out.processStartList()
  }

  def processEndList() {
    out.processEndList()
  }

  def processStartText() {
    out.processStartText()
  }

  def processEndText() {
    out.processEndText()
  }

  def processStartElement(name: Option[String]) {
    out.processStartElement(name)
  }

  def processAttributeName(name: String) {
    out.processAttributeName(name)
  }

  def processEndElement() {
    out.processEndElement()
  }

  def error(err: Exception) {
    out.error(err)
  }
}