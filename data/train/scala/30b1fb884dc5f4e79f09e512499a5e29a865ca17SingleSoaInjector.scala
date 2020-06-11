package com.orange.cormoran.gatling.scenario

import com.excilys.ebi.gatling.core.Predef._
import com.excilys.ebi.gatling.http.Predef._
import com.orange.cormoran.gatling.util.SingleXMLSourceFeeder

/**
 * scenario: inject a single soa file from resources directory using WS
 */
class SingleSoaInjector(xml: String) {

  val feeder = new SingleXMLSourceFeeder(xml)

  val scn = scenario("Cormoran One Soa")
    .feed(feeder.file.circular)
    .exec(
    http("xml request").post("/services/ManageCustomerOrder")
      .body("${file}")
      .check(regex( """<customerOrderID>\w+</customerOrderID>""").count.is(1)))
}
