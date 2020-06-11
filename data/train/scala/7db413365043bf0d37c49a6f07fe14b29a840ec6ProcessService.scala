package com.github.unisay.moki

import fs2.{Strategy, Task}

import scala.sys.process._

trait ProcessService {

  val defaultProcessLogger = ProcessLogger(stdout.println(_), stderr.println(_))

  @SuppressWarnings(Array("org.wartremover.warts.DefaultArguments"))
  def processService(arguments: List[String] = Nil, processLogger: ProcessLogger = defaultProcessLogger)
                    (implicit s: Strategy): TestService[Process] =
    TestService(
      start = Task(arguments.run(processLogger)),
      stop = process => Task(if (process.isAlive) process.destroy()))
}

object ProcessService extends ProcessService
