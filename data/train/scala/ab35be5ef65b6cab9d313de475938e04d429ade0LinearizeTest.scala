package specmethods

trait BaseWriter {
  def write(i:Int):Unit = {}
}

trait Printer extends BaseWriter {
  override def write(i:Int):Unit = {
    println(i)
  }
}

trait Buffering extends BaseWriter {
  val buffer = collection.mutable.Buffer[Int]()
  override def write(i:Int):Unit = {
    buffer += i
    if(buffer.size > 5) {
      for(j <- buffer) super.write(j)
      buffer.clear
    } else {
      println("Buffering "+i)
    }
  }
}

trait BinaryFormat extends BaseWriter {
  override def write(i:Int):Unit = {
    super.write(i.toBinaryString.toInt)
  }
}

trait WriterUser { this: BaseWriter =>
  def useWrite(data:Iterator[Int]):Unit = {
    data.foreach(write)
  }
}

object LinearizeTest extends App {
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
  
  val user = new WriterUser with Printer with Buffering
}

