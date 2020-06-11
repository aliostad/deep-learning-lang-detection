package com.luogh.test.akka

import scala.util.Try

/**
  * @author luogh
  */
object Messages {
  sealed trait Request {
    val key: Long
  }

  case class Create(key: Long, value: String) extends Request
  case class Read(key: Long) extends Request
  case class Update(key: Long, value: String) extends Request
  case class Delete(key: Long) extends Request

  case class Response(result: Try[String])

  case class Start(numOfWorker: Int = 1)
  case class Crash(whichOne: Int)
  case class Dump(whichOne: Int)
  case object DumpAll
}
