package fr.jbu.asyncperf.integration

import fr.jbu.asyncperf.core.dump.DumpActor
import fr.jbu.asyncperf.core.dump.log.XmlDump
import fr.jbu.asyncperf.core.reporting.csv.FullLog
import fr.jbu.asyncperf.core.reporting.ReportingActor
import fr.jbu.asyncperf.core.injector.http.HttpClientActor
import fr.jbu.asyncperf.core.injector.http.impl.asynchttpclient.HttpClientBasedOnAHC
import fr.jbu.asyncperf.user.api.{Scenario, UserBuilder}
import fr.jbu.asyncperf.user.action.Action
import collection.mutable.ListBuffer
import java.util.concurrent.TimeUnit
import akka.actor.{ActorRef, Actor}
import fr.jbu.asyncperf.user.{UserCommand, User}
import fr.jbu.asyncperf.core.injector.http.impl.netty.HttpClientBasedOnNetty

object SimpleTestOnEmbeddedServer {

  val userBuilder: UserBuilder = new UserBuilder
  val dumpActor: ActorRef = Actor.actorOf(new DumpActor(List(new XmlDump("result/it-test/dump.xml", true)))).start
  val reportingActor: ActorRef = Actor.actorOf(new ReportingActor(List(new FullLog("result/it-test/log.csv")))).start
  //val httpClientActor: ActorRef = Actor.actorOf(new HttpClientActor(new HttpClientBasedOnAHC())).start
  val httpClientActor: ActorRef = Actor.actorOf(new HttpClientActor(new HttpClientBasedOnNetty())).start

  val testScenario: Scenario = new Scenario() {
    def getFunctionSequence = new ListBuffer[(User) => Action]() += httpGet("localhost", 8080, "/") += wait(2, TimeUnit.SECONDS)
  }

  val actorGroup1 = userBuilder.withScenario(testScenario).withDumpActor(dumpActor).withHttpClientActor(httpClientActor).withLogActor(reportingActor).withNbOfExecution(1).buildActor(2)


  def main(args: Array[String]) {
    for(ac <- actorGroup1){
      ac.start
    }
    for(ac <- actorGroup1){
      ac ! UserCommand.START
    }
  }

}