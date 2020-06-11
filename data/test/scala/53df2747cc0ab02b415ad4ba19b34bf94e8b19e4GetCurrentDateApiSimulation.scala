package ru.mchomedev.api.thrift_api.loadtest

import io.gatling.core.Predef.{constantUsersPerSec, jumpToRps, _}
import io.gatling.http.Predef._

import scala.concurrent.duration._

class GetCurrentDateApiSimulation extends ApiSimulationSpecification {

  val basicLoadStepRps = 100
  val basicLoadStepTime = 1 minute
  val successPercent = 85

  val getCurrentDateScenario = scenario("getCurrentDateScenario")
    .exec(http("getCurrentDateRequest").get("/current"))

  setUp(
    getCurrentDateScenario.inject(
      constantUsersPerSec(basicLoadStepRps     ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 2 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 3 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 4 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 5 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 6 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 7 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 8 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 9 ) during(basicLoadStepTime),
      constantUsersPerSec(basicLoadStepRps * 10) during(basicLoadStepTime)
    )
  )
    .throttle(
      jumpToRps(basicLoadStepRps),   holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*2), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*3), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*4), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*5), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*6), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*7), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*8), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*9), holdFor(basicLoadStepTime),
      jumpToRps(basicLoadStepRps*10), holdFor(basicLoadStepTime)
    )
    .protocols(httpConf)
    .assertions(global.successfulRequests.percent.gt(successPercent))
}