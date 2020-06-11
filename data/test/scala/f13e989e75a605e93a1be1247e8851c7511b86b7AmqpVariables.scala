package io.gatling.amqp.config

import akka.actor._
import io.gatling.amqp.infra._
import io.gatling.core.result.writer.StatsEngine

/**
 * preparations for AMQP Server
 */
trait AmqpVariables { this: AmqpProtocol =>
  /**
   * mutable variables (initialized in warmUp)
   */
  private var _system: Option[ActorSystem] = None
  private var _manage: Option[ActorRef]    = None
  private var _nacker: Option[ActorRef]    = None
  private var _router: Option[ActorRef]    = None
  private var _tracer: Option[ActorRef]    = None
  private var _stats : Option[StatsEngine] = None

  def system: ActorSystem = _system.getOrElse{ throw new RuntimeException("ActorSystem is not defined yet") }
  def manage: ActorRef    = _manage.getOrElse{ throw new RuntimeException("manage is not defined yet") }
  def nacker: ActorRef    = _nacker.getOrElse{ throw new RuntimeException("nacker is not defined yet") }
  def router: ActorRef    = _router.getOrElse{ throw new RuntimeException("router is not defined yet") }
  def tracer: ActorRef    = _tracer.getOrElse{ throw new RuntimeException("tracer is not defined yet") }

  def statsEngine : StatsEngine = _stats .getOrElse{ throw new RuntimeException("StatsEngine is not defined yet") }

  protected def setupVariables(system: ActorSystem, statsEngine: StatsEngine): Unit = {
    _system = Some(system)
    _stats  = Some(statsEngine)
    _manage = Some(system.actorOf(AmqpManage.props(statsEngine, this), "AmqpManage"))
    _nacker = Some(system.actorOf(AmqpNacker.props(statsEngine, this), "AmqpNacker"))
    _router = Some(system.actorOf(AmqpRouter.props(statsEngine, this), "AmqpRouter"))
    _tracer = Some(system.actorOf(AmqpTracer.props(statsEngine, this), "AmqpTracer"))
  }
}
