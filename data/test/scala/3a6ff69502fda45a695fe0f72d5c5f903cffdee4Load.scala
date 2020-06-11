package example.server

import java.time.Instant

import com.typesafe.scalalogging.LazyLogging
import example.common.Load


object FakeLoad extends LazyLogging {

  def generate(load: Load) = {
    val cnt = Runtime.getRuntime.availableProcessors
    logger.info(s"targeting $cnt processors with ${load.pct}% load for ${load.time} seconds")
    List.fill(cnt)(
      new Thread(new Runnable {
        val start = Instant.now
        def run() = while (Instant.now isBefore start.plusSeconds(load.time)) {
          // every 100ms pause to sleep for 100-load millis, this generates load level of activity
          if (Instant.now.toEpochMilli % 100 == 0) Thread.sleep(Math.floor((1 - load.pct) * 100).toLong)
        }
      })
    ).foreach(_.run)
  }

}
