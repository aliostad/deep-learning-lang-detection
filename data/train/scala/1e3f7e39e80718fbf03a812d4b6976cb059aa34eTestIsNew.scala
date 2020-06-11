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

class TestIsNew extends Specification {

  "Dump" should {
    "be new when from today" in {
      val dump = DumpBuilder.forDate(DateTime.now)
      dump.isNew must equalTo(true)
    }

    "be new when not older than 24h" in {
      val dump = DumpBuilder.forDate(DateTime.now.minusDays(1).plusSeconds(1))
      dump.isNew must equalTo(true)
    }

    "be new when from yesterday" in {
      val dump = DumpBuilder.forDate(DateTime.now.minusDays(1))
      dump.isNew must equalTo(true)
    }

    "be new when from yesterday and older than 24 hours" in {
      val dump = DumpBuilder.forDate(DateTime.now.minusDays(1).withHourOfDay(0).withMinuteOfHour(0).withSecondOfMinute(0))
      dump.isNew must equalTo(true)
    }

    "be new when today is monday and the dump is from friday, saturday or sunday" in {
      implicit val monday = DateTime.now.withDayOfWeek(MONDAY)
      DumpBuilder.forDateWithCustomNow(monday.minusDays(1)).isNew must equalTo(true)
      DumpBuilder.forDateWithCustomNow(monday.minusDays(2)).isNew must equalTo(true)
      DumpBuilder.forDateWithCustomNow(monday.minusDays(3)).isNew must equalTo(true)
      DumpBuilder.forDateWithCustomNow(monday.minusDays(3).withTimeAtStartOfDay.plusSeconds(1)).isNew must equalTo(true)
    }

    "not be new when older than yesterday" in {
      val dump = DumpBuilder.forDate(DateTime.now.minusDays(2))
      dump.isNew must equalTo(false)
    }
  }
}