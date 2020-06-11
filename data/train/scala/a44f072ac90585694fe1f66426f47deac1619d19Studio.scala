package oiw

import akka.actor.SupervisorStrategy._
import akka.actor._
import oiw.Model._
import oiw.Protocol._
import oiw.Studio._
import spray.routing.RequestContext
import scala.concurrent.duration._
import scala.collection.mutable

object Protocol {
  case class BossGone     (ctx: RequestContext)
  case class NewBoss      (ctx: RequestContext)

  case class ArtistActive (name: String, ctx: RequestContext)
  case class ArtistGone   (name: String)

  case class Disconnect   (producer: String, actor: String)
  case class Connect      (producer: String, actor: String)

  case class OrgStructure (connections: Seq[Connection], labour: Seq[Employee])

  case class Performance
  (direction: String, speed: Int, name: String)
}

object Studio {

  private val prefix = "/user/"
  private val name = "ScalablePictures"

  def secretary(implicit system: ActorRefFactory) =
    system.actorSelection(prefix + name)

  def createBoss(name: String, ctx: RequestContext)
                (implicit system: ActorRefFactory) =
    system.actorOf(Props(new BossInformer(ctx)))

  def createPerformer(name: String, ctx:RequestContext)
                     (implicit system: ActorRefFactory) =
    system.actorOf(Props(new Performer(name, ctx)))

  def initWith(implicit system: ActorSystem) =
    system.actorOf(Props[Secretary], name)

}

class Secretary extends Actor {

  private val bosses      = new mutable.HashMap[RequestContext, ActorRef]()
  private val performers  = new mutable.HashMap[String, ActorRef]()

  private var labour      : Seq[Employee]    = Nil
  private var connections : Seq[Connection]  = Nil

  implicit def employee2Producer(e: Employee) = e.asInstanceOf[Producer]
  implicit def employee2Artist(e: Employee)   = e.asInstanceOf[Artist]

  override val supervisorStrategy =
    OneForOneStrategy(maxNrOfRetries = 10, withinTimeRange = 1 minute) {
      case _: NumberFormatException    => Resume
      case _: NullPointerException     => Restart
      case _: IllegalArgumentException => Stop
      case _: Exception                => Escalate
    }

  override def receive =
      manageBosses orElse
      manageLabour orElse
      manageConnections orElse
      manageCommands

  def manageBosses: Receive = {

    case NewBoss(ctx) =>
      val boss = createBoss("Boss_" + bosses.size, ctx)
      bosses.put(ctx, boss)
      sendOrgStructure(boss)

    case BossGone(ctx) =>
      for { boss <- bosses remove ctx }
        boss ! PoisonPill

  }

  def manageConnections: Receive = {
    case Disconnect(director, performer) =>
      connections = connections filterNot connected(director, performer)
      informBosses()

    case Connect(director, performer) =>
      for {
        from  <- byName(director)
        to    <- byName(performer)
      } {
        connections = connections :+ Connection(from, to)
      }
      informBosses()
  }

  def manageLabour: Receive = {

    case t : Employee =>
      if (!labour.contains(t)) labour = labour :+ t
      informBosses()

    case ArtistActive(name, ctx) =>
      val performer = createPerformer(name, ctx)
      performers.put(name, performer)

    case ArtistGone(artist) =>
      for { ref <- performers remove artist } ref ! PoisonPill

      connections = connections filterNot targeting(artist)
      labour      = labour filterNot ( _.name == artist)

      informBosses()
  }

  def manageCommands: Receive = {

    case command @ Performance(_, _, director) =>
      for {
        receiver    <- connections filter { _.from.name == director }
        performer   <- performers get receiver.to.name
      } performer ! command

  }


  def informBosses() {
    bosses.values foreach sendOrgStructure
  }

  def sendOrgStructure(boss: ActorRef) {
    boss ! OrgStructure(connections, labour)
  }

  def targeting(performer: String) =
    (connection: Connection) => connection.to.name == performer

  def byName(name: String) = labour find { _.name == name }

  def connected(director: String, performer: String) =
    (connection: Connection) => connection.from.name == director && targeting(performer)(connection)

}
