package com.monsanto.arch.kamon.prometheus.demo

import akka.actor.{ActorLogging, Actor, Cancellable, Props}
import akka.event.Logging
import akka.routing._
import spray.http.Uri

import scala.concurrent.duration.{DurationInt, FiniteDuration}

/** Generates load using a router and a pool of workers.
  *
  * @param baseUri the base URI where the server is listening
  *
  * @author Daniel Solano Gómez
  */
class LoadGenerator(baseUri: Uri) extends Actor {
  import LoadGenerator.Message._
  import LoadGenerator._

  /** The router that sends requests off to workers. */
  private val worker = context.actorOf(RoundRobinPool(RouteeCount).props(LoadGeneratorWorker.props(baseUri, self)), "router")
  /** Keep track of scheduled tasks so that they can be cancelled when necessary. */
  var waiters = List.empty[Cancellable]

  override def receive = {
    case GenerateLoad ⇒
      bomb()
      // generate load
      worker ! randomLoad
    case LoadFinished ⇒
      addWaiter(WaitInterval, GenerateLoad)
    case CheckRouter ⇒
      worker ! GetRoutees
    case Routees(routees) ⇒
      if (routees.size < RouteeCount) {
        worker ! AdjustPoolSize(RouteeCount - routees.size)
      }
      addWaiter(RouterCheckInterval, CheckRouter)
  }

  /** Generates some initial load. */
  override def preStart(): Unit = {
    0.until(RouteeCount * RequestsPerRoutee).foreach { i ⇒
      addWaiter(WaitInterval * i * 10, GenerateLoad)
    }
    addWaiter(RouterCheckInterval, CheckRouter)
  }

  /** Cancels any pending scheduled action. */
  override def postStop(): Unit = {
    waiters.foreach(_.cancel())
  }

  /** Chooses a task randomly. */
  private def randomLoad: LoadType = {
    ExplodedLoadTypeDistribution((math.random * ExplodedLoadTypeDistribution.size).toInt)
  }

  private def addWaiter(duration: FiniteDuration, message: Message): Unit = {
    // schedule work for sometime soon (throttles work)
    val newWaiter = context.system.scheduler.scheduleOnce(duration, self, message)(context.dispatcher)
    // manage waiters thread
    waiters = waiters.filterNot(_.isCancelled) :+ newWaiter
  }
}

object LoadGenerator {
  def props(baseUri: Uri): Props = Props(new LoadGenerator(baseUri))

  /** The desired number of routees */
  val RouteeCount = 5
  /** The number of requests per routee. */
  val RequestsPerRoutee = 5

  /** How long to wait between a task finishes and starting a new one. */
  val WaitInterval = 333.milliseconds
  /** How long to wait between each check of the router size. */
  val RouterCheckInterval = 10.seconds

  sealed trait Message
  object Message {
    /** Message to generate load. */
    case object GenerateLoad extends Message
    /** Message that load has been generated. */
    case object LoadFinished extends Message
    case object CheckRouter extends Message
  }

  /** All the different types of load to generate. */
  sealed trait LoadType
  object LoadType {
    case class IncrementCounter(number: Int) extends LoadType
    case object UpdateMinMaxCounter extends LoadType
    case object UpdateHistogram extends LoadType
    case object GetRejection extends LoadType
    case object GetTimeout extends LoadType
    case object GetError extends LoadType
  }

  /** Distribution for choosing which load to generate. */
  val LoadTypeDistribution = Seq(
    6→ LoadType.IncrementCounter(0),
    6→ LoadType.IncrementCounter(1),
    6→ LoadType.IncrementCounter(2),
    6→ LoadType.IncrementCounter(3),
    6 → LoadType.IncrementCounter(4),
    30 → LoadType.UpdateHistogram,
    30 → LoadType.UpdateMinMaxCounter,
    1 → LoadType.GetRejection,
    1 → LoadType.GetTimeout,
    1 → LoadType.GetError
  )

  /** Expanded form of LoadTypeDistribution. */
  val ExplodedLoadTypeDistribution: IndexedSeq[LoadType] = LoadTypeDistribution.flatMap { case(freq, loadType) ⇒
      Seq.fill(freq)(loadType)
  }.toIndexedSeq

  def bomb(): Unit = {
    // randomly fail
    if (math.random < 0.0001) {
      throw new RuntimeException("A random error.")
    }
  }
}
