package org.menthal.io

import org.apache.spark.SparkContext
import org.menthal.io.parquet.ParquetIO
import org.menthal.io.postgres.PostgresDump
import org.menthal.model.EventType._
import org.menthal.spark.SparkHelper._


object PostgresDumpToParquet {
  def main(args: Array[String]) {
    val (master, dumpFile, outputFile) = args match {
      case Array(m, d, o) =>
        (m,d,o)
      case _ =>
        val errorMessage = "First argument is master, second input path, third argument is output path"
        throw new IllegalArgumentException(errorMessage)
    }
    val sc = getSparkContext(master, "AppSessionsAggregation")
    parseFromDumpAndWriteToParquet(sc, dumpFile, outputFile)
    sc.stop()
  }

  val processedTypes = List(
    TYPE_ACCESSIBILITY_SERVICE_UPDATE,
    TYPE_APP_INSTALL,
    TYPE_APP_LIST,
    TYPE_APP_REMOVAL,
    TYPE_APP_SESSION,
    //TYPE_APP_SESSION_TEST,
    TYPE_APP_UPGRADE,
    TYPE_CALL_RECEIVED,
    TYPE_CALL_OUTGOING,
    TYPE_CALL_MISSED,
    TYPE_DEVICE_FEATURES,
    TYPE_DREAMING_STARTED,
    TYPE_DREAMING_STOPPED,
    TYPE_MENTHAL_APP_ACTION,
    TYPE_MOOD,
    TYPE_NOTIFICATION_STATE_CHANGED,
    TYPE_LOCALISATION,
    TYPE_PHONE_BOOT,
    TYPE_PHONE_SHUTDOWN,
    TYPE_SCREEN_ON,
    TYPE_SCREEN_OFF,
    TYPE_SCREEN_UNLOCK,
    TYPE_SMS_RECEIVED,
    TYPE_SMS_SENT,
    TYPE_TIMEZONE,
    TYPE_TRAFFIC_DATA,
    TYPE_WHATSAPP_SENT,
    TYPE_WHATSAPP_RECEIVED,
    //TYPE_WINDOW_STATE_CHANGED,
    //TYPE_WINDOW_STATE_CHANGED_BASIC,
    TYPE_QUESTIONNAIRE)

  def parseFromDumpAndWriteToParquet(sc:SparkContext, dumpDirPath:String, outputPath:String) = {
    val menthalEvents = PostgresDump.parseDumpFile(sc, dumpDirPath)
    menthalEvents.cache()
    for (eventType ← processedTypes)
      ParquetIO.filterAndWriteToParquet(sc, outputPath, eventType, menthalEvents)
    val windowStateChangeEvents = for {
      e <- menthalEvents
      et = fromMenthalEvent(e)
      if et == TYPE_WINDOW_STATE_CHANGED || et == TYPE_WINDOW_STATE_CHANGED_BASIC
    } yield e.toAvro
    ParquetIO.writeEventType(sc, outputPath, TYPE_WINDOW_STATE_CHANGED, windowStateChangeEvents)

  }

}
