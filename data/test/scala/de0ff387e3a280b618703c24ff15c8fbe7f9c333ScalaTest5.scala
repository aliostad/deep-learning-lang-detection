

object ScalaTest5 extends App {
  
  abstract class Writer {
    def write(msg: String)
  }
  
  class StringWriter extends Writer {
    val target = new StringBuilder
    
    def write(msg : String) = {
      target.append(msg)
    }
    
    override def toString() = target.toString()
  }
  
  trait UpperCaseFilter extends Writer {
    abstract override def write(msg: String) = {
      super.write(msg.toUpperCase())
    }
  }
  
  trait TextFilter extends Writer {
    abstract override def write(msg: String) = {
      super.write(msg.replace("stupid", "s****"))
    }
  }
  
  def writeStuff(writer : Writer) = {
    writer.write("This is stupid");
    println(writer)
  }
  
  val a = Array(1,3,11,5,21,7,9)
  val b = for (elem <- a; if elem < 10) yield 2 * elem
  println(b.toList)
  val c = a.filter(_ < 10).map(3 * _)
  println(c.toList)
  println(a.sum)
  println(a.sortWith(_ < _).toList)
  
  writeStuff(new StringWriter)
  writeStuff(new StringWriter with UpperCaseFilter)
  writeStuff(new StringWriter with TextFilter)
  writeStuff(new StringWriter with UpperCaseFilter with TextFilter)
  writeStuff(new StringWriter with TextFilter with UpperCaseFilter)
}