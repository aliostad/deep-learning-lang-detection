package eve

import scala.collection.concurrent.TrieMap
import scalaz.stream.{Process, Sink, channel}
import scalaz.concurrent.Task
import scalaz._

import doobie.imports._

import models._
import shared._

case class DBHolder(xa: Transactor[Task]) {
  private val dbs = TrieMap[Process[Task, FleetState], Process[Task, Unit]]()

  def apply(owner: User, p: Process[Task, FleetState]): Process[Task, Unit] = {
    dbs
      .retain({ case (id, process) =>
        ! process.isHalt
      })
      .getOrElseUpdate(p, {
        p.observeThrough(channel.lift(f => FleetHistory.insert(owner, f).transact(xa))).map(_._2)
      })
  }
}
