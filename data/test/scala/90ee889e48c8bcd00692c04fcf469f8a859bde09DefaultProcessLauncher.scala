package com.seanshubin.utility.exec

import java.nio.charset.{Charset, StandardCharsets}
import java.time.Clock

import scala.concurrent.ExecutionContext.Implicits.global

object DefaultProcessLauncher {
  val createProcessBuilder: () => ProcessBuilderContract = ProcessBuilderDelegate.apply _
  val futureRunner: FutureRunner = new ExecutionContextFutureRunner()
  val clock: Clock = Clock.systemUTC()
  val charset: Charset = StandardCharsets.UTF_8
  val processLauncher: ProcessLauncher = new ProcessLauncherImpl(createProcessBuilder, futureRunner, clock, charset)
}
