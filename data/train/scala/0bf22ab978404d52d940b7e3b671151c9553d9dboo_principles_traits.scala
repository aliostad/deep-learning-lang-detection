abstract class Writer {
  def write(msg: String)
}

class StringWriter extends Writer {
  val target = new StringBuilder
  def write(msg: String) =
    target.append(msg)

  override def toString() = target.toString()
}

// The extends here on traits is a bit confusing --
// it doesn't 'extend' in the normal sense, but rather
// places a constraint -- that this trait can only 'extend'
// Writers.
trait UpperCaseFilter extends Writer {
  abstract override def write(msg: String) = {
    super.write(msg.toUpperCase())
  }
}

trait ProfanityFilter extends Writer {
  abstract override def write(msg: String) = {
    super.write(msg.replace("stupid", "s*****"))
  }
}

def writeStuff(writer: Writer) = {
  writer.write("This is stupid")
  println(writer)
}

// Decorator pattern ensues! :)
writeStuff(new StringWriter)
writeStuff(new StringWriter with UpperCaseFilter)
writeStuff(new StringWriter with ProfanityFilter)
writeStuff(new StringWriter with UpperCaseFilter with ProfanityFilter)

