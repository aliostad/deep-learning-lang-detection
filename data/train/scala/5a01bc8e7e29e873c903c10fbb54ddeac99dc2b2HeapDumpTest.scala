package test

import java.io.File

import heap.core.{HeapDump, HeapDumpStream}

/**
  * Created by mehmetgunturkun on 22/01/17.
  */
object HeapDumpTest {
  def main(args: Array[String]): Unit = {
    val file = new File("data/largeDump.hprof")
    val maybeStream: Option[HeapDumpStream] = HeapDumpStream.fromFile(file)

    maybeStream match {
      case Some(stream) =>
        val heapDump = new HeapDump(stream)
        println(s"Done!")
        while (heapDump.hasNext) {
          val r1 = heapDump.nextRecord()
        }

      case None =>

    }

  }
}
