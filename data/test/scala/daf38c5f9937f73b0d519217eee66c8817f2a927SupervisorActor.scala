package lectures.concurrent.akka

import akka.actor.SupervisorStrategy.{Resume, Stop}
import akka.actor._
import com.typesafe.config.ConfigFactory

object SupervisorActor {

  def props(): Props = {
    val actorGameCfg = ConfigFactory.load("game").getConfig("game_conf")
    Props(classOf[SupervisorActor], actorGameCfg.getLong("ping_delay"),
      actorGameCfg.getLong("break_delay"),
      actorGameCfg.getInt("ping_for_pong"),
      actorGameCfg.getInt("pong_switch"),
      actorGameCfg.getInt("set_count")
    )
  }
}

class SupervisorActor(pingDelay: Long,
                      breakDelay: Long,
                      pingsForPong: Int,
                      pongsToSwitch: Int,
                      setCountPrm: Int) extends Actor with ActorLogging {

  override val supervisorStrategy = OneForOneStrategy() {
    case p: PongerFailureException => Resume
    case _ => Stop
  }

  override def receive: Receive = {
    case StartTheGame =>
      context.become(manageGame(setCountPrm, sender))
      val ponger = context.actorOf(Worker.props(pingDelay, breakDelay, pingsForPong, pongsToSwitch), "Worker1")
      val pinger = context.actorOf(Worker.props(pingDelay, breakDelay, pingsForPong, pongsToSwitch), "Worker2")
      ponger ! BecomePong()
      pinger ! BecomePing(ponger)
  }

  def manageGame(setCount: Int, starterRef: ActorRef): Receive = {
    case SetFinished(ponger, pinger) if setCount <= 1 =>
      starterRef ! GameFinished
      context stop self
    case SetFinished(ponger, pinger) =>
      context.become(manageGame(setCount - 1,  starterRef))
      ponger ! BecomePing(pinger)
      pinger ! BecomePong()
  }

  override def postStop() = {
    log.info("The game is over!")
    //context.system.shutdown()
  }
}

