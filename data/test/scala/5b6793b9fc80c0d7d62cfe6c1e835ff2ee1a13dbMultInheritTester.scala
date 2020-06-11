package intrigued

/**
 * User: mayukh
 * Date: 11/15/13
 * Time: 12:00 AM
 */

trait UpperCaseFilter extends Writer {
// by extending from Writer, we are placing a constraint that the trait can only be used with Writer family
  abstract override def write (msg: String) = super.write (msg.toUpperCase())

}

trait ProfanityFilter extends Writer {

  abstract override def write (msg: String) = super.write(msg.replace("stupid", "s*****"))
}


abstract class Writer {
  def write (msg: String)
}

class StringWriter extends Writer {

  val target = new StringBuilder

  def write (msg: String) = target.append (msg)

  override def toString() = target.toString()
}


object MultInheritTester extends App {

  def writeStuff (writer: Writer) = {
    writer.write ("This is stupid")
    println (writer)
  }

  writeStuff(new StringWriter)
  writeStuff(new StringWriter with UpperCaseFilter) // stupid
  writeStuff(new StringWriter with ProfanityFilter) // s*****

  writeStuff(new StringWriter with UpperCaseFilter with ProfanityFilter) // S*****
  writeStuff(new StringWriter with ProfanityFilter with UpperCaseFilter) // STUPID

}
