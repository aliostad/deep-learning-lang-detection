package grammarcomp

package grammar

import CFGrammar._
import EBNFGrammar._
import java.io._
import scala.io.StdIn

object GrammarWriter {

  def dumpPrettyGrammar[T](filename: String, g: Grammar[T]) = {    
    dumpGrammar(filename, CFGrammar.renameAutoSymbols(g))
  }
  
  def dumpGrammar[T](file: File, g: BNFGrammar[T]): Unit = {
    dumpFile(file, g)
  }
  def dumpGrammar[T](file: File, g: Grammar[T]): Unit = {
    dumpFile(file, g)
  }
  def dumpFile(file: File, content: Any): Unit = {
    val pw = new PrintWriter(new FileOutputStream(file))
    pw.print(content)
    pw.flush()
    pw.close()
  }
  
  def dumpGrammar[T](filename: String, g: Grammar[T]) {
    val fullname = filename + ".gram"
    dumpGrammar(new File(fullname), g)
    println("Dumped grammar to file: " + fullname)    
  }
  
}