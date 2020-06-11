package bom.examples

import java.io.PrintStream
import java.io.ByteArrayOutputStream

import bom.bin._
import bom.stream._
import bom.examples.schemas._

object StringClassDumpForever {
  
  def main(args : Array[String]) : Unit = {
    while (true) {
      val ps = new PrintStream(new ByteArrayOutputStream)
      Console.withOut(ps) {
        val bspace = new MemoryBinarySpace(getClass.getResourceAsStream("/java/lang/String.class"))
        Dumper.dump(JavaClassSchema.schema, bspace)
      }
    }
  }
  
}
