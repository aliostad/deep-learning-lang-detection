package akka

import akka.testkit.{TestKitBase, ImplicitSender}
import akka.actor.{Props, ActorSystem}
import model.akka.{Result, SupervisorActor}
import org.scalatest.WordSpecLike
import scala.concurrent.Future
import akka.pattern.Patterns

class MyActorSystemTest extends TestKitBase with ImplicitSender with WordSpecLike {

  implicit lazy val system: ActorSystem = ActorSystem("TestActor")

  val supervisor = system.actorOf(Props[SupervisorActor], "supervisorActor")

  "A supervisor" must {

    "manage number" in {

      supervisor ! 42

      val result: Future[Int] = Patterns.ask(supervisor, new Result, 5000).mapTo[Int]
      //assertResult(Some(42), result.value.get)_
    }
  }
}
