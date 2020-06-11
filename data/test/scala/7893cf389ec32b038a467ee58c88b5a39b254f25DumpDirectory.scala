package com.google.code.jgntp.internal

import java.io.{IOException, File}
import java.nio.file.{Paths, Files}
import java.util.concurrent.atomic.AtomicLong

import org.slf4j.Logger

import scala.util.{Failure, Try}

object DumpDirectory {
  val DUMP_MESSAGES_DIRECTORY_PROPERTY: String = "gntp.request.dump.dir"
  val DUMP_MESSAGES_DIRECTORY_PROPERTY_IN: String = "gntp.response.dump.dir"
}


trait DumpDirectory {
  val logger: Logger

  val dumpCounter: AtomicLong = new AtomicLong

  val dumpDirOpt: Option[File] = Option(System.getProperty(DumpDirectory.DUMP_MESSAGES_DIRECTORY_PROPERTY)).flatMap{
    dumpDirName => Try {
      val dumpDir = new File(dumpDirName)
      dumpDir.mkdirs()
      dumpDir
    }.recoverWith { case e: Throwable =>
      logger.warn("Could not get/create GNTP request dump directory, dumping will be disabled", e)
      Failure(e)
    }.toOption
  }

  def dumpBuffer(buffer: Array[Byte]): Unit = {
    dumpDirOpt.foreach { dumpDir =>
      try {
        Files.write(Paths.get(new File(dumpDir, "gntp-request-" + dumpCounter.getAndIncrement + ".out").toURI), buffer)
      }
      catch {
        case e: IOException =>
          logger.warn("Could not save GNTP request dump", e)
      }
    }
  }

  def dumpResponse(buffer: Array[Byte]) = {
    dumpDirOpt.foreach { dumpDir =>
      try {
        val fileName: String = "gntp-response-" + dumpCounter.getAndIncrement + ".out"
        Files.write(Paths.get(new File(dumpDir, fileName).toURI), buffer)
      }
      catch {
        case e: IOException =>
          logger.warn("Could not save GNTP request dump", e)
      }
    }
  }
}
