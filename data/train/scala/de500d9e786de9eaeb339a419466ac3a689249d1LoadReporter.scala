package org.everpeace.akka.routing

import akka.actor.Actor
import collection.immutable.Queue
import akka.stm.Ref
import akka.stm.atomic

/**
 *
 * User: Shingo Omura <everpeace _at_ gmail _dot_ com>
 * Date: 11/12/16
 */
// actor にこの LoadReporter or LoadReporter の sub trait を mix-in する。
trait LoadReporter {
  this: Actor =>
  protected def requestLoad: Receive = {
    case msg@RequestLoad => self.reply(ReportLoad(reportLoad(reportPresentLoad)))
  }

  // strategy for what value is reported
  protected def reportLoad(reported: Option[Load]): Option[Load] = reported

  // report present load
  // override it yourself!
  protected def reportPresentLoad: Option[Load]
}

// historyLengthのloadの平均値をloadとして返すようなLoadReporter
trait AverageLoadReporter extends LoadReporter {
  this: Actor =>
  protected val historyLength: Int
  assert(historyLength > 0, "hisoryLength must be positive integer.")
  val history: Ref[Queue[Load]] = Ref[Queue[Load]](Queue.empty)

  override protected def reportLoad(reported: Option[Load]) = reported match {
    case Some(load) =>
      atomic {
        if (history.get.length < historyLength) {
          history.alter(_.enqueue(load))
          val historySeq = history().toSeq
          Some(historySeq.reduce(_ + _) / historySeq.length)
        } else {
          history.alter(q => q.dequeue._2)
          history.alter(_.enqueue(load))
          val historySeq = history().toSeq
          Some(historySeq.reduce(_ + _) / historySeq.length)
        }
      }
    case None =>
      atomic {
        history.alter(_ => Queue.empty)
        None
      }
  }
}