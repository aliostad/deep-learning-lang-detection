package traits.tests

trait BaseWriter {
  def write(i: Int): Unit = {}
}

trait Printer extends BaseWriter {
  override def write(i: Int): Unit = {
    println(s"Printer: ${i}")
  }
}

trait Buffering extends BaseWriter {
  val buffer = collection.mutable.Buffer[Int]()
  override def write(i: Int): Unit = {
    buffer += i
    if (buffer.size > 5) {
      for (j <- buffer) {
        println("Buffer printing...")
        super.write(j)
      }
      buffer.clear
    } else {
      println(s"Buffering ${i}")
    }
  }
}

trait BinaryFormat extends BaseWriter {
  override def write(i: Int): Unit = {
    println("Bynary printing...")
    super.write(i.toBinaryString.toInt)
  }
}

trait WriterUser { this: BaseWriter =>
  def useWrite(data: Iterator[Int]): Unit = {
    data.foreach(write)
  }
}

object LinearizeTraits extends App {
  //Execute the method 'write' of the Traits, consider the Traits from right to left
  val bufBinPrint = new Printer with BinaryFormat with Buffering
  bufBinPrint.write(1)
  bufBinPrint.write(2)
  bufBinPrint.write(3)
  bufBinPrint.write(4)
  bufBinPrint.write(5)
  bufBinPrint.write(6)
  println()
  println()
  val binBufPrint = new Printer with Buffering with BinaryFormat
  binBufPrint.write(1)
  binBufPrint.write(2)
  binBufPrint.write(3)
  binBufPrint.write(4)
  binBufPrint.write(5)
  binBufPrint.write(6)

  println()
  println()
  println()
  println()
  val user = new WriterUser with Printer with Buffering
  user.useWrite(Iterator(1,2,3,4,5,6))
}

