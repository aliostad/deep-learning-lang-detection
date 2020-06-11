package utils

package utils

import org.specs2.mutable._
import play.api.test._
import play.api.test.Helpers._
import models.Bucket
import org.joda.time.DateTime
import controllers.Application
import models.Dump
import scala.collection.immutable.ListMap
import org.joda.time.DateTimeConstants._

class TestDateFormatting extends Specification {
  "Formatted Date" should {
    "be like 'today ...' when dump is from today" in {
      val dump = DumpBuilder.forDate(DateTime.now.withTimeAtStartOfDay.plusSeconds(1))
      dump.dateFormatted must equalTo("today 00:00")
    }
    
    "be like <date> <time> when dump is not from today" in {
      implicit val now = new DateTime(2013, 5, 31, 12, 23)
      val dump = DumpBuilder.forDateWithCustomNow(now.minusDays(1))
      dump.dateFormatted must equalTo("2013-05-30 12:23")
      
      val dump1 = DumpBuilder.forDateWithCustomNow(now.minusDays(1).plusSeconds(5))
      dump1.dateFormatted must equalTo("2013-05-30 12:23")
    }
  }

}