abstract class Writer {
  def writeMessage(message: String)
}

trait UpperCaseWriter extends Writer {
  abstract override def writeMessage(message: String) =
    super.writeMessage(message.toUpperCase)
}

trait ProfanityFilteredWriter extends Writer {
  abstract override def writeMessage(message: String) =
    {
      super.writeMessage(message.replace("stupid", "s-----"))
    }
}

class StringWriterDelegate extends Writer {
  def writer = new java.io.StringWriter
  override def writeMessage(message: String) =  writer.write(message)
}
