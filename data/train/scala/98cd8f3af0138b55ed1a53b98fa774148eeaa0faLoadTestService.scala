/*
 * Copyright (C) 2016 Lightbend Inc. <http://www.lightbend.com>
 */
package sample.chirper.load.api

import akka.stream.scaladsl.Source
import akka.{Done, NotUsed}
import com.lightbend.lagom.scaladsl.api.{Descriptor, Service, ServiceCall}

trait LoadTestService extends Service {

  /**
   * Example: src/test/resources/websocket-loadtest.html
   */
  def startLoad(): ServiceCall[NotUsed, Source[String, NotUsed]]

  /**
   * Example: curl http://localhost:21360/loadHeadless -H
   * "Content-Type: application/json" -X POST -d '{"users":2000, "friends":5,
   * "chirps":200000, "clients":20, "parallelism":20}'
   */
  def startLoadHeadless(): ServiceCall[TestParams, NotUsed]

  override def descriptor(): Descriptor = {
  import Service._

    named("/loadtestservice").withCalls(
        namedCall("/load", startLoad _),
        pathCall("/loadHeadless", startLoadHeadless _)
      )

  }
}
