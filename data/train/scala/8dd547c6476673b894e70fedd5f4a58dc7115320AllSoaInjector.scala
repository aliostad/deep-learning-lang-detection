package com.orange.cormoran.gatling.scenario

import com.excilys.ebi.gatling.core.Predef._
import com.excilys.ebi.gatling.http.Predef._
import com.orange.cormoran.gatling.util.XMLSourceFeeder

/**
 * scenario: inject all soa files from resources directory using WS
 */
class AllSoaInjector {
  val feeder = new XMLSourceFeeder
  val nb = feeder.fileList.queue.length

  val scn = scenario("Cormoran Base Scenario")
    .feed(feeder.fileList.circular)
    .exec(
    http("xml request").post("/services/ManageCustomerOrder")
      .body("${file}")
      .check(regex( """<customerOrderID>\w+</customerOrderID>""").count.is(1)))
}
