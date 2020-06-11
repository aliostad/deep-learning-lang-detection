package x7c1.wheat.modern.queue.map

import x7c1.wheat.macros.logger.Log
import x7c1.wheat.modern.fate.FateProvider.{ErrorLike, HasContext}
import x7c1.wheat.modern.fate.FutureFate
import x7c1.wheat.modern.fate.FutureFate.HasTimer
import x7c1.wheat.modern.kinds.Fate
import x7c1.wheat.modern.queue.map.TrackableQueue.{CanDump, CanThrow}

import scala.collection.mutable
import scala.concurrent.Promise

trait TrackableQueue[CONTEXT, ERROR, X, Y] {

  def enqueue(value: X): Fate[CONTEXT, ERROR, Y]
}

object TrackableQueue {

  trait CanThrow[X] {
    def asThrowable(x: X): Throwable
  }

  trait CanDump[X] {
    def dump(x: X): String
  }

  def apply[
    C: HasContext : HasTimer,
    E: CanThrow : ErrorLike,
    X: CanDump, Y
  ](
    createQueue: () => GroupingQueue[X],
    callee: X => Y ): TrackableQueue[C, E, X, Y] = {

    new TrackableQueueImpl(createQueue, callee)
  }
}

private class TrackableQueueImpl[
  C: HasContext : HasTimer,
  E: CanThrow : ErrorLike,
  X: CanDump, Y
](
  createQueue: () => GroupingQueue[X],
  callee: X => Y ) extends TrackableQueue[C, E, X, Y] {

  private val map = mutable.Map[X, Promise[Y]]()

  private val queue: DelayedQueue[C, E, X] = {
    DelayedQueue(createQueue, callee, onDequeue)
  }

  private val provide = FutureFate.hold[C, E]

  override def enqueue(value: X): Fate[C, E, Y] = synchronized {
    map get value match {
      case Some(existent) =>
        provide fromPromise existent
      case None =>
        val promise = Promise[Y]()
        map(value) = promise
        queue.enqueue(value) flatMap { unit =>
          provide fromPromise promise
        }
    }
  }

  private lazy val onDequeue: (X, Either[E, Y]) => Unit = (x, either) => synchronized {
    map remove x match {
      case Some(promise) => either match {
        case Left(e) =>
          promise failure implicitly[CanThrow[E]].asThrowable(e)
        case Right(y) =>
          promise success y
      }
      case None =>
        val dumped = implicitly[CanDump[X]] dump x
        Log warn s"not enqueued or already dequeued [$dumped]"
    }
  }
}
