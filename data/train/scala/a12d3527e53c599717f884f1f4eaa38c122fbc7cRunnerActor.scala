package com.futurenotfound.appserve

import akka.actor.Actor
import akka.actor.Actor._
import java.io.File
import sbt.Process._
import sbt.Process
import org.slf4j._

case class RunnerActor(launchLocation: File) extends Actor {
  val logger = LoggerFactory.getLogger(classOf[RunnerActor])
  logger.info("Initializing.")
  val processBuilder = Process(List("java", "-cp", "\"*\"", "com.futurenotfound.appserve.Runner"), launchLocation)
  val process = processBuilder.run()
  logger.info("Running: %s".format(processBuilder))
  def receive = {
    case StopRunner => {
      self.reply(process.destroy())
    }
  }

  override def postStop = {
    println("Destroying process")
    process.destroy()
  }
}

object RunnerActor {
  val timeout = 60 * 1000
}
