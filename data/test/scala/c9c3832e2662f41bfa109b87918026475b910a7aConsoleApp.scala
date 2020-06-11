package my.finder.console
import akka.actor.{ActorRef, Props, ActorSystem}
import my.finder.console.actor.ConsoleRootActor
import my.finder.common.message._
import com.typesafe.config.ConfigFactory
import java.util.{Scanner}
import my.finder.common.util.{Config, Constants}
import my.finder.console.service.IndexManage
import scala.concurrent.duration._
import scala.concurrent.ExecutionContext.Implicits.global
import my.finder.common.message.CommandParseMessage

/**
 * @author ${user.name}
 */
object ConsoleApp {
  var root:ActorRef = null
  def main(args : Array[String]) {
    Config.init("console.properties")
    IndexManage.init
    val system = ActorSystem.create("console", ConfigFactory.load().getConfig("console"))
    root = system.actorOf(Props[ConsoleRootActor], "root")



    val scanner = new Scanner(System.in)
    var command:String = null
    while(true){
      command = scanner.nextLine()
      if (command == "indexDDProduct") {
        root ! CommandParseMessage(Constants.DD_PRODUCT)
      }
      if (command == "changeIndex") {
        root ! CommandParseMessage("changeIndex")
      }
      if (command == "inc") {

        system.scheduler.scheduleOnce(0 seconds){
          root ! IndexIncremetionalTaskMessage("",null)
        }
      }
    }
  }
}
