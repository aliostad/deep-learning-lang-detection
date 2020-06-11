package amazonRobots

import akka.actor.{ActorRef, Actor}
import Protocol._

/**
 * Created by Swaneet on 19.06.2014.
 */
class Renderer(g:Grid, ls:List[ActorRef]) extends Actor {
  import scala.collection.mutable.Map
  val positions:Map[ActorRef,Position] = Map.empty
  def receive = {
    case Update => {
      ls foreach( ref => ref ! Ask )
      println(g)
    }
    case p@Position(x,y) => {
      val actor = sender()
      println(actor.path.name + " is at " + p)
      val maybeOldPos = positions.get(actor)
      lazy val oldPos = maybeOldPos.get
      maybeOldPos match {
        case None => positions.put(actor, p)
        case Some(`oldPos`) => ()
        case Some(newPos) => {
          g.move(oldPos,newPos) // böse
        }
      }
    }
  }

}
