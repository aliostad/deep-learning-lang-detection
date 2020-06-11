abstract class Writer {
  def write(msg: String)
}

class StringWriter extends Writer {
  val target = new StringBuilder

  override def write(msg: String) =
    target.append(msg)

  override def toString: String = target.toString()
}

trait UpperCaseFilter extends Writer {
  abstract override def write(msg: String) = {
    super.write(msg.toUpperCase)
  }
}

trait ProfinityFilter extends Writer {
  abstract override def write(msg: String) = {
    super.write(msg.replace("Stupid", "S******"))
  }
}

def writeStruff(writer: Writer) = {
  writer.write("Scala Awesome!! Makes java Stupid!!")
  println(writer)
}

writeStruff(new StringWriter)
writeStruff(new StringWriter with UpperCaseFilter)
writeStruff(new StringWriter with UpperCaseFilter
  with ProfinityFilter)

writeStruff(new StringWriter with ProfinityFilter
  with UpperCaseFilter)