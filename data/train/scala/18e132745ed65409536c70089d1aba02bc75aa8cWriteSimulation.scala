package sims.bolt.boltdata

import actions.bolt.BoltDataActions
import core.BaseSimulation
import feeds.bolt.BoltFeed
import io.gatling.core.Predef._
import io.github.gatling.dse.CqlPredef._
import libs.SimConfig

class WriteSimulation extends BaseSimulation {

  val simGroup = "bolt"
  val simName = "boltData"

  val appConf = new SimConfig(conf, simGroup, simName)

  val boltActions = new BoltDataActions(cass.getSession)

  val writeFeed = new BoltFeed().write
  val writeScenario = scenario("BoltWrite")
      .feed(writeFeed)
      .exec(boltActions.writeBoltData(appConf))

  setUp(
    buildRampConstScenario(writeScenario, appConf)
  ).protocols(cqlConfig)
}