package net.zhenglai.concurrent.akka

import scala.util.Try

/**
 * Created by zhenglai on 8/17/16.
 */

/*
 * defines all the messages exchanged between our actors
 */
object Messages {

  /*
  Parent trait for all CRUD requests, all of which use a Long key.
   */
  sealed trait Request {
    val key: Long
  }

  case class Create(key: Long, value: String) extends Request

  case class Read(key: Long) extends Request

  case class Update(key: Long, value: String) extends Request

  //
  case class Delete(key: Long) extends Request

  // Wrap responses in a common message
  case class Response(result: Try[String])

  // This message is sent to the ServerActor and it tells it how many workers to create.
  case class Start(numberOfWorkers: Int = 1)

  // Send a message to a worker to simulate a “crash.”
  case class Crash(whichOne: Int)

  // Send a message to “dump” the state of a single worker
  case class Dump(whichOne: Int)

  // Send a message to “dump” the state of all of them.
  case object DumpAll

}

