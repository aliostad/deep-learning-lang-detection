import java.io.File
import java.util.concurrent.TimeUnit

import heap.core.HeapDump
import heap.{HeapDumpRecord, StringRecord}
import org.specs2.mutable.Specification
import http.Http

import scala.concurrent.Await
import scala.concurrent.duration.Duration
/**
  * Created by mehmetgunturkun on 27/01/17.
  */
class HeapDumpSpec extends Specification {
  "Heap Dump" should {
    "parse all documents" in {
      val file = new File("/tmp/test2.dump")
      val maybeHeapDump: Option[HeapDump] = HeapDump(file)

      maybeHeapDump match {
        case Some(heapDump) =>
          var recordNo = 0

          while (heapDump.hasNext) {
            recordNo += 1

            val record: HeapDumpRecord = heapDump.nextRecord()
            println(s"#$recordNo => $record")
          }
        case None =>
          println("There is no heap dump to parse")
      }

      success
    }
  }
}
