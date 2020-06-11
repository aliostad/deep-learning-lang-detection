import java.lang.StringBuilder
abstract class Writer {
	def write(mess:String)
}
class StringWriter extends Writer {
	val target = new StringBuilder
	override def write(mess:String) = target.append(mess)
	override def toString = target.toString 
}

def writeStuff(writer: Writer)= {
	writer.write("This is Sandeep AKkera")
	println(writer)
}

trait ToUpperCase extends Writer {
	abstract override def write(mess:String) = super.write(mess.toUpperCase)
}

trait ReplaceWord extends Writer {
	abstract override def write(mess:String) = super.write(mess.replace("Sandeep", "Awesome"))
}
writeStuff(new StringWriter)
writeStuff(new StringWriter with ToUpperCase with ReplaceWord)

