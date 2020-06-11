package bom.test


import java.io.PrintStream
import java.io.ByteArrayOutputStream
import org.scalatest._

import bom.bin._
import bom.stream._
import bom.examples.schemas._

class DumperTestSuite extends FunSuite {

  test("dump java.lang.String class") {
    val ps = new PrintStream(new ByteArrayOutputStream)
    Console.withOut(ps) {
      val bspace = new MemoryBinarySpace(getClass.getResourceAsStream("/java/lang/String.class"))
      Dumper.dump(JavaClassSchema.schema, bspace)
    }
  }
  
  test("dump java.lang.Runnable class") {
    val ps = new PrintStream(new ByteArrayOutputStream)
    Console.withOut(ps) {
      val bspace = new MemoryBinarySpace(getClass.getResourceAsStream("/java/lang/Runnable.class"))
      Dumper.dump(JavaClassSchema.schema, bspace)
    }
  }
  
}
