package utils

import org.joda.time.DateTime
import models.Bucket
import models.Dump

object DumpBuilder {
  def forDate(date: DateTime): Dump = {
    val bucket = Bucket(1, "asdf", "some notes")
    Dump(1, bucket, "dump1.dmp", "a crash!", date)
  }

  def forDateWithCustomNow(date: DateTime)(implicit customNow: DateTime): Dump = {
    class CustomDump(id: Long,
      bucket: Bucket,
      filename: String,
      content: String,
      timestamp: DateTime) extends Dump(id, bucket, filename, content, timestamp) {

      override def now = customNow
    }
    new CustomDump(1, Bucket(1, "asdf", "some notes"), "dump1.dmp", "a crash!", date)
  }
}